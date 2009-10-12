module AutobotsTransform
  class Table
    attr_accessor :data
    attr_accessor :column_names
    attr_accessor :column_indexes
    
    def initialize(options = {})
      @data = options[:data] || []
      @column_names = options[:column_names] || []
      
      @column_indexes = {}
      @column_names.each_with_index do |name, index|
        @column_indexes[name] = index
      end
      
      # We can take hashes too
      if @data.first.is_a?(Hash)
        rows = []
        @data.each do |datum|
          row = []
          @column_names.each do |name|
            row << datum[name] 
          end
          rows << row
        end
        @data = rows
      end
    end
    
    def sort(columns, options = {})
      sorted = data.sort_by do |row|
        columns.collect do |column| 
          value = row[index_of(column)]
          value = value.to_s.rjust(12, '0') if value.is_a?(Numeric)
          value
        end.join(':')
      end
      
      if options[:order].nil? or options[:order] == :ascending
        @data = sorted
      else
        @data = sorted.reverse
      end
      
      self
    end
    
    def sort_by(options = {}, &block)
      row = Row.new(self)
      sorted = data.sort_by do |datum|
        yield(row.set(datum))
      end
      
      if options[:order].nil? or options[:order] == :ascending
        @data = sorted
      else
        @data = sorted.reverse
      end
      
      self
    end
    
    def group_by(*columns)
      Grouping.new(self, :by => columns)
    end
    
    def where(&block)
      filtered = []
      row = Row.new(self)
      data.each do |datum|
        row = row.set(datum)
        filtered << datum.dup if yield(row)
      end
      
      Table.new(:data => filtered, :column_names => column_names.dup)
    end
    
    def partition(&block)
      first = []
      second = []
      row = Row.new(self)
      data.each do |datum|
        row = row.set(datum)
        
        if yield(row)
          first << datum.dup
        else
          second << datum.dup
        end        
      end
      
      return Table.new(:data => first, :column_names => column_names.dup), \
              Table.new(:data => second, :column_names => column_names.dup)
    end
    
    def distinct(column)
      data.collect{|datum| datum[index_of(column)]}.uniq
    end
    
    def sum(column)
      sum = 0
      data.each{|datum| sum += datum[index_of(column)].to_f}
      sum
    end
    
    def aggregate(initial, &block)
      memo = initial
      data.each do |datum|
        memo = block.call(memo, datum)
      end
      memo
    end
    
    def top(count, columns, options = {})
      top_table = Table.new(:data => data.dup, :column_names => column_names.dup)
      top_table.sort(columns, options)
      top_table.data = top_table.data[0, count] if top_table.data.length > count
      top_table
    end
    
    def append(column, &block)
      @column_names << column
      @column_indexes[column] = @column_names.length - 1
      
      row = Row.new(self)
      data.each do |datum|
        datum << yield(row.set(datum))
      end
      
      self
    end
    
    def transform(column, &block)
      row = Row.new(self)
      data.each do |datum|
        row = row.set(datum)
        row[column] = yield(row[column], row)
      end
      
      self
    end
    
    def pivot(pivot_column, options = {}, &block)
      pivoted_data = []
      
      grouped = group_by([options[:group_by], pivot_column])
      
      pivot_values = distinct(pivot_column)
      group_by_values = distinct(options[:group_by])
      
      group_by_values.each do |group_by_value|
        row = [group_by_value]
        group_group = grouped.groups[group_by_value]
        pivot_values.each do |pivot_value|
          pivot_group = group_group.groups[pivot_value]
          if pivot_group.nil?
            row << nil
          else
            row << block.call(pivot_group) if block_given?
          end
        end
        pivoted_data << row
      end
      
      self.class.new(:data => pivoted_data, :column_names => [options[:group_by], *pivot_values])
    end
    
    def summarize(options = {})
      summary = Summary.new
      
      yield(summary)
      
      row = []
      column_names = []
      summary.columns.each do |column|
        row << column.last.call(self)
      end
      column_names = summary.columns.collect(&:first)
      
      # Doesn't work with subclassing now, changed because
      #  sometimes it was group that was the subclass and it
      #  has a different constructor
      Table.new(:data => [row], :column_names => column_names)
    end
    
    def concat(table)
      table.data.each do |row|
        self << row
      end
    end
    
    def get(row, column)
      index = index_of(column)
      (index.nil? or row.nil?) ? nil : row[index]
    end
    
    def set(row, column, value)
      index = index_of(column)
      row[index_of(column)] = value unless index.nil?
    end
    
    def each(&block)
      row = Row.new(self)
      data.each do |datum|
        block.call(row.set(datum))
      end
    end
    
    def each_with_index(&block)
      row = Row.new(self)
      data.each_with_index do |datum, index|
        block.call(row.set(datum), index)
      end
    end
    
    def first(column = nil)
      if column
        if data.length > 0
          data.first[index_of(column)]
        end
      else
        Row.new(self, data.first)
      end
    end
    
    def last(column = nil)
      if column
        if data.length > 0
          data.last[index_of(column)]
        end
      else
        Row.new(self, data.last)
      end
    end

    def length
      data.length
    end
    
    def index_of(column)
      @column_indexes[column]
    end
    
    def indexed(column)
      indexed = {}
      data.each_with_index do |datum, index|
        value = datum[index_of(column)]
        indexed[value] ||= []
        indexed[value] << index
      end
      indexed
    end
    
    def <<(row)
      @data << row
    end
    
    def +(table)
      @data += table.data
      self
    end
    
    def [](index)
      if index.is_a?(String)
        Row.new(self, data.find{|row| row[0] == index})
      else
        Row.new(self, data[index])
      end
    end
    
    def []=(index, row)
      data[index] = row
    end
    
    def to_s(&block)
      as(:text, &block)
    end
    
    def as(format = :text, options = {}, &block)
      case format
      when :text
        AutobotsTransform::TextFormatter.new(self, options).format
      when :csv
        AutobotsTransform::CsvFormatter.new(self, options).format
      when :xml
        AutobotsTransform::XmlFormatter.new(self, options).format
      when :json
        AutobotsTransform::JsonFormatter.new(self, options).format
      when :yaml
        AutobotsTransform::YamlFormatter.new(self, options).format
      when :gvapi
        AutobotsTransform::GvapiFormatter.new(self, options).format
      end
    end
  end
end
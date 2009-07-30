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
    end
        
    def each(&block)
      data.each(&block)
    end
    
    def sort(columns, options = {})
      sorted = data.sort_by do |row|
        columns.collect{|column| row[index_of(column)]}
      end
      
      if options[:order].nil? or options[:order] == :ascending
        @data = sorted
      else
        @data = sorted.reverse
      end
    end
    
    def sort_by(options = {}, &block)
      sorted = data.sort_by do |row|
        yield(row)
      end
      
      if options[:order].nil? or options[:order] == :ascending
        @data = sorted
      else
        @data = sorted.reverse
      end
    end
    
    def group_by(columns)
      Grouping.new(self, :by => columns)
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
    
    def where(&block)
      filtered = []
      data.each do |datum|
        filtered << datum if yield(datum)
      end
      self.class.new(:data => filtered, :column_names => column_names)
    end
    
    def top(count, columns, options = {})
      top_table = Table.new(:data => data.dup, :column_names => column_names.dup)
      top_table.sort(columns, options)
      top_table.data = top_table.data[0, count] if top_table.data.length > count
      top_table
    end
    
    #
    # Finish this and shit
    #
    def append(column, &block)
      @column_names << column
      @column_indexes[column] = @column_names.length -1
      
      data.each do |datum|
        yield(datum)
      end
    end
    
    def transform(column, &block)
      data.each do |datum|
        datum[index_of(column)] = yield(datum[index_of(column)], datum)
      end
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
    
    def length
      data.length
    end
    
    def index_of(column)
      @column_indexes[column]
    end
    
    def <<(row)
      @data << row
    end
    
    def +(table)
      @data += table.data
      self
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
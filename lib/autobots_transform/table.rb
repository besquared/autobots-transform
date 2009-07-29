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
    
    def add_column(name)
      @column_names << name
      @column_indexes[column_names.length - 1] = name
    end
    
    def each(&block)
      data.each(&block)
    end
    
    def sort_by(&block)
      data.sort_by(&block)
    end
    
    def group_by(columns)
      Grouping.new(self, :by => columns)
    end
    
    def distinct(column)
      data.collect{|datum| datum[@column_indexes[column]]}.uniq
    end
    
    def sum(column)
      sum = 0
      data.each{|datum| sum += datum[@column_indexes[column]].to_f}
      sum
    end
    
    def aggregate(column, initial, &block)
      memo = initial
      data.each do |datum|
        memo = block.call(memo, datum[@column_indexes[column]])
      end
      memo
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
    
    def to_s
      as(:text)
    end
    
    def as(format = :text)
      case format
      when :text
        AutobotsTransform::TextFormatter.new(self).to_s
      end
    end
  end
end
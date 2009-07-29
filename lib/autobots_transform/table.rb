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
    
    def pivot(pivot_column, options = {})
      pivoted_data = []
      pivoted_columns = []
      
      
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
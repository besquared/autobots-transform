module AutobotsTransform
  class Grouping
    attr_accessor :table
    attr_accessor :groups
    
    def initialize(table, options = {})
      @table = table
      @groups = {}
      group_by([options[:by]].flatten)
    end
    
    #
    # Recursive grouping to create nested groups
    #
    def group_by(columns)
      grouped = {}
      
      column = columns.shift
      table.data.each do |datum|
        key = datum[table.column_indexes[column]]
        grouped[key] ||= []
        grouped[key] << datum
      end
      
      grouped.each do |name, rows|
        @groups[name] = Group.new(name, :column_names => table.column_names.dup, :data => rows)
      end
      
      if columns.length > 0
        @groups.each do |name, group|
          @groups[name] = group.group_by(columns.dup)
        end
      end
    end
    
    def summarize(options = {})
      rows = []
      column_names = []
      if options[:order]
        rows = []
        groups.each do |value, group|
          row = []
          options[:order].each do |column|
            row << options[column].call(value, group)
          end
          rows << row
        end
        column_names = options[:order]
      else
        rows = []
        groups.each do |value, group|
          row = []
          options.each do |column, summary|
            row << summary.call(value, group)
          end
          rows << row
        end
        column_names = options.keys
      end
      
      Table.new(:data => rows, :column_names => column_names)
    end
    
    def collect(&block)
      collected = Table.new(:column_names => table.column_names.dup)
            
      @groups.each do |key, group|
        collected += yield(key, group)
      end
      
      collected
    end
    
    def each(&block)
      @groups.each(&block)
    end
    
    def to_s
      stringed = ""
      @groups.each do |name, table|
        stringed += "#{name}:\n#{table.to_s}\n"
      end
      stringed
    end
    
    def [](key)
      groups[key]
    end
  end
end
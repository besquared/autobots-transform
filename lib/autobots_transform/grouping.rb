module AutobotsTransform
  class Grouping
    attr_accessor :table
    attr_accessor :groups
    
    def initialize(table, options = {})
      @table = table
      @groups = {}
      group_by(options[:by])
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
        @groups[name] = Group.new(name, :column_names => table.column_names, :data => rows)
      end
      
      if columns.length > 0
        @groups.each do |name, group|
          @groups[name] = group.group_by(columns.dup)
        end
      end
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
  end
end
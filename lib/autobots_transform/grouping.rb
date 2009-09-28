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
      table.each do |row|
        key = row[column]
        grouped[key] ||= []
        grouped[key] << row.data.dup
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
    
    #
    # grouping.summarize do |summary|
    #   summary.column 'total' do |value, group|
    #     group.sum('field')
    #   end
    # end
    #
    def summarize(options = {})      
      summary = Summary.new
      
      yield(summary)
      
      rows = []
      column_names = []
      groups.each do |value, group|
        row = []
        summary.columns.each do |column|
          row << column.last.call(value, group)
        end
        rows << row
      end
      column_names = summary.columns.collect(&:first)
      
      Table.new(:data => rows, :column_names => column_names)
    end
    
    #
    # We should do this by defering table creation
    #  until after we have yielded everything, then
    #  just taking the columns from the innermost table
    #
    def collect(*column_names, &block)
      column_names = table.column_names.dup if column_names.blank?
      collected = Table.new(:column_names => column_names)
      
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
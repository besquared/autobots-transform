module AutobotsTransform
  class Row
    attr_accessor :table
    attr_accessor :data
    
    def initialize(table, data = nil)
      @table = table
      @data = data
    end
    
    def [](column)
      table.get(data, column)
    end
    
    def []=(column, value)
      table.set(data, column, value)
    end
    
    def set(data)
      @data = data
      self
    end
  end
end
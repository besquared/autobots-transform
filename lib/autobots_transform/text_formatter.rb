module AutobotsTransform
  class TextFormatter
    attr_accessor :table
    
    def initialize(table)
      @table = table
    end
    
    def to_s
      table.data.inspect
    end
  end
end
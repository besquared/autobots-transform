module AutobotsTransform
  class Formatter
    attr_accessor :table
    attr_accessor :options
    
    def initialize(table, options = {})
      @table = table
      @options = options
    end
    
    def format(*args)
      raise NotImplementedError
    end
  end
end
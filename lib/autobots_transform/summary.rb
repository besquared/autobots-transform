module AutobotsTransform
  class Summary
    attr_accessor :columns
    
    def initialize
      @columns = []
    end
    
    def column(name, &block)
      @columns << [name.to_s, block]
    end
    
    def method_missing(method_name, *args, &block)
      column(method_name, &block)
    end
  end
end

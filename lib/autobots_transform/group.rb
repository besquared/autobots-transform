module AutobotsTransform
  class Group < Table
    attr_accessor :name
    
    def initialize(name, options = {})
      @name = name
      super(options)
    end
  end
end
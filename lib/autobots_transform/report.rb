module AutobotsTransform
  class Report
    attr_accessor :options
    attr_accessor :sections
    
    def initialize(options = {})
      @options = options
      @sections = []
    end
    
    def run
      self.class.stages.each do |stage|
        send("build_#{stage}".to_sym)
      end
    end
    
    class << self
      attr_accessor :stages
      
      def stage(name)
        @stages ||= []
        @stages << name
      end
      
      def run(options)
        new(options).run
      end
    end
  end
end
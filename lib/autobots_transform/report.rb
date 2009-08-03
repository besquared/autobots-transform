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
        send("#{stage}".to_sym)
      end
      self.class.sections.each do |section|
        send("build_#{section}".to_sym)
      end
    end
    
    class << self
      attr_accessor :stages
      attr_accessor :sections
      
      def stage(name)
        @stages ||= []
        @stages << name
      end
      
      def section(name)
        @sections ||= []
        @sections << name
      end
      
      def run(options)
        new(options).run
      end
    end
  end
end
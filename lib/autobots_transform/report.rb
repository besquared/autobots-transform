module AutobotsTransform
  class Report
    attr_accessor :options
    attr_accessor :sections
    
    attr_accessor :memory
    
    def initialize(options = {})
      @options = options
      @options[:conditions] ||= {}
      @sections = {}
      @memory = {}
    end
    
    def run
      self.class.stages.each do |stage|
        send("#{stage}".to_sym)
      end
      self.class.sections.each do |section|
        send("build_#{section}".to_sym)
      end
      self
    end
    
    def [](section)
      @sections[section]
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
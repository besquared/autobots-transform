module AutobotsTransform
  class Report
    attr_accessor :options
    attr_accessor :sections
    
    attr_accessor :memory
    
    class_inheritable_accessor :stages
    class_inheritable_accessor :sections
    
    def initialize(options = {})
      @options = options
      @options[:conditions] ||= {}
      @sections = {}
      @memory = {}
    end
    
    def run
      self.class.stages.each do |stage|
        send("#{stage}".to_sym)
      end if self.class.stages
      self.class.sections.each do |section|
        send("build_#{section}".to_sym)
      end if self.class.sections
      self
    end
    
    def [](section)
      @sections[section]
    end
    
    class << self
      def stage(name)
        self.stages ||= []
        self.stages << name
      end
            
      def section(name)
        self.sections ||= []
        self.sections << name
      end
      
      def run(options)
        new(options).run
      end
    end
  end
end
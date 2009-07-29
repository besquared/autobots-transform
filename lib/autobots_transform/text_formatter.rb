module AutobotsTransform
  class TextFormatter
    attr_accessor :table
    
    def initialize(table)
      @table = table
    end
    
    def to_s
      stringy = ""
      stringy += table.column_names.join('|') + "\n"
      stringy += "-" * stringy.length + "\n"
      table.data.each do |datum|
        stringy += datum.join('|') + "\n"
      end
      stringy
    end
  end
end
module AutobotsTransform
  class TextFormatter
    attr_accessor :table
    
    def initialize(table)
      @table = table
    end
    
    def to_s(&block)
      stringy = @table.column_names.join('|') + "\n"
      stringy << "-" * stringy.length + "\n"
      @table.data.each do |datum|
        row = datum
        row = yield(datum) if block_given?
        raise Exception, "Block must return an array of the same size as the input row" if row.nil? || row.size != datum.size
        stringy << row.join('|') + "\n"
      end
      stringy
    end
  end
end
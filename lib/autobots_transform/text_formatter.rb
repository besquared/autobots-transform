module AutobotsTransform
  class TextFormatter
    attr_accessor :table
    
    def initialize(table)
      @table = table
    end
    
    def to_s(&block)
      lengths = []
      
      @table.column_names.each_with_index do |column, index|
        lengths[index] = column.length
      end
      
      @table.data.each do |datum|
        datum.each_with_index do |atom, index|
          length = atom.to_s.length
          lengths[index] = length if length > lengths[index]
        end
      end
      
      total_length = lengths.inject(0){|s, n| s += n}
      total_length += @table.column_names.length * 3 - 1

      output = ""
      
      output << "+" + ("-" * total_length) + "+\n"
      
      @table.column_names.each_with_index do |column, index|
        output << "| " + format_s(column, lengths[index]) + " "
      end
      
      output << "|\n"
      
      output << "+" + ("-" * total_length) + "+\n"
      
      @table.data.each do |datum|        
        row = datum
        row = yield(datum) if block_given?
        raise Exception, "Block must return an array of the same size as the input row" if row.nil? || row.size != datum.size
        
        datum.each_with_index do |atom, index|
          output << "| " + format_s(atom, lengths[index]) + " "
        end
        
        output << "|\n"
      end
      
      output << "+" + ("-" * total_length) + "+\n"
      
      output
    end
  
    def format_s(value, length)    
      value = value.to_s
      diff = length - value.length      
      return value + (" " * diff)
    end
  end  
end
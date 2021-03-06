module AutobotsTransform
  class TextFormatter < Formatter    
    def format      
      lengths = []
      
      @table.column_names.each_with_index do |column, index|
        lengths[index] = column.length
      end
      
      @table.data.each do |datum|
        datum.each_with_index do |atom, index|
          length = atom.inspect.length || 0
          puts "length is nil!" if length.nil?
          puts "lengths[index] is nil! => #{@table.column_names} => #{index}" if lengths[index].nil?
          lengths[index] = length if length > lengths[index]
        end
      end
      
      total_length = lengths.inject(0){|s, n| s += n}
      total_length += @table.column_names.length * 3 - 1
      total_length = 0 if total_length < 0
      
      output = ""
            
      output << "+" + ("-" * total_length) + "+\n"
      
      @table.column_names.each_with_index do |column, index|
        output << "| " + format_s(column, lengths[index]) + " "
      end
      
      output << "|\n"
      
      output << "+" + ("-" * total_length) + "+\n"
      
      @table.data.each do |datum|        
        datum.each_with_index do |atom, index|
          output << "| " + format_s(atom, lengths[index]) + " "
        end
        
        output << "|\n"
      end
      
      output << "+" + ("-" * total_length) + "+\n"
      
      output
    end
  
    def format_s(value, length)
      if value.is_a?(Array)
        value = value.inspect
      else
        value = value.to_s
      end

      diff = length - value.length
      return value + (" " * diff)
    end
  end  
end
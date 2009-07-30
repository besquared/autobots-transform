module AutobotsTransform
  class JsonFormatter < Formatter    
    def format
      encoder = Yajl::Encoder.new(:pretty => true)
      column_names = @table.column_names
      table_hash = {}
      table_hash[:rows] = []
      @table.data.each do |datum|
        hash = {}
        column_names.size.times do |i|
           hash[column_names[i]] = datum[i]
        end
        table_hash[:rows] << hash
      end
      table_hash = {:table => table_hash}
      encoder.encode(table_hash)
    end
  end
end

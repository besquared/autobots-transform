module AutobotsTransform
  class JsonFormatter
    attr_accessor :table
    
    def initialize(table)
      @table = table
    end
    
    def to_json
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

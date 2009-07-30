module AutobotsTransform
  class YamlFormatter < Formatter    
    def format
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
      YAML.dump(table_hash)
    end
  end
end

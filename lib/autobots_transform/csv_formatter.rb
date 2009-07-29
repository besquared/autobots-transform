module AutobotsTransform
  class CsvFormatter
    attr_accessor :table
    
    def initialize(table)
      @table = table
    end
    
    def to_csv
      FasterCSV.generate do |csv|
        csv << table.column_names
        table.data.each do |datum|
          csv << datum
        end
      end
    end
  end
end

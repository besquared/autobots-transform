module AutobotsTransform
  class CsvFormatter
    attr_accessor :table
    
    def initialize(table)
      @table = table
    end
    
    def to_csv
      FasterCSV.generate do |csv|
        csv << table.column_names.join(',')
        table.data.each do |datum|
          csv << datum.join(',') + "\n"
        end
      end
    end
  end
end

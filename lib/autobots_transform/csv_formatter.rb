module AutobotsTransform
  class CsvFormatter
    attr_accessor :table
    
    def initialize(table)
      @table = table
    end
    
    def to_csv(&block)
      if RUBY_VERSION.include?('1.9')
        klass = CSV
      else
        klass = FasterCSV
      end
      
      klass.generate do |csv|
        csv << table.column_names
        table.data.each do |datum|
          csv << datum
        end
      end
    end
  end
end

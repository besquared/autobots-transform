module AutobotsTransform
  class CsvFormatter
    def format
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

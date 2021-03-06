module AutobotsTransform
  class XmlFormatter < Formatter
    def format
      column_names = @table.column_names
      Nokogiri::XML::Builder.new do |xml|
        xml.root do
          xml.table do
            @table.data.each do |datum|
              xml.row do
                column_names.size.times do |i|
                  xml.send(column_names[i], datum[i])
                end
              end
            end
          end
        end
      end.to_xml
    end
  end
end
module AutobotsTransform
  class GvapiFormatter < Formatter
    #
    # options = {
    #   :datatypes => {'hour' => 'datetime', ...},
    #   :labels => {'hour' => 'Hour'}
    # }
    #
    # To make this really work we need metadata
    #  attached to this table that gives us more information
    def format
      rows = []
      table.data.each do |datum|
        cells = []
        table.column_names.each do |column|
          cells << {:v => datum[table.index_of(column)]}
        end
        rows << cells
      end
      rows
    end
  end
end

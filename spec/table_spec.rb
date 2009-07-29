require File.join(File.dirname(__FILE__), 'spec_helper')

describe AutobotsTransform::Table do
  before(:each) do
    raw = [
      ['1', '1', '150'], 
      ['1', '2', '200'],
      ['1', '1', '100'], 
      ['1', '3', '200'],
      ['2', '2', '150'],
      ['2', '3', '250']
    ]
    
    @table = AutobotsTransform::Table.new(
      :data => raw,
      :column_names => ['hour', 'agent', 'balance']
    )
  end
  
  it "should pivot properly" do
    puts @table.pivot('hour', :group_by => 'agent') do |rows|
      rows.sum('balance')
    end
  end
end
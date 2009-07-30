require File.join(File.dirname(__FILE__), 'spec_helper')

describe AutobotsTransform::GvapiFormatter do
  before(:each) do
    raw = [
      ['1', '1', '150'], 
      ['2', '3', '250']
    ]
    
    @table = AutobotsTransform::Table.new(
      :data => raw,
      :column_names => ['hour', 'agent', 'balance']
    )
  end
  
  it "should format" do
    puts @table.as(:gvapi).inspect
  end
end
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
  
  it "should get distinct values" do
    @table.distinct('hour').sort.should == ['1', '2']
  end
  
  it "should pivot" do
    pivoted = @table.pivot('hour', :group_by => 'agent') do |rows|
      rows.sum('balance')
    end
    pivoted.column_names.should == ['agent', '1', '2']
    pivoted.data.length.should == 3
    pivoted.data.should == [
      ['1', 250.0, nil], ['2', 200.0, 150.0], ['3', 200.0, 250.0]
    ]
  end
  
  it "should aggregate" do
    aggregated = @table.aggregate(0) do |memo, row|
      memo += row[@table.index_of('hour')].to_i
    end
    aggregated.should == 8
  end
  
  it "should filter" do
    filtered = @table.where do |row|
      row[@table.index_of('hour')] == '2' and row[@table.index_of('agent')] == '2'
    end
    filtered.length.should == 1
    filtered.data.first.should == ['2', '2', '150']
  end
end
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
  
  it "should sort" do
    @table.sort(['balance', 'agent'], :order => :descending)
    @table.data.first[@table.index_of('balance')].should == '250'
  end
  
  it "should sort_by" do
    @table.sort_by(:order => :ascending) do |row|
      (row['agent'] + row['balance']).to_i
    end
    @table[0]['agent'].should == '1'
    @table[0]['balance'].should == '100'
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
      row['hour'] == '2' and row['agent'] == '2'
    end
    filtered.length.should == 1
    filtered[0].data.should == ['2', '2', '150']
  end
  
  it "should find top" do
    top_balance = @table.top(1, 'balance', :order => :descending)
    top_balance.length.should == 1
    top_balance.data.first.should == ['2', '3', '250']
  end
  
  it "should transform" do
    @table.transform('balance'){|balance, row| balance.to_f * 1000}
    @table.data.first.last.should == 150000.0
  end
  
  it "should append" do
    @table.append('adjusted_balance'){|row| row['balance'].to_f * 1000}
    @table.data.first.last.should == 150000.0
  end
end
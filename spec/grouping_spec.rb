require File.join(File.dirname(__FILE__), 'spec_helper')

describe AutobotsTransform::Grouping do
  before(:each) do
    raw = [
      ['1', '1', '150'], 
      ['2', '3', '250']
    ]
    
    @table = AutobotsTransform::Table.new(
      :data => raw,
      :column_names => ['hour', 'agent', 'balance']
    )
    
    @grouping = AutobotsTransform::Grouping.new(
      @table, :by => 'hour'
    )
  end
  
  it "should be grouped" do
    @grouping.groups.length.should == 2
    @grouping.groups['1'].length.should == 1
    @grouping.groups['2'].length.should == 1
  end
  
  it "should summarize" do
    summarized = @grouping.summarize(
      'hour' => lambda{|hour, group| group.sum('balance')}, 
      'agent' => lambda{|agent, group| group.sum('agent')}
    )

    summarized.length.should == 2
    summarized.data.first.should == [150.0, 1.0]
    summarized.data.last.should == [250.0, 3.0]
  end
end
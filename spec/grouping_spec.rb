require File.join(File.dirname(__FILE__), 'spec_helper')

describe AutobotsTransform::Grouping do
  before(:each) do
    raw = [
      ['1', '1', '150'], 
      ['2', '3', '250']
    ]
    
    @table = AutobotsTransform::Table.new(
      :data => raw, :column_names => ['hour', 'agent', 'balance']
    )
    
    @grouping = AutobotsTransform::Grouping.new(@table, :by => 'hour')
  end
  
  it "should be grouped" do
    @grouping.groups.length.should == 2
    @grouping.groups['1'].length.should == 1
    @grouping.groups['2'].length.should == 1
  end
  
  it "should summarize" do
    summarized = @grouping.summarize do |summary|
      summary.balance{|hour, group| group.sum('balance')}
      summary.agent{|hour, group| group.sum('agent')}
    end

    summarized.length.should == 2
    summarized.data.first.should == [150.0, 1.0]
    summarized.data.last.should == [250.0, 3.0]
  end
  
  it "should collect" do
    collected = @grouping.collect do |hour, by_hour|
      by_hour.summarize do |summary|
        summary.hour{hour}
        summary.balance{|table| table.sum('balance')}
        summary.agent{|table| table.sum('agent')}
      end
    end
    
    collected.length.should == 2
    collected.data.first.should == ['1', 150.0, 1.0]
    collected.data.last.should == ['2', 250.0, 3.0]
  end
  
  it "should overload []" do
    hour1 = @grouping['1']
    hour1.length.should == 1
    hour1.data.first.should == ['1', '1', '150']
  end
end
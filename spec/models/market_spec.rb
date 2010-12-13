require 'spec_helper'

describe Market do
  before(:each) do
    @outcomes = [Outcome.new(:description => 'Outcome 1')]
    @invalid_outcomes = [Outcome.new()]
  end
  
  it "should require a name" do
    Market.new(:outcomes => @outcomes).should_not be_valid
  end
  
  it "should have a unique name" do
    m = Market.new(:name => 'fake name', :outcomes => @outcomes)
    m.should be_valid
    m.save
    
    Market.new(:name => 'fake name', :outcomes => @outcomes).should_not be_valid
  end
  
  it "should have outcomes" do
    Market.new(:name => 'fake name').should_not be_valid
  end
  
  
  it "should have at least one outcomes" do
    Market.new(:name => 'fake name', :outcomes => []).should_not be_valid
  end
  
  
  it "should have valid outcomes" do
    Market.new(:name => 'fake name', :outcomes => @invalid_outcomes).should_not be_valid
  end
end

require 'spec_helper'

describe Market do
  before(:each) do
    @outcomes = [Outcome.new(:description => 'Outcome 1', :start_price => 100)]
    @invalid_outcomes = [Outcome.new()]
    
  end
  
  it "should require a name" do
    market = Market.new(:outcomes => @outcomes)
    market.should_not be_valid
    market.errors.on(:name).should == "can't be blank"
  end

  it "should require name, outcomes, start date" do
    m = Market.new(:name => 'fake name', :outcomes => @outcomes, :start_date => '12/12/2010')
  end
  
  it "should have a unique name" do
    m = Market.new(:name => 'fake name', :outcomes => @outcomes,  :start_date => '12/12/2010')
    m.should be_valid
    m.save

    Market.new(:name => 'fake name', :outcomes => @outcomes,  :start_date => '12/12/2010').should_not be_valid
  end
  
  it "should have outcomes" do
    Market.new(:name => 'fake name',  :start_date => '12/12/2010').should_not be_valid
  end
  
  
  it "should have at least one outcomes" do
    Market.new(:name => 'fake name', :outcomes => [],  :start_date => '12/12/2010').should_not be_valid
  end
  
  
  it "should have valid outcomes" do
    Market.new(:name => 'fake name', :outcomes => @invalid_outcomes, :start_date => '12/12/2010').should_not be_valid
  end
  
  it "should not be valid if its outcomes have a total start_price of 98" do
    outcomes_98 = [
      Outcome.new(:description => 'Outcome 1', :start_price => 66),
      Outcome.new(:description => 'Outcome 2', :start_price => 30),
      Outcome.new(:description => 'Outcome 3', :start_price => 2)
    ]
  
    market = Market.new(:name => 'fake name', :outcomes => outcomes_98, :start_date => '12/12/2010')
    market.should_not be_valid
    market.errors.on(:outcomes).should == "start prices must total 100"
  end
  
  it "should not be valid if its outcomes have a duplicate name" do
    outcomes_with_duplicate_name = [
      Outcome.new(:description => 'Outcome 1', :start_price => 50),
      Outcome.new(:description => 'Outcome 2', :start_price => 40),
      Outcome.new(:description => 'Outcome 1', :start_price => 10)
    ]
  
    market = Market.new(:name => 'fake name', :outcomes => outcomes_with_duplicate_name, :start_date => '12/12/2010')
    market.should_not be_valid
    market.errors.on(:outcomes).should == "must have unique names"
  end
end

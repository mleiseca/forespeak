require 'spec_helper'

describe Market do
  it "should require a name" do
    Market.new().should_not be_valid
  end
  
  it "should have a unique name" do
    m = Market.new(:name => 'fake name')
    m.should be_valid
    m.save
    
    Market.new(:name => 'fake name').should_not be_valid
  end
end

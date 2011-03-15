require 'spec_helper'

describe Outcome do

  before(:each) do
    @market   = Factory.build(:market)
    @outcome1 = Factory.build(:outcome, :description =>"Outcome1")
    @outcome2 = Factory.build(:outcome, :description =>"Outcome2")
    
    @market.outcomes = [@outcome1, @outcome2]
    
    @market.save!
    
  end

  describe "all_user_positions" do
    it "should return an empty array if there have been no transactions" do
      @outcome1.all_user_positions.size.should == 0
    end

  #   it "should return the most recent positions for each user" do
  #     
  # 
  #     
  #   end
  end
  
end

require 'spec_helper'

describe Bookie do
  before(:each) do
    @outcome1 = mock "Outcome"
    @outcome2 = mock "Outcome"
    
    @outcome1_share_count = 50
    @outcome1.stub!(:shares_purchased).and_return(@outcome1_share_count)
    @outcome1.stub!(:id).and_return(1)
    
    @outcome2.stub!(:shares_purchased).and_return(100)
    @outcome2.stub!(:id).and_return(2)
    
    @all_outcomes = [@outcome1, @outcome2]
        
    @outcome1.stub!(:market_outcomes).and_return(@all_outcomes)
    @outcome2.stub!(:market_outcomes).and_return(@all_outcomes)

    market = mock('market')
    market.stub!(:last_transaction_date, Time.now)
    @outcome1.stub!(:market).and_return(market)
    @outcome2.stub!(:market).and_return(market)
    
    
    @bookie = Bookie.new(@outcome1)
    
  end

  describe "buying" do
    it "should raise an ArgumentError if trying to buy negative number of shares" do
      lambda {@bookie.buy_cost(-10)}.should raise_error(ArgumentError)
    end 
  
    it "should cost > $0 to buy 1 share" do
       @bookie.buy_cost( 1).should be > 1
    end

    it "should cost the same to buy 20 shares at once or 10 share 2 times" do
    
      twenty_share_cost = @bookie.buy_cost(20)
    
      total = 0
      2.times do
        number_of_shares_to_buy = 10
        total += @bookie.buy_cost( number_of_shares_to_buy) 
        @outcome1_share_count += number_of_shares_to_buy
        @outcome1.stub!(:shares_purchased).and_return(@outcome1_share_count)
      end
    
      twenty_share_cost.should == total
    end
  
    it "should cost $... to buy 10 shares of outcome 1" do
      @bookie.buy_cost( 10).should be_within(1).of(27)
    end
  end
  
   
  describe "selling" do
    it "should raise an ArgumentError if trying to sell negative number of shares" do
      lambda {@bookie.sell_price(-10)}.should raise_error(ArgumentError)
    end 
  
    it "should cost > $0 to buy 1 share" do
       @bookie.sell_price(1).should be > 1
    end

    it "should cost the same to sell 20 shares at once or 10 share 2 times" do
    
      twenty_share_cost = @bookie.sell_price(20)
    
      total = 0
      2.times do
        number_of_shares_to_sell = 10
        total += @bookie.sell_price( number_of_shares_to_sell) 
        @outcome1_share_count -= number_of_shares_to_sell
        @outcome1.stub!(:shares_purchased).and_return(@outcome1_share_count)
      end
    
      twenty_share_cost.should == total
    end
  
    it "should cost $... to buy 10 shares of outcome 1" do
      @bookie.sell_price( 10).should be_within(1).of(22)
    end
  end
  
  
end
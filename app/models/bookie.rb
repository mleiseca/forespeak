require 'logger'

require "bigdecimal"
require "bigdecimal/math"

include BigMath
  
class Bookie
  
  B = BigDecimal.new('20')
  
  # returns a price for the number of shares
  def buy_cost(all_market_outcomes, target_outcome, number_of_shares)
    if (number_of_shares< 0)
      raise ArgumentError, "can't buy fewer than 10 shares"
    end
    
    return price_calculator(all_market_outcomes, target_outcome, number_of_shares)
  end
  
  private 
  
  # delta_shares - positive means buy, negative means sell
  def price_calculator(all_market_outcomes, target_outcome, delta_shares)

    # http://blog.oddhead.com/2006/10/30/implementing-hansons-market-maker/
    #     The market maker keeps track of how many shares have been purchased by traders in total so far for each outcome: 
    #     that is, the number of shares outstanding for each outcome. 

    # Let q1 and q2 be the number (“quantity”) of shares outstanding for each of the two outcomes. 
    # The market maker also maintains a cost function C(q1,q2) which records how much money traders have collectively spent so far, 
    # and depends only on the number of shares outstanding, q1 and q2. 
    # For LMSR, the cost function is:

    # C = b * ln(e^(q1/b)+e^(q2/b))

    # where “ln” is the natural logarithm function, 
    # “e” is the constant e=2.718…, and 
    # “b” is a parameter that the market maker must choose. 
    # The parameter “b” controls the maximum possible amount of money the market maker can lose 
    # (which happens to be b*ln2 in the two-outcome case). 
    # The larger “b” is, the more money the market maker can lose. 
    # But a larger “b” also means the market has more liquidity or depth, meaning that traders can buy more shares at 
    # or near the current price without causing massive price swings.

    sum_of_current_costs = 0
    sum_of_future_costs = 0
    all_market_outcomes.each do |o|
      current_shares_purchased = [o.shares_purchased, B].max
      future_shares_purchased  = current_shares_purchased
      
      if o.id == target_outcome.id
        Rails.logger.info "For found same outcome"
        future_shares_purchased += delta_shares
      end
          
      sum_of_current_costs += BigMath.exp(BigDecimal.new(current_shares_purchased.to_s) / B, 10)
      sum_of_future_costs  += BigMath.exp(BigDecimal.new(future_shares_purchased.to_s) / B, 10)
    end
    
    future_cost  = (B * Math.log(sum_of_future_costs))
    current_cost = (B * Math.log(sum_of_current_costs))
    cost = future_cost - current_cost
    Rails.logger.info "Found cost: #{future_cost} (#{sum_of_future_costs}) - #{current_cost} (#{sum_of_current_costs}) = #{cost}"
    
    cost * 100
  end
end
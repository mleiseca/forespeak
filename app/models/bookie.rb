require 'logger'

require "bigdecimal"
require "bigdecimal/math"

include BigMath
  
class Bookie
  
  B = BigDecimal.new('50')
  
  def initialize(outcome)
    @target_outcome = outcome
  end
  
  
  # memcached
  def data_cache(key)
    unless output = Rails.cache.read(key)
      output = yield
      Rails.cache.write(key, output)
    end
    return output
  end
  
  # returns a price for the number of shares
  def buy_cost(number_of_shares)
    if (number_of_shares< 0)
      raise ArgumentError, "can't buy fewer than 10 shares"
    end
    
    return data_cache("buy outcome: #{@target_outcome.id} count: #{number_of_shares}") { price_calculator(number_of_shares) }
  end
  
  def sell_price(number_of_shares)
    if (number_of_shares< 0)
      raise ArgumentError, "can't sell fewer than 10 shares"
    end
    
    return data_cache("sell outcome: #{@target_outcome.id} count: #{number_of_shares}") { -1 * price_calculator(-1 * number_of_shares) }
    
  end
  
  private 
  
  # delta_shares - positive means buy, negative means sell
  def price_calculator(delta_shares)

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

    Rails.logger.info("Recalculating prices for #{@target_outcome.id}")
    sum_of_current_costs = 100
    sum_of_future_costs = 100
    @target_outcome.market.outcomes.each do |o|
      current_shares_purchased = [o.shares_purchased, B].max
      future_shares_purchased  = current_shares_purchased
      
      if o.id == @target_outcome.id
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
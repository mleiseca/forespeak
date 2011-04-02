require 'logger'

require "bigdecimal"
require "bigdecimal/math"

include BigMath
  
class Bookie
    
  def initialize(outcome)
    @target_outcome = outcome
  end
  
  # returns a price for the number of shares
  def buy_cost(number_of_shares)
    if (number_of_shares< 0)
      raise ArgumentError, "can't buy fewer than 10 shares"
    end
    
    return Rails.cache.fetch("buy_o#{@target_outcome.id}_c#{number_of_shares}_ts#{@target_outcome.market.last_transaction_date}") { price_calculator(number_of_shares) }
  end
  
  def sell_price(number_of_shares)
    if (number_of_shares< 0)
      raise ArgumentError, "can't sell fewer than 10 shares"
    end
    
    return Rails.cache.fetch("sell_o#{@target_outcome.id}_c#{number_of_shares}_ts#{@target_outcome.market.last_transaction_date}") { -1 * price_calculator(-1 * number_of_shares) }
    
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
    
    current_shares_amounts = []
    future_shares_amounts   = []
     
    Rails.logger.info "Aggregating market outcomes"
    
    @target_outcome.market_outcomes.each do |o|
      current_shares_purchased = o.shares_purchased
      future_shares_purchased  = current_shares_purchased
      
      if o.id == @target_outcome.id
        Rails.logger.info "For found same outcome"
        future_shares_purchased += delta_shares
      end
          
      current_shares_amounts.push(current_shares_purchased)
      future_shares_amounts.push(future_shares_purchased)
    end

    Rails.logger.info "Summing market outcomes"
    
    sum_of_current_amounts = current_shares_amounts.inject(0){|sum, x| x+sum}
    sum_of_future_amounts  = future_shares_amounts.inject(0){|sum, x | x+sum}

    b_tmp = [[sum_of_current_amounts, sum_of_future_amounts].min, 16].max
    
    b = BigDecimal.new(Math.sqrt(b_tmp).to_s)
      
    Rails.logger.info "***** b: #{b} (#{sum_of_current_amounts},  #{sum_of_future_amounts})"

    calc_current_costs = current_shares_amounts.inject(100.0){| sum, x| sum + BigMath.exp(BigDecimal.new(x.to_s) / b, 10)}
    calc_future_costs = future_shares_amounts.inject(100.0){|sum, x| sum + BigMath.exp(BigDecimal.new(x.to_s) / b, 10)}

    
    future_cost  = (b * Math.log(calc_future_costs))
    current_cost = (b * Math.log(calc_current_costs))
    cost = future_cost - current_cost
    
    if delta_shares > 0
      cost *= 1.07
    else
      cost *= 0.93    
    end
    # Rails.logger.info "Found cost: #{future_cost} (#{sum_of_future_costs}) - #{current_cost} (#{sum_of_current_costs}) = #{cost}"
    
    cost * 100
  end
end
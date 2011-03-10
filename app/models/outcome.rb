class Outcome < ActiveRecord::Base
  validates_presence_of :description
  # validates_numericality_of :start_price
  
  has_many :positions
  belongs_to :market
  
  
  E = 2.718
  B = 50
  
  SHARES_TO_PURCHASE = 10
  SHARES_AVAILABLE = 1000
  
  def sell_price(share_count=nil)
    if share_count.nil?
      share_count = SHARES_TO_PURCHASE
    end
    return price_calculator(-1 * share_count)
  end
  
  
  def buy_price(share_count=nil)
    if share_count.nil?
      share_count = SHARES_TO_PURCHASE
    end
    return price_calculator(share_count)
  end
  
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

    sum_of_current_costs = 0
    sum_of_future_costs = 0
    market.outcomes.each do |o|
      shares_purchased = o.shares_purchased
      if o.id == id
        logger.info "For found same outcome"
        shares_purchased += delta_shares
      end
    
      sum_of_current_costs += (E ** (o.shares_purchased / B))
      sum_of_future_costs += (E ** (shares_purchased / B))
    end
    
    future_cost  = (B * Math.log(sum_of_future_costs))
    current_cost = (B * Math.log(sum_of_current_costs))
    cost = future_cost - current_cost
    logger.info "******************** #{description} Found cost: #{future_cost} (#{sum_of_future_costs}) - #{current_cost} (#{sum_of_current_costs}) = #{cost}"
    
    cost * (100 / delta_shares)
  end

  def shares_purchased
    positions = all_user_positions

    total_purchased = 0
    positions.each do |position| 
      total_purchased = total_purchased + position.total_user_shares
    end
    
    total_purchased
  end
  
  def shares_available
    SHARES_AVAILABLE - shares_purchased
  end
  
  def all_user_positions
    users = User.find( :all, :select => 'DISTINCT users.id ' , :joins => :positions, :conditions => ['positions.outcome_id = ?', id])
    
    positions = []
    users.each do |user| 
      positions.push position_for_user(user)
    end

    positions
  end
  
  
  def position_for_user(user)
    position = Position.last(:conditions => ["outcome_id = ? and user_id = ?", id, user.id])
  end
end

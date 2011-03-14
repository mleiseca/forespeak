class Outcome < ActiveRecord::Base
  validates_presence_of :description
  # validates_numericality_of :start_price
  
  has_many :positions
  belongs_to :market
 
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
  
  # todo: needs test
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

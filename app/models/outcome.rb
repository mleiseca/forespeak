require_dependency 'position'

class Outcome < ActiveRecord::Base
  validates_presence_of :description
  # validates_numericality_of :start_price
  
  has_many :positions
  belongs_to :market
 
  SHARES_TO_PURCHASE = 10
  SHARES_AVAILABLE = 10000
  
  def bookie
    if ! @bookie 
      @bookie = Bookie.new(self)
    end
    @bookie
  end
  
  def sell_price(share_count=nil)
    if share_count.nil?
      share_count = SHARES_TO_PURCHASE
    end
    return bookie.sell_price(share_count) / share_count
  end
  
  
  def buy_price(share_count=nil)
    if share_count.nil?
      share_count = SHARES_TO_PURCHASE
    end
    return bookie.buy_cost(share_count) / share_count
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
    
    # note: this caching is a big performance saver
    Rails.cache.fetch("p_o#{id}_all_ts#{market.last_transaction_date}") do
      users = User.find( :all, :select => 'DISTINCT users.id ' , :joins => :positions, :conditions => ['positions.outcome_id = ?', id])
    
      positions = []
      users.each do |user| 
        positions.push position_for_user(user)
      end

      positions
    end
  end
  
  
  def position_for_user(user)
    Rails.cache.fetch("p_o#{id}_u#{user.id}_ts#{market.last_transaction_date}") do
      Position.last(:conditions => ["outcome_id = ? and user_id = ?", id, user.id])
    end
  end
end

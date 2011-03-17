class User < ActiveRecord::Base
  # attr_accessible :username, :email
  
  validates_presence_of :username, :email  
  
  acts_as_authentic
  
  has_many :assignments
  has_many :roles, :through => :assignments

  has_many :positions
   
  scope :actors ,       :conditions => ['username != ?', 'admin']
  scope :unconfirmed,   where(:confirmed => false)
  scope :confirmed,     where(:confirmed => true)

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
  
  def all_positions_value
    
    # todo: named_scope?
    active_markets = Market.find(:all, :conditions => ['end_date is null'])    
    
    total = 0
    # todo: what's the nice ruby way to do this?
    active_markets.each do |market|
      market.outcomes.each do |outcome|
        position = outcome.position_for_user(self)
        if ! position.nil?
          total += position.total_user_shares * ((outcome.buy_price + outcome.sell_price) /2)
        end
      end      
    end

    
    total
    
  end
end

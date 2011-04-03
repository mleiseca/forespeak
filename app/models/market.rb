
class OutcomeValidator < ActiveModel::Validator
  def validate(record)
    # this requires that:
    #  - all the outcomes have a start_price and 
    #  - those start prices add to 100
    
    if record.outcomes.nil? or record.outcomes.empty?
      # there is someone else making sure that we have outcomes
      return
    end

    outcome_descriptions = []
    current_total = 0
    if record.outcomes.size < 2
      record.errors[:outcomes] << "more than one outcome is required"      
    end
  end
end

def cache_numbers
  logger.info("recalcing market #{id}")
  outcomes.each do |o|
    o.all_user_positions
    o.buy_price
    o.sell_price
  end
end

class Market < ActiveRecord::Base
  has_many :outcomes
  belongs_to :position, :foreign_key => 'last_transaction_position_id'
  
  validates_associated :outcomes
  
  validates_presence_of :name ,:start_date, :last_trade_allowed_date

  # todo: should this be added back? not sure how to use this with factory girl...
  # validates_uniqueness_of :name

  validates_presence_of :outcomes
  validates_with OutcomeValidator
  
  
  accepts_nested_attributes_for :outcomes, :reject_if => lambda { |a| a[:description].blank? }

  def last_transaction_date
    if self.position 
      self.position.created_at
    else
      nil
    end
  end
  def had_sale(position)
    self.position = position
    
    self.delay.cache_numbers    
  end
  
  def is_closed
    self.last_trade_allowed_date.utc < DateTime.now.utc
  end
end

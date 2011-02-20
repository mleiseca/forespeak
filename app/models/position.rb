class UserSufficientFundsValidator < ActiveModel::Validator
  def validate(record)
    # this requires that:
    #  - all the outcomes have a start_price and 
    #  - those start prices add to 100
    
    if record.user.nil? 
      # there is someone else making sure that we have a user
      return
    end

    cash_after_transaction = record.user.cash + record.delta_user_account_value
    
    if cash_after_transaction < 0
      record.errors[:user] << "you have insufficient funds"
    end
      
  end
end


class Position < ActiveRecord::Base

  belongs_to :user
  belongs_to :outcome
  
  validates_presence_of :user
  validates_presence_of :outcome
  
  validates_numericality_of :delta_user_shares
  validates_numericality_of :delta_user_account_value  
  validates_numericality_of :total_user_shares  
  validates_numericality_of :outcome_price
  
  validates_with UserSufficientFundsValidator
  
  
  # validates_inclusion_of :type, :in => %w(buy sell)
end


class OutcomeStartPriceValidator < ActiveModel::Validator
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
    record.outcomes.each do |o|
      if not o.start_price.nil?
        current_total += o.start_price
      end
      if outcome_descriptions.include?(o.description)
        record.errors[:outcomes] << "Outcomes must have unique names"
      end
      outcome_descriptions << o.description
    end 
    
    if current_total != 100 
      record.errors[:outcomes] << "Outcome start prices must total 100"
    end
  end
end



class Market < ActiveRecord::Base
  has_many :outcomes
  validates_associated :outcomes
  
  validates_presence_of :name ,:start_date
  
  validates_uniqueness_of :name

  validates_presence_of :outcomes
  validates_with OutcomeStartPriceValidator
  
  
  accepts_nested_attributes_for :outcomes, :reject_if => lambda { |a| a[:description].blank? }
end

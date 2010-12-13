class Market < ActiveRecord::Base
  has_many :outcomes
  validates_associated :outcomes
  
  validates_presence_of :name ,:start_date
  
  validates_uniqueness_of :name

  validates_presence_of :outcomes
  
  accepts_nested_attributes_for :outcomes, :reject_if => lambda { |a| a[:description].blank? }
end
class Outcome < ActiveRecord::Base
  validates_presence_of :description
  validates_numericality_of :start_price
end

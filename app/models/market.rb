class Market < ActiveRecord::Base
  has_many :outcomes
  validates_associated :outcomes
  
  validates_presence_of :name  
  
  validates_uniqueness_of :name


# belongs in the outcome class
  # belongs_to :order
  #   validates_presence_of :order_id
  
  # validates_each :name, :surname do |model, attr, value|
  #   model.errors.add(attr, 'must start with upper case') if value =~ /\A[a-z]/
  # end
end

# 
#  validates_with GoodnessValidator
# end
#  
# class GoodnessValidator < ActiveRecord::Validator
#   def validate
#     if record.first_name == "Evil"
#       record.errors[:base] << "This person is evil"
#     end
#   end
# end
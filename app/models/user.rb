class User < ActiveRecord::Base
  # attr_accessible :username, :email
  
  validates_presence_of :username, :email  
  
  acts_as_authentic
end

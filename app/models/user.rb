class User < ActiveRecord::Base
  # attr_accessible :username, :email
  
  validates_presence_of :username, :email  
  
  acts_as_authentic
  
  has_many :assignments
  has_many :roles, :through => :assignments

  has_many :positions

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
end

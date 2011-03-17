class UserSession < Authlogic::Session::Base  
  
  # http://smsohan.blogspot.com/2010/04/using-authlogic-and-single-access-token.html
  # params_key :api_key
  single_access_allowed_request_types :any
    
  def to_key
     self.keys.to_a
  end
  
   def persisted?
     !(new_record? || destroyed?)
   end
end
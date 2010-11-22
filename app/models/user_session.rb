class UserSession < Authlogic::Session::Base  
  def to_key
     self.keys.to_a
  end
  
   def persisted?
     !(new_record? || destroyed?)
   end
end
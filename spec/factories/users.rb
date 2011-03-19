Factory.define :trader, :class => User do |user| 
  
    user.password  'flimflam'
    user.password_confirmation  'flimflam'
    user.confirmed  true
    user.admin false
    user.username 'TestUser'
    user.email "testuser@example.com"
end
Factory.define :trader, :class => User do |user| 
  
    user.password  'flimflam'
    user.password_confirmation  'flimflam'
    user.confirmed  true
    user.admin false
    user.username 'TraderUser'
    user.email "traderuser@example.com"
end


Factory.define :admin, :class => User do |user| 
  
    user.password  'flimflam'
    user.password_confirmation  'flimflam'
    user.confirmed  true
    user.admin true
    user.username 'AdminUser'
    user.email "adminuser@example.com"
end
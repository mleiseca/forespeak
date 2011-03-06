namespace :bootstrap do
  desc "Add the default user"
  task :default_user => :environment do
    u = User.new( :username => 'admin', :email => 'none@notavaliddomain.com', :password => 'foofoo12345',:password_confirmation=>'foofoo12345' )
    u.confirmed = true
    u.admin = true
    u.save
  end
end
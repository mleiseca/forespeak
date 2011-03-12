set :application, "forespeak"
set :repository,  "git@github.com:mleiseca/forespeak.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "deployer"  # The server's user for deploys
# set :scm_passphrase, "dfkj3m3m390**"  # The deploy user's password

ssh_options[:forward_agent] = true

set :use_sudo, false
set :branch, "master"
set :deploy_via, :remote_cache

# role :web, "50-56-92-95.static.cloud-ips.com"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

server "50-56-92-95.static.cloud-ips.com", :app, :web, :db, :primary => true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end


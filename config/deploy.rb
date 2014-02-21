
# -- SCP
set :repository, "."
set :scm, :none 
set :deploy_via, :copy

set :user, "admin"

ssh_options[:keys] = [File.join(ENV["HOME"], ".ec2", "gsg-keypair")]

server "ec2-54-214-60-39.us-west-2.compute.amazonaws.com", :web, :app, :db, primary: true 

set :application, "geminabox"


# The :deploy_to directory needs to referenced in the following files:
# /etc/nginx/conf.d/#{application}.conf"
# /etc/init.d/unicorn-#{application}"
# config/unicorn.rb

set :deploy_to, "/srv/prod/apps/#{application}"
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do

  task :setup_http, roles: :app do
    nginx_path = '/etc/nginx'
    sudo "ln -nfs #{current_path}/config/nginx.conf #{nginx_path}/sites-available/#{application}"
    sudo "ln -nfs #{nginx_path}/sites-available/#{application} #{nginx_path}/sites-enabled/#{application}"
  
    # Unicorn setup
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn-#{application}"
  
  end
  #after "deploy:setup", "deploy:setup_http"
  after "deploy:bundle_install_binstubs", "deploy:setup_http"



  desc "Restart Application"  
  task :reload_httpd do  
    sudo "/etc/init.d/nginx reload"
    sudo "chmod a+x #{current_path}/config/unicorn_init.sh"
    sudo "/etc/init.d/unicorn-#{application} restart"
  end
  #after :deploy, "deploy:reload_httpd"
  after "deploy:setup_http", "deploy:reload_httpd"


  task :bundle_install_binstubs, roles: :app do
    run "cd #{release_path} && rvm use system && bundle install --binstubs"
  end
  after "deploy", "deploy:bundle_install_binstubs"


  desc "Create symlinks for config files and public/uploads"
  task :symlink_config, roles: :app do
    run "mkdir -p #{release_path}/config"
    config_files = %w{ users.htpasswd }
    config_files.each do |cfg|
      run "ln -nfs #{shared_path}/config/#{cfg} #{release_path}/config/#{cfg}"
    end
  end
  after "deploy:finalize_update", "deploy:symlink_config"


end


namespace :custom do
  task :setup_shared, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/gems"
    config_files = %w{ users.htpasswd }
    config_files.each do |cfg|
      cfg_file = "config/#{cfg}"
      upload("shared/#{cfg_file}", "#{shared_path}/#{cfg_file}", via: :scp) #if File.exists? "shared/#{cfg_file}"
    end
  end
  before "deploy:setup", "custom:setup_shared"
end


=begin
#!/bin/bash

# ----- Geminabox
#See: https://dev.tscolari.me/2013/01/08/build-your-own-private-gem-server/
#See: http://velenux.wordpress.com/2012/01/10/running-sinatra-and-other-rack-apps-on-nginx-unicorn/


# run geminabox on an EC2 instance with nginx and unicorn
# NOTE: requires ruby 1.9.3

# access at http://user:abuser@ec2-54-214-60-39.us-west-2.compute.amazonaws.com/gems/

# install gems
rvm use system
gem install geminabox unicorn --no-ri --no-rdoc

# make directories
mkdir -p /srv/prod/apps/geminabox/current
mkdir -p /srv/prod/apps/geminabox/shared/gems
mkdir -p /srv/prod/apps/geminabox/shared/pids
mkdir -p /srv/prod/apps/geminabox/shared/log
mkdir -p /srv/prod/apps/geminabox/shared/config
chown admin.admin /srv/prod/apps/geminabox -R

# copy configuration files
cp config/* /srv/prod/apps/geminabox/shared/config
cp current/* /srv/prod/apps/geminabox/current

# Copy nginx config
cp etc/geminabox /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/geminabox /etc/nginx/sites-enabled/geminabox

# Copy unicorn startup script

=end


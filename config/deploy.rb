# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'ngems'
set :repo_url, 'git@github.com:rjayroach/gembox.git'
set :deploy_to, "/srv/prod/apps/#{fetch(:application)}"

# Default value for :log_level is :debug
# set :log_level, :info

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{bin log tmp vendor/bundle} #public/system public/uploads public/cache}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# See: https://github.com/capistrano/rbenv
set :rbenv_type, :user
set :rbenv_ruby, '1.9.3-p484'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value


set :nginx_etc_path, '/etc/nginx'
set :initd_path, '/etc/init.d'

# these are read by the custom unicorn tasks defined in
# lib/capistrano/tasks/unicorn.cap
set :unicorn_pid, shared_path.join("tmp/unicorn.pid")
set :unicorn_script, "#{fetch(:initd_path)}/unicorn-#{fetch(:application)}"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

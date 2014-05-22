# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'gembox'
set :repo_url, 'git@github.com:rjayroach/gembox.git'
set :deploy_to, "/srv/apps/#{fetch(:application)}"
set :branch, 'master'

# Default value for :log_level is :debug
# set :log_level, :info

# Default value for :linked_files is []
set :linked_files, %w{.env}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{bin log tmp vendor/bundle gems/public gems/private} #public/system public/uploads public/cache}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5



#set :nginx_etc_path, '/etc/nginx'
#set :initd_path, '/etc/init.d'

# these are read by the custom unicorn tasks defined in
# lib/capistrano/tasks/unicorn.cap
#set :unicorn_pid, shared_path.join("tmp/unicorn.pid")
#set :unicorn_script, "#{fetch(:initd_path)}/unicorn-#{fetch(:application)}"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :kill, "--signal USR2 $(<\"#{release_path.join('tmp/pids/unicorn.pid')}\")"
    end
  end

  after :publishing, :restart

  # See: https://github.com/capistrano/rbenv
  set :rbenv_type, :user
  set :rbenv_ruby, '2.1.2'
  set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
  set :rbenv_map_bins, %w{rake gem bundle ruby rails}
  set :rbenv_roles, :all # default value

end


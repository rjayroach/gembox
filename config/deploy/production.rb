set :stage, :production

#server 'rubygems.maxcole.com',
server 'staging.maxcole.com',
  user: fetch(:application),
  roles: %w{web app db},
  ssh_options: {
    #verbose: :debug, # add this to find exact issue when your deployment fails
    forward_agent: true
  }


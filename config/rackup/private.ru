require "bundler/setup"
require "rubygems"
require "geminabox"
require 'dotenv'
Dotenv.load

Geminabox.build_legacy = false

Geminabox.data = "/srv/apps/gembox/shared/gems/private"

use Rack::Auth::Basic, "Geminabox" do |username, password|
  username == ENV['username'] and password == ENV['password']
end

run Geminabox::Server

require "bundler/setup"
require "rubygems"
require "geminabox"

Geminabox.build_legacy = false

Geminabox.data = "/srv/prod/apps/gembox/shared/gems/private"

use Rack::Auth::Basic, "Geminabox" do |username, password|
  username == 'xcrazy' and password == 'eight'
end

run Geminabox::Server

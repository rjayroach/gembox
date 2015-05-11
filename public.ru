#require "bundler/setup"
require "rubygems"
require "geminabox"

Geminabox.build_legacy = false
Geminabox.rubygems_proxy = true

# carry on providing gems when rubygems.org is unavailable:
Geminabox.allow_remote_failure = true

Geminabox.data = "/data"

run Geminabox::Server


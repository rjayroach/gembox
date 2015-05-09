require "bundler/setup"
require "rubygems"
require "geminabox"

Geminabox.build_legacy = false
Geminabox.rubygems_proxy = true

Geminabox.data = "/data"

run Geminabox::Server


require "bundler/setup"
require "rubygems"
require "geminabox"

Geminabox.build_legacy = false
Geminabox.rubygems_proxy = true

Geminabox.data = "/srv/apps/gembox/shared/gems/public"


Geminabox::Server.helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      halt 401, "No pushing or deleting without auth.\n"
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['newuser', 'abuser']
  end
end

Geminabox::Server.before '/upload' do
  protected!
end

Geminabox::Server.before do
  protected! if request.delete?
end

Geminabox::Server.before '/api/v1/gems' do
  unless env['HTTP_AUTHORIZATION'] == 'API_KEY'
    halt 401, "Access Denied. Api_key invalid or missing.\n"
  end
end

run Geminabox::Server


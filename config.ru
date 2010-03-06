require 'appengine-rack'
AppEngine::Rack.configure_app(
  :application => 'application-id',
  :version => 1)
require 'twigithub'
run Sinatra::Application
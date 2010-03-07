require 'appengine-rack'
AppEngine::Rack.configure_app(
  :application => 'twgithub',
  :version => 1)
require 'twigithub'
run Sinatra::Application
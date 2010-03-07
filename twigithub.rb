require 'sinatra'
require File.join(File.dirname(__FILE__),'github')

# Make sure our template can use <%=h
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

CONFIG = File.join(File.dirname(__FILE__),'github.yml')

get '/' do
  github = Github.new(CONFIG)
  @projects = github.list
  @collaborators ={}
  @projects.each {|project| @collaborators[project[:name]] = github.collaborators(project[:name])}
  erb :index
end

post '/add_user' do
  Github.new(CONFIG).add_collaborator(params)
  redirect '/'
end

post '/create_repo' do
  github = Github.new(CONFIG)
  github.create_repo(params)
  github.add_collaborator(params)
  redirect '/'
end

post '/delete_user' do
  github = Github.new(CONFIG)
  github.remove_collaborator(params)
  redirect '/'
end

post '/delete_repo' do
  github = Github.new(CONFIG)
  github.delete_repo(params)
  redirect '/'
end

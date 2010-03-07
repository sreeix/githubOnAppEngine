require 'sinatra'
require File.join(File.dirname(__FILE__),'Twgithub','lib','github')



# Make sure our template can use <%=h
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  # Just list all the shouts
  @projects = Github.new(File.join(File.dirname(__FILE__),'Twgithub','github.yml')).list
  erb :index
end

post '/' do
  redirect '/'
end

post '/add_user' do
  Github.new(File.join(File.dirname(__FILE__),'Twgithub','github.yml')).add_collaborator(params)
  redirect '/'
end
post '/api/*.*' do
  puts "PARAMS are #{params["splat"]}"
  redirect '/'
end

get '/api/*.*' do
  puts "We are in a get."
    puts params["splat"]
    redirect '/'
end

__END__

@@ index
<html>
  <head>
    <title>Shoutout!</title>
  </head>
  <body style="font-family: sans-serif;">
    <h1>View all TWI repos</h1>

    <ul>
    <% @projects.each do |project| %>
      <li><a href='<%=project[:url]%>'><%=project[:name]%></a></li>
    <% end %>
    </ul>
    
    <h1> Add me to the repo </h1>
    <form action="add_user" method='post'>
      <input type="text" name="collaborator"></input>
      <select name="name">
       <%@projects.each do |project| %>
        <option> <%=project[:name]%>  </option>      
       <% end %>
      </select>
      <input type='submit' value='Add me to the repo'/>
    </form>
    
    <div style="position: absolute; bottom: 20px; right: 20px;">
    <img src="/images/appengine.gif"></div>
  </body>
</html>
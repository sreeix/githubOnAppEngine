require 'sinatra'
require File.join(File.dirname(__FILE__),'github')



# Make sure our template can use <%=h
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  # Just list all the shouts
  @projects = Github.new(File.join(File.dirname(__FILE__),'github.yml')).list
  erb :index
end

post '/' do
  redirect '/'
end

post '/add_user' do
  Github.new(File.join(File.dirname(__FILE__),'github.yml')).add_collaborator(params)
  redirect '/'
end

post '/create_repo' do
  github = Github.new(File.join(File.dirname(__FILE__),'github.yml'))
  github.create_repo(params)
  github.add_collaborator(params)
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
    
    <h1> Add Yourself to the repo </h1>
    <form action="add_user" method='post'>
      <label>Your github id</label>
      <input type="text" name="collaborator"></input>
      <label>Project</label>
      <select name="name">
       <%@projects.each do |project| %>
        <option> <%=project[:name]%>  </option>      
       <% end %>
      </select>
      <input type='submit' value='Add me to the repo'/>
    </form>

    <h1> Add a new repo </h1>
    <form action="create_repo" method='post'>
      <label>Your github id</label>
      <input type="text" name="collaborator"></input>

      <label>Name of the repo</label>
      <input type="text" name="name"></input>

      <label>Private or </label>
      <input type="radio" name="visibility" value="public"/>Public
      <input type="radio" name="visibility" value="private"/>Private
      <input type='submit' value='Create a new repo'/>
    </form>
    
  </body>
</html>
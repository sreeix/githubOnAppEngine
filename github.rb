require 'yaml'
require 'net/http'

class Github
  def initialize(config)
    doc=YAML::load(File.read(config))
    @user_name=doc[:user_name]
    @api_key=doc[:api_key]
    # RestClient.log="/tmp/restclient.log"
  end
  def list
    response = AppEngine::URLFetch.fetch("http://github.com/api/v2/yaml/repos/show/#{ @user_name}?login=#{@user_name}&token=#{@api_key}") 
    YAML::load(response.body)["repositories"]
  end

  def collaborators(project)
    
    response = AppEngine::URLFetch.fetch("http://github.com/api/v2/yaml/repos/show/#{@user_name}/#{project}/collaborators?login=#{@user_name}&token=#{@api_key}") 
    YAML::load(response.body)["collaborators"]
  end
  
  def create_repo(opts={ })
    puts opts.inspect
    post 'http://github.com/api/v2/yaml/repos/create',{:login=>@user_name,:token=>@api_key,:name=>opts[:name], :public=> (opts[:visibility]== 'public' ? "1":"0")}
  end

  def delete_repo(opts={ })
    url="http://github.com/api/v2/yaml/repos/delete/#{opts[:name]}"
    response = post url,:login=>@user_name,:token=>@api_key
    delete_token=YAML::load(response.to_s)["delete_token"]
    post url,{:login=>@user_name,:token=>@api_key,:delete_token=>delete_token}
  end

  def add_collaborator(options)
    url="http://github.com/api/v2/yaml/repos/collaborators/#{options[:name]}/add/#{options[:collaborator]}"
    post url, {:token=>@api_key, :login=>@user_name}
  end
  
  
  
  def post(url, options={})
     import java.net.HttpURLConnection;
     import java.net.MalformedURLException;
     import java.net.URL;
     import java.net.URLEncoder;
     import java.io.BufferedReader;
     import java.io.InputStreamReader;
     import java.io.IOException;
     import java.io.OutputStreamWriter;
      
     url = URL.new(options.keys.inject(url+"?"){|url, key|url+= "#{key}=#{options[key]}&"});
     connection =  url.openConnection();
     connection.setDoOutput(true);
     
     connection.setRequestMethod("POST");
     connection.setRequestProperty("token", options[:token]);
     connection.setRequestProperty("login", options[:login]);

     puts connection.getResponseCode

       rd = BufferedReader.new InputStreamReader.new(connection.getInputStream())
     line=""
     content=""
     while(not (line = rd.read_line).nil? ) 
       content << line << "\n"
     end
     rd.close
     puts content
     content     
   end
  
end

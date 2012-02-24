require 'fssm'
require 'logger'
require 'httparty'
require 'yaml'

CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/config.yml") unless defined? CONFIG

log = Logger.new("application.log")

class MoviesCatalog
 include HTTParty
 format :json
 base_uri 'localhost:3000'	
end

begin
	FSSM.monitor(CONFIG["path"],CONFIG["pattern"],:directories=>true) do
	create do |base,relative,type| 
		if type == :directory
			log.info("Creating #{relative}")  	
			result = MoviesCatalog.post("/movies/new", :body => {:names => [relative]})
			#TODO: Convert body to josn to get the result
			log.info("Created #{relative}") if result && result.response.body == "success"
		end 
	end
	delete do |base,relative,type|
		if type == :directory
			log.info("Deleting #{relative}")
			result = MoviesCatalog.delete("/movies/destroy", :body => {:name => relative})
			#TODO: Convert body to josn to get the result 
			log.info("Deleted #{relative}") if result && result.response.body == "success"
		end
	end
	update {|base,relative,type| }#Don't do nothing
end	 
rescue Exception => e
	log.fatal(e)	 
end




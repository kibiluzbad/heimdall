require 'fssm'
require 'logger'
require 'httparty'

log = Logger.new("application.log")

class MoviesCatalog
 include HTTParty
 format :json
 base_uri 'localhost:3000'	
end

begin
	FSSM.monitor("/home/leonardo/temp/","**",:directories=>true) do
	create do |base,relative,type| 
		if type == :directory
			log.info("Creating #{relative}")  	
			result = MoviesCatalog.post("/movies/create", :body => {:names => [relative]})
			log.info("Created #{relative}") if result && result.reponse.body == "success"
		end 
	end
	delete do |base,relative,type|
		if type == :directory
			log.info("Deleting #{relative}")
			result = MoviesCatalog.delete("/movies/destroy", :body => {:name => relative})
			log.info("Deleted #{relative}") if result && result.reponse.body == "success"
		end
	end
	update {|base,relative,type| }#Don't do nothing
end	 
rescue Exception => e
	log.fatal(e)	 
end




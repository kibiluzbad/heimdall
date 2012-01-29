require 'fssm'
require 'logger'

log = Logger.new("application.log")

begin
	FSSM.monitor("/home/leonardo/temp/","**",:directories=>true) do
	create do |base,relative,type| 
		if type == :directory
			log.info("Creating #{relative}")  	
			#TODO: Call create movie web service
			log.info("Created #{relative}")
		end 
	end
	delete do |base,relative,type|
		if type == :directory
			log.info("Deleting #{relative}")
			#TODO: Call delete movie web service
			log.info("Deleted #{relative}") 
		end
	end
	update {|base,relative,type| }#Don't do nothing
end	 
rescue Exception => e
	log.fatal(e)	 
end




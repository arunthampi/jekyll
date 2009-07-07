require 'rexml/document'

module Jekyll
  module WordpressXml
    
    def self.process(input_file = 'posts.xml')
      FileUtils.mkdir_p "_posts"
      wordpress_xml_doc = REXML::Document.new(File.new(input_file))
      
    end
    
  end
  
end
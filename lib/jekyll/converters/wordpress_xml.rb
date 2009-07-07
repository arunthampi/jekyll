require 'rubygems'
require 'hpricot'
require 'chronic'

module Jekyll
  module WordpressXml
    
    def self.process(input_file = 'posts.xml')
      FileUtils.mkdir_p "_posts"
      wordpress_xml_doc = open(input_file) { |f| Hpricot(f) }
      (wordpress_xml_doc/'channel/item').each do |blog|
        next if (blog/'wp:status').first.innerHTML == 'draft' ||
                (blog/'wp:post_type').first.innerHTML != 'post'
        
        title = (blog/'title').first.innerHTML
        slug = (blog/'wp:post_name').first.innerHTML
        content = (blog/'content:encoded').first.innerHTML
        excerpt = (blog/'excerpt:encoded').first.innerHTML
        guid = (blog/'guid').first.innerHTML
        id = (blog/'wp:post_id').first.innerHTML
        
        date = Chronic.parse((blog/'wp:post_date').first.innerHTML)
        name = "%02d-%02d-%02d-%s.markdown" % [date.year, date.month, date.day,
                                               slug]
        
        # Get the relevant fields as a hash, delete empty fields and convert
        # to YAML for the header
        data = {
          'layout' => 'post',
          'title' => title.to_s,
          'excerpt' => excerpt.to_s,
          'wordpress_id' => id,
          'wordpress_url' => guid
        }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

        # Write out the data and content to file
        File.open("_posts/#{name}", "w") do |f|
          f.puts data
          f.puts "---"
          f.puts content
        end
      end
    end
  end
end
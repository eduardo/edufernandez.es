require "rubygems"
require "open-uri"

module Rack
  class GistToCode
    include Rack::Utils
    
    def initialize app
      @app = app
    end

    def call env
      status, headers, response = @app.call env
      headers = HeaderHash.new(headers)
      
      if is_rss?(headers)
        body = replace_gists(response.body)
        response.body = body
        headers['Content-Length'] = body.length.to_s
      end
      
      [status, headers, response]
    end
    
    def is_rss?(headers)
      headers['Content-Type'].include?('application/xml')
    end
    
    def get_gist id, file_name
      file_name = "gistfile1.cs" unless file_name != nil
      gist = ""

      open("http://gist.github.com/raw/#{id}/#{file_name}") do |f|
        f.each do |line|
          gist += line
        end
      end

      escape_html gist
    end

    def replace_gists article
      fixed_article = ""
      
      article.each do |line|
        scripts = line.scan(/&lt;script src=\"http:\/\/gist.github.com.*?&lt;\/script&gt;/)
        scripts.each do |script|
          
          id_match = script.match(/.com\/(.*).js/)
          file_match = script.match(/file=(.*)"&gt;/)
          gist_id = id_match[1] unless id_match == nil
          gist_file = file_match[1] unless file_match == nil
          code = "&lt;pre&gt;&lt;code&gt;" + get_gist(gist_id, gist_file) + "&lt;/code&gt;&lt;/pre&gt;"
            
          line = line.gsub(script, code)
        end unless scripts == nil
        fixed_article += line
      end
      fixed_article
    end
    
  end
end










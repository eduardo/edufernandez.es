require "toto"
#require "gist_to_code"
require 'coderay'
require 'rack/codehighlighter'
require 'haml'
# Rack config
#use Rack::GistToCode
use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => true
use Rack::Static, :urls => ['/css', '/js', '/images', '/gfx', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  # 
  set :author,    "Edu Fernández"                           # blog author
  set :title,     "edufernandez.es"   	                      # site title
  set :url,       "http://edufernandez.es"                      # site root URL
  set :prefix,    ""                                          # common path prefix for all pages
  set :date,      lambda {|now| now.strftime("%d-%m-%Y") }  # date format for articles
  # set :markdown,  :smart                                    # use markdown + smart-mode
  set :disqus,    "edufernandez"                                 # disqus id, or false
  set :summary,   :max => 150, :delim => /~/                # length of article summary and delimiter
  set :ext,       'md'                                        # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds

  set :date, lambda {|now| now.strftime("%d-%m-%Y") }
  
  set :to_html,     lambda {|path, page, ctx|
     ::Haml::Engine.new(File.read("#{path}/#{page}.haml"), :format => :html5, :ugly => false).render(ctx)
   }
end

run toto

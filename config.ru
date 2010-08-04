
require 'toto'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/gfx', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end
use Rack::ShowExceptions
#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  # 
  set :author,    "Thomas Pedersen"                           # blog author
  set :title,     "thedersen.com"   	                      # site title
  set :url,       "http://thedersen.com"                      # site root URL
  set :feed,      "http://feeds.feedburner.com/thedersen"     # site feed URL
  set :prefix,    ""                                          # common path prefix for all pages
  # set :date,      lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
  # set :markdown,  :smart                                    # use markdown + smart-mode
  set :disqus,    "thedersen"                                 # disqus id, or false
  # set :summary,   :max => 150, :delim => /~/                # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds

  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
end

run toto



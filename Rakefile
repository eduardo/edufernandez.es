require 'toto'

@config = Toto::Config::Defaults

task :default => :new

desc "Create a new article."
task :new do
  title = ask('Title: ')
  slug = title.empty?? nil : title.strip.slugize

  article = {'title' => title, 'date' => Time.now.strftime("%d/%m/%Y")}.to_yaml
  article << "\n"
  article << "Once upon a time...\n\n"

  path = "#{Toto::Paths[:articles]}/#{Time.now.strftime("%Y-%m-%d")}#{'-' + slug if slug}.md"

  unless File.exist? path
    File.open(path, "w") do |file|
      file.write article
    end
    toto "an article was created for you at #{path}."
    `mate #{path}`
  else
    toto "I can't create the article, #{path} already exists."
  end
end

desc "Publish my blog."
task :publish do
  toto "publishing your article(s)..."
  `git push heroku master`
  Rake::Task['ping_feed'].execute 
end

desc "Pinging feedburner.com"
task :ping_feed do
  toto "pinging feedburner.com..."
  require 'net/http'
  require 'uri'
  res = Net::HTTP.get('feedburner.google.com','/fb/a/pingSubmit?bloglink=' + URI.escape('http://feeds.feedburner.com/edufernandez'))
  if res.include? "Succesfully pinged"
    toto "Succesfully pinged"
  else
    toto "Pinging failed"
  end
end

desc "Start the thin server."
task :start do
  `thin start -R config.ru`
end

def toto msg
  puts "\n  toto ~ #{msg}\n\n"
end

def ask message
  print message
  STDIN.gets.chomp
end


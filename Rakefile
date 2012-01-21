# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rake'
require 'rake/testtask'
require './blag'

namespace :blag do
  desc "Creates the file manifest"
  task :manifest do
    columns   = `tput cols`.to_i - 10
    articles  = Dir[File.join(BLAG_ROOT, "articles", "*")]
    
    Manifest.new do
      articles.each.with_index do |article, index|
        print "Adding articles: #{(((index+1).to_f/articles.length) * 100).to_i}%\t(#{article})"[0...columns].ljust(columns, " ") << "\r"
        add_article article
      end
    end
    puts "", "Done"
  end
  

end
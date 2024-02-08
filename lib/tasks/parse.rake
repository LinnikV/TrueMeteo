require 'io/console'
require_relative '../assets/news/parser'

namespace :app do
  desc "Parse News"
  task :parse_news => :environment do

    Parser.new("lol")
 end
end
require 'io/console'
require_relative '../assets/news/parser'

namespace :app do
  desc "Parse News"
  task :parse_news => :environment do
    NewsManager.new.call("1")
  end
end
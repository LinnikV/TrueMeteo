require_relative '../news/parser'
require_relative '../news/scraper'

class NewsManager
  def call(admin)
    message = []
    scraper = Scraper.new
    parser = Parser.new(scraper.connect_to_main_page)
    hash = parser.get_link_and_header
    hash.each do |row|
      parser = Parser.new(scraper.connect_to_article(row[:link]))
      article = parser.parse_article
      row.merge!({article: article})
      news = News.new(
        title: row[:title],
        body: row[:article],
        date: row[:date],
        source: row[:link],
        header: row[:header],
        image: row[:img],
        publish: true,
        admin_id: admin
      ) #unless PG::UniqueViolation
      
      if news.valid?
        message << news.save
      else 
        message << news.errors.messages
      end
      message
    end
    message
  end
end

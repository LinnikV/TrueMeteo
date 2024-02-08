require 'nokogiri'

class Parser
  def initialize(content)
    @html = Nokogiri::HTML(content)
  end

  def get_link_and_header
    row = @html.css('.card')
    unless row.empty? || row.nil?
      link_arr = []
      row.each do |value|
        hash = {
          date: value.css('.card-date').text,
          title: value.css('.card-title').text,
          header: value.css('.card-text').text.strip,
          link: value.css('a').attr("href").value,
          img: value.css('.card-img-top').attr("src").value
        }
        link_arr << hash
      end
      link_arr
    end
  end

  def parse_article
    @html.css('div.post-content').css('div.container')
  end
end


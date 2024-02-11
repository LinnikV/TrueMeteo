class Scraper < ConnectionService
  
  def connect_to_main_page
    connect(url: "https://coveringclimatenow.org/from-us/climate-beat/?pg=2")
  end

  def connect_to_article(link)
    connect(url: link)
  end
end
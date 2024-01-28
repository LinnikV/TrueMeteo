class GeocodeService < ConnectionService
  def initialize(name)
    @name = name
  end

  def call
    unless @name.nil? || @name.empty?
      ConnectionService.new.connect(url: "https://geocoding-api.open-meteo.com/v1/search?name=#{@name}&count=50&language=en&format=json")
    end
  end
end

class HomePageController < ApplicationController
  def index
  end

  def search
    data_geo = GeocodeService.new(params[:name]).call
    @geo = ForecastConverterService.new(data_geo).convert_geolocation
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("search", partial: "home_page/search")
        ]
      end
    end
  end

  def weather
    merge_params
    params.merge!({ "day"=> "7" }) if params["day"].to_i == 5
    unless params[:latitude].nil? || params[:longitude].nil?
      forecast = ForecastService.new(params).call
      data_forecast = ForecastConverterService.new(forecast)
      @convert_daily = data_forecast.convert_daily_forecast
      @current = data_forecast.convert_current_forecast
    end
    pp params["step"]
  end

  def air_quality
    merge_params
    params.merge!({ "day"=> "5" }) if params["day"].to_i > 5
    session.merge!({"day"=>"5"}) if params["day"].to_i > 5 || session.to_hash["day"].to_i > 5
    unless params[:latitude].nil? || params[:longitude].nil?
      air_quality = AirQualityService.new(params).call
      data_air_quality = AirConverterService.new(air_quality)
      #@convert_houlry_air = data_air_quality.convert_hourly_quality
      @current_air = data_air_quality.convert_current_air
      @daily_air = data_air_quality.convert_daily_quality
    end
  end

  private
  def merge_params
    #params.permit(:country, :latitude, :longitude, :name, :timezone, :day, :controller, :action )
    params[:latitude].gsub!(",",".") unless params[:latitude].nil?
    params[:longitude].gsub!(",",".") unless params[:longitude].nil?
    session.merge!({"country"=> params[:country],"latitude"=> params[:latitude],"longitude"=> params[:longitude], "name"=> params[:name], "timezone"=> params[:timezone], "day"=>params[:day]}) unless params[:name].nil?
    session.merge!({"country"=> nil, "name"=> nil, "latitude"=> params[:latitude],"longitude"=> params[:longitude], "timezone"=> params[:timezone], "day"=> params[:day]}) unless params[:latitude].nil? || params[:longitude].nil? || !params[:name].nil?
    params.merge!({country: session.to_hash["country"],latitude: session.to_hash["latitude"],longitude: session.to_hash["longitude"], name: session.to_hash["name"], timezone: session.to_hash["timezone"], day: session.to_hash["day"] })
  end
end

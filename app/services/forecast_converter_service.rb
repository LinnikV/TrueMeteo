class ForecastConverterService
  def initialize(data)
    @data = data
  end

  def convert_day(date)
    DateTime.parse(date.split("T").first).strftime("%e %b %A")
  end

  def convert_time(time)
    DateTime.parse(time.split("T").last).strftime("%H:%M")
  end

  def convert_daily_forecast
    unless @data["daily"].nil? || @data["daily"]["time"].nil? || @data["daily"]["time"].size < 1
      daily_arr = []
      @data["daily"]["time"].size.times do |i|
        daily_hash = {
          date: convert_day(@data["daily"]["time"][i]),
          weather_code: @data["daily"]["weather_code"][i],
          weather_text: wether_description[@data["daily"]["weather_code"][i]],
          temperature_2m_max: @data["daily"]["temperature_2m_max"][i],
          temperature_2m_min: @data["daily"]["temperature_2m_min"][i],
          apparent_temperature_max: @data["daily"]["apparent_temperature_max"][i],
          apparent_temperature_min: @data["daily"]["apparent_temperature_min"][i],
          sunrise: convert_time(@data["daily"]["sunrise"][i]),
          sunset: convert_time(@data["daily"]["sunset"][i]),
          daylight_duration: @data["daily"]["daylight_duration"][i],
          uv_index_max: @data["daily"]["uv_index_max"][i],
          precipitation_sum: @data["daily"]["precipitation_sum"][i],
          precipitation_probability_max: @data["daily"]["precipitation_probability_max"][i],
          wind_speed_10m_max: @data["daily"]["wind_speed_10m_max"][i],
          wind_gusts_10m_max: @data["daily"]["wind_gusts_10m_max"][i],
          wind_direction_10m_dominant: @data["daily"]["wind_direction_10m_dominant"][i],
          shortwave_radiation_sum: @data["daily"]["shortwave_radiation_sum"][i],
          et0_fao_evapotranspiration: @data["daily"]["et0_fao_evapotranspiration"][i],
          hourly_forecast: convert_hourly_forecast(convert_day(@data["daily"]["time"][i])),
        }
        daily_arr << daily_hash
      end
      daily_arr
    end
  end


  def convert_hourly_forecast(daily)
    unless @data["hourly"].nil? || @data["hourly"]["time"].nil? || @data["daily"]["time"].size < 1
      hourly_arr = []
      @data["hourly"]["time"].size.times do |i|
        time = convert_time(@data["hourly"]["time"][i])
        if daily == convert_day(@data["hourly"]["time"][i])
          if time == "01:00" ||  time == "04:00" || time == "08:00" || time == "12:00" || time == "16:00" || time == "20:00" || time == "23:00"
          hourly_hash = {
            time: convert_time(@data["hourly"]["time"][i]),
            temperature_2m: @data["hourly"]["temperature_2m"][i],
            relative_humidity_2m: @data["hourly"]["relative_humidity_2m"][i],
            dew_point_2m: @data["hourly"]["dew_point_2m"][i],
            apparent_temperature: @data["hourly"]["apparent_temperature"][i],
            precipitation_probability: @data["hourly"]["precipitation_probability"][i],
            precipitation: @data["hourly"]["precipitation"][i],
            rain: @data["hourly"]["rain"][i],
            showers: @data["hourly"]["showers"][i],
            snowfall: @data["hourly"]["snowfall"][i],
            snow_depth: @data["hourly"]["snow_depth"][i],
            weather_code: @data["hourly"]["weather_code"][i],
            weather_text: wether_description[@data["hourly"]["weather_code"][i]],
            pressure_msl: @data["hourly"]["pressure_msl"][i],
            surface_pressure: @data["hourly"]["surface_pressure"][i],
            cloud_cover: @data["hourly"]["cloud_cover"][i],
            visibility: @data["hourly"]["visibility"][i],
            evapotranspiration: @data["hourly"]["evapotranspiration"][i],
            et0_fao_evapotranspiration: @data["hourly"]["et0_fao_evapotranspiration"][i],
            vapour_pressure_deficit: @data["hourly"]["vapour_pressure_deficit"][i],
            wind_speed_10m: @data["hourly"]["wind_speed_10m"][i],
            wind_direction_10m: @data["hourly"]["wind_direction_10m"][i],
            wind_gusts_10m: @data["hourly"]["wind_gusts_10m"][i],
            soil_temperature_0cm: @data["hourly"]["soil_temperature_0cm"][i],
            soil_temperature_6cm: @data["hourly"]["soil_temperature_6cm"][i],
            soil_temperature_18cm: @data["hourly"]["soil_temperature_18cm"][i],
            soil_temperature_54cm: @data["hourly"]["soil_temperature_54cm"][i],
            soil_moisture_0_to_1cm: @data["hourly"]["soil_moisture_0_to_1cm"][i],
            soil_moisture_1_to_3cm: @data["hourly"]["soil_moisture_1_to_3cm"][i],
            soil_moisture_3_to_9cm: @data["hourly"]["soil_moisture_3_to_9cm"][i],
            soil_moisture_9_to_27cm: @data["hourly"]["soil_moisture_9_to_27cm"][i],
            soil_moisture_27_to_81cm: @data["hourly"]["soil_moisture_27_to_81cm"][i]
          }
          hourly_arr << hourly_hash
        end
        end
      end
      hourly_arr
    end
  end

  def convert_current_forecast
    {
      time: convert_time(@data["current"]["time"]),
      weather_code: @data["current"]["weather_code"],
      weather_text: wether_description[@data["current"]["weather_code"]],
      temperature_2m: @data["current"]["temperature_2m"],
      apparent_temperature: @data["current"]["apparent_temperature"],
      relative_humidity: @data["current"]["relative_humidity_2m"],
      is_day: @data["current"]["is_day"],
      precipitation: @data["current"]["precipitation"],
      rain: @data["current"]["rain"],
      showers: @data["current"]["showers"],
      snowfall: @data["current"]["snowfall"],
      cloud_cover:  @data["current"]["cloud_cover"],
      pressure_msl: @data["current"]["pressure_msl"],
      surface_pressure: @data["current"]["surface_pressure"],
      wind_speed: @data["current"]["wind_speed_10m"],
      wind_gusts: @data["current"]["wind_gusts_10m"],
      wind_direction: @data["current"]["wind_direction_10m"]
    }
  end



  def wether_description
    {
      0 => "Clear Sky",
      1 => "Mainly Clear",
      2 => "Partly Cloudy",
      3 => "Overcast",
      45 => "Fog",
      48 => "Rime Fog",
      51 => "Light Drizzle",
      53 => "Moderate Drizzle",
      55 => "Dense Intensity Drizzle",
      56 => "Light Freezing Drizzle",
      57 => "Dense Intensity Freezing Drizzle",
      61 => "Slight Rain",
      63 => "Moderate Rain",
      65 => "Heavy Rain",
      66 => "Light Freezing Rain",
      67 => "Heavy Freezing Rain",
      71 => "Slight Snow Fall",
      73 => "Moderate Snow Fall",
      75 => "Heavy Snow Fall",
      77 => "Snow Grains",
      80 => "Slight Rain Showers",
      81 => "Moderate Rain Showers",
      82 => "Heavy Rain Showers",
      85 => "Light Snow Showers",
      86 => "Heavy Snow Showers",
      95 => "Thunderstorm",
      96 => "Thunderstorm With Slight Hail",
      99 => "Thunderstorm With Heavy Hail"
    }
  end


  def convert_geolocation
    unless @data.nil? || @data["results"].nil? || @data["results"].size < 1
      geolocation_arr = []
      @data["results"].each do |result|
        unless result["name"].nil? || result["latitude"].nil? || result["longitude"].nil? || result["timezone"].nil?
          geo_hash = {
            value: result["name"],
            latitude: result["latitude"],
            longitude: result["longitude"],
            country: result["country"],
            timezone: result["timezone"]
          }
          geolocation_arr << geo_hash
        end
      end
      geolocation_arr
    end
  end
end


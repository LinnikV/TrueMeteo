class AirConverterService
  def initialize(data)
    @data = data
  end

  def convert_day(date)
    DateTime.parse(date.split("T").first).strftime("%e %b %A")
  end

  def convert_time(time)
    DateTime.parse(time.split("T").last).strftime("%H:%M")
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

  def convert_current_air
    unless @data.nil? || @data.empty? || @data["current"].nil?
      hash = {
        time: convert_time(@data["current"]["time"]),
        pm10: @data["current"]["pm10"],
        pm2_5: @data["current"]["pm2_5"],
        nitrogen_dioxide: @data["current"]["nitrogen_dioxide"],
        sulphur_dioxide: @data["current"]["sulphur_dioxide"],
        ozone: @data["current"]["ozone"],
        european_aqi: @data["current"]["european_aqi"],
        index_status: index_status(@data["current"]["european_aqi"]),
        color_index: color_index[index_status(@data["current"]["european_aqi"])],
        index_desc: index_desc[index_status(@data["current"]["european_aqi"])]
      }

      @data["hourly"]["time"].size.times do |i|
        if  @data["hourly"]["time"][i] == @data["current"]["time"]
          hash.merge!({
            aqi_pm10: @data["hourly"]["european_aqi_pm10"][i],
            aqi_pm2_5: @data["hourly"]["european_aqi_pm2_5"][i],
            aqi_nitrogen_dioxide: @data["hourly"]["european_aqi_nitrogen_dioxide"][i],
            aqi_ozone: @data["hourly"]["european_aqi_ozone"][i],
            aqi_sulphur_dioxide: @data["hourly"]["european_aqi_sulphur_dioxide"][i]
          })
        end
      end
      hash.merge!({
        index_pm10: index_pm10(hash[:aqi_pm10]),
        index_pm2_5: index_pm2_5(hash[:aqi_pm2_5]),
        index_aqi_nitrogen_dioxide: index_aqi_nitrogen_dioxide(hash[:aqi_nitrogen_dioxide]),
        index_aqi_ozone: index_aqi_ozone(hash[:aqi_ozone]),
        index_aqi_sulphur_dioxide: index_aqi_sulphur_dioxide(hash[:aqi_sulphur_dioxide])
      })

      hash.merge!({
        color_index_aqi_pm10: color_index[hash[:index_pm10]],
        color_index_aqi_pm2_5: color_index[hash[:index_pm2_5]],
        color_index_aqi_nitrogen_dioxide: color_index[hash[:index_aqi_nitrogen_dioxide]],
        color_index_aqi_ozone: color_index[hash[:index_aqi_ozone]],
        color_index_aqi_sulphur_dioxide: color_index[hash[:index_aqi_sulphur_dioxide]]
      })
      hash
    end
  end

  def convert_daily_quality
    unless @data.nil? || @data.empty? || @data["current"].nil?
      daily_arr = []
      hash = {}
      uniq_day = (@data["hourly"]["time"].map {|el| convert_day(el)}).uniq
      uniq_day.size.times do |i|
        hash = {
          day: uniq_day[i],
          pm2_5: ((@data["hourly"]["pm2_5"]).each_slice(24).to_a[i].sum/24).to_i,
          pm10: ((@data["hourly"]["pm10"]).each_slice(24).to_a[i].sum/24).to_i,
          nitrogen_dioxide: ((@data["hourly"]["nitrogen_dioxide"]).each_slice(24).to_a[i].sum/24).to_i,
          sulphur_dioxide: ((@data["hourly"]["sulphur_dioxide"]).each_slice(24).to_a[i].sum/24).to_i,
          ozone: ((@data["hourly"]["ozone"]).each_slice(24).to_a[i].sum/24).to_i,
          european_aqi: ((@data["hourly"]["european_aqi_pm10"]).each_slice(24).to_a[i].sum/24).to_i,
          aqi_pm10: ((@data["hourly"]["european_aqi"]).each_slice(24).to_a[i].sum/24).to_i,
          aqi_pm2_5: ((@data["hourly"]["european_aqi_pm2_5"]).each_slice(24).to_a[i].sum/24).to_i,
          aqi_nitrogen_dioxide: ((@data["hourly"]["european_aqi_nitrogen_dioxide"]).each_slice(24).to_a[i].sum/24).to_i,
          aqi_ozone: ((@data["hourly"]["european_aqi_ozone"]).each_slice(24).to_a[i].sum/24).to_i,
          aqi_sulphur_dioxide: ((@data["hourly"]["european_aqi_sulphur_dioxide"]).each_slice(24).to_a[i].sum/24).to_i
        }

        hash.merge!({
          index_aqi: index_status(hash[:european_aqi]),
          index_pm10: index_pm10(hash[:aqi_pm10]),
          index_pm2_5: index_pm2_5(hash[:aqi_pm2_5]),
          index_aqi_nitrogen_dioxide: index_aqi_nitrogen_dioxide(hash[:aqi_nitrogen_dioxide]),
          index_aqi_ozone: index_aqi_ozone(hash[:aqi_ozone]),
          index_aqi_sulphur_dioxide: index_aqi_sulphur_dioxide(hash[:aqi_sulphur_dioxide])
        })
        hash.merge!({
          colot_index_aqi: color_index[hash[:index_aqi]],
          color_index_aqi_pm10: color_index[hash[:index_pm10]],
          color_index_aqi_pm2_5: color_index[hash[:index_pm2_5]],
          color_index_aqi_nitrogen_dioxide: color_index[hash[:index_aqi_nitrogen_dioxide]],
          color_index_aqi_ozone: color_index[hash[:index_aqi_ozone]],
          color_index_aqi_sulphur_dioxide: color_index[hash[:index_aqi_sulphur_dioxide]]
        })
        daily_arr << hash
      end
      daily_arr
    end
  end

  def index_status(value)
    return "Good" if (0..20).include?(value)
    return "Fair" if (20...40).include?(value)
    return "Moderate" if (40...60).include?(value)
    return "Poor" if (60...80).include?(value)
    return "Very Poor" if (80...100).include?(value)
    return "Extremely Poor" if (100...500).include?(value)
  end

  def index_pm10(value)
    return "Good" if (0..20).include?(value)
    return "Fair" if (20...40).include?(value)
    return "Moderate" if (40...50).include?(value)
    return "Poor" if (50...100).include?(value)
    return "Very Poor" if (100...150).include?(value)
    return "Extremely Poor" if (150...1300).include?(value)
  end

  def index_pm2_5(value)
    return "Good" if (0..10).include?(value)
    return "Fair" if (10...20).include?(value)
    return "Moderate" if (20...25).include?(value)
    return "Poor" if (25...50).include?(value)
    return "Very Poor" if (50...75).include?(value)
    return "Extremely Poor" if (75...900).include?(value)
  end

  def index_aqi_nitrogen_dioxide(value)
    return "Good" if (0..40).include?(value)
    return "Fair" if (40...90).include?(value)
    return "Moderate" if (90...120).include?(value)
    return "Poor" if (120...230).include?(value)
    return "Very Poor" if (230...340).include?(value)
    return "Extremely Poor" if (340...1100).include?(value)
  end

  def index_aqi_ozone(value)
    return "Good" if (0..50).include?(value)
    return "Fair" if (50...100).include?(value)
    return "Moderate" if (100...130).include?(value)
    return "Poor" if (130...240).include?(value)
    return "Very Poor" if (240...380).include?(value)
    return "Extremely Poor" if (380...900).include?(value)
  end

  def index_aqi_sulphur_dioxide(value)
    return "Good" if (0..100).include?(value)
    return "Fair" if (100...200).include?(value)
    return "Moderate" if (200...350).include?(value)
    return "Poor" if (350...500).include?(value)
    return "Very Poor" if (500...750).include?(value)
    return "Extremely Poor" if (750...1300).include?(value)
  end
  
  def color_index
    {
      "Good" => "aqua",
      "Fair" => "green",
      "Moderate" => "yellow",
      "Poor" => "orange",
      "Very Poor" => "red",
      "Extremely Poor"=> "maroon"
    }
  end

  def index_desc
    {
      "Good" => "Air quality is ideal for most people. You can spend time outside without restrictions.",
      "Fair" => "Air quality is generally acceptable for most people. However, people with hypersensitivity may experience mild to moderate symptoms after being outdoors for a long time.",
      "Moderate" => "Air pollution has reached high levels and is unsafe for people with hypersensitivity. If you experience difficulty breathing or throat irritation, reduce the amount of time you spend outside.",
      "Poor" => "People with hypersensitivity may feel unwell instantly. Healthy people may experience difficulty breathing or throat irritation if they spend a long time outdoors. Limit your time outside.",
      "Very Poor" => "People with hypersensitivity may feel instantly unwell and should avoid being outdoors. Healthy people may experience symptoms of difficulty breathing or throat irritation.",
      "Extremely Poor" => "Any time outside, even for a few minutes, can lead to serious complications for anyone. Try not to go outside."
    }
  end

  def convert_hourly_quality
    @data["hourly"]
  end


end

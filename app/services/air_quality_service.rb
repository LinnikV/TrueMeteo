class AirQualityService < ConnectionService
	def initialize(params)
		@params = params
	end

	def call
		unless @params.nil? || @params.empty?
			ConnectionService.new.connect(url: "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=#{@params[:latitude]}&longitude=#{@params[:longitude]}&current=european_aqi,pm10,pm2_5,nitrogen_dioxide,sulphur_dioxide,ozone&hourly=pm10,pm2_5,nitrogen_dioxide,sulphur_dioxide,ozone,ammonia,european_aqi,european_aqi_pm2_5,european_aqi_pm10,european_aqi_nitrogen_dioxide,european_aqi_ozone,european_aqi_sulphur_dioxide&timezone=#{@params[:timezone]}&forecast_days=#{@params[:day] || 3}")
		end
	end
end

class ConnectionService
  require "json"
  require 'net/http'
  
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def connect(**arguments, &block)
    begin
      url = arguments[:url].dup
      retries = 0
      uri = URI::parse(url)
      response = Net::HTTP.get(uri)
    rescue Exception => e
      pp e.message
      response = {}

    else
      JSON.parse(response) rescue response
    end
  end
end

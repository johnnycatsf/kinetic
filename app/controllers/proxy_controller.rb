require "net/https"
require "uri"

class ProxyController < ApplicationController

def track_analysis
  url = params[:analysis_url]
  puts url
  uri = URI.parse(url)
  puts uri
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  puts http
  request = Net::HTTP::Get.new(uri.request_uri)
  puts request

  response = http.request(request)
  puts response
  render :json => response.body
end

def get_fma_track_url
  url = params[:track_url]
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  # http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)

  render :xml => response.body
end

end

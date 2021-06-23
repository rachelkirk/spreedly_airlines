require 'net/https'
require 'uri'

class TransactionsController < ApplicationController
  # basic authentication from ruby docs:  https://docs.ruby-lang.org/en/2.0.0/Net/HTTP.html
  def index
    key = ENV ["ENVIRONMENT_KEY"]
    secret = ENV ["ACCESS_SECRET"]
    uri = URI.parse("https://core.spreedly.com/v1/payment_methods.json")
    req = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
    req.basic_auth(key,secret)
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

  end

  def purchase
    
  end


end

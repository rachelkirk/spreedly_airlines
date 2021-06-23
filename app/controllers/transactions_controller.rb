require 'net/https'
require 'uri'
require 'json'

class TransactionsController < ApplicationController
  # basic authentication from ruby docs:  https://docs.ruby-lang.org/en/2.0.0/Net/HTTP.html
  def index
    key = ENV ["ENVIRONMENT_KEY"]
    secret = ENV ["ACCESS_SECRET"]
    uri = URI.parse("https://core.spreedly.com/v1/payment_methods.json")
    req = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
    req.basic_auth(key,secret)
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme = "https") do |http|
      http.request(req)
    end
    # need to include some way to parse JSON response body here, with success/error messages

  end

  def purchase
    # need to fix the logic here, include some sort of if/else to handle
    # whether or not it will be a spreedly or expedia payment
    # the iframe is allowing the payment form to be submitted, but purchase method
    # is not being initialized. payment_method_token is being generated, 
    # i checked that on the dashboard under id. purchase is not happening...
    @payment_token = params[:payment_method_token]
    @amount = @flight.price.to_i
    key = ENV ["ENVIRONMENT_KEY"]
    secret = ENV ["ACCESS_SECRET"]
    spreedly_token = ENV ["SPREEDLY"]
    expedia_token = ENV ["EXPEDIA"]
    

    @retain_payment = params[:retain_payment]
    @expedia_payment = params[:expedia_payment]

    uri = URI.parse("https://core.spreedly.com/v1/gateways/#{spreedly_token}/purchase.json")
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.basic_auth(key, secret)
    request.body =
    {
      transaction: {
        payment_method_token: @payment_token,
        amount: @amount,
        currency_code: "USD",
        retain_on_success: "#{retain_payment}"
      }
    }.to_json

    @response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme = "https") do |http|
      http.request(@request) 
    end
      if expedia_payment
        uri = URI.parse("https://core.spreedly.com/v1/receivers/#{expedia_token}/deliver.json")
        request = Net::HTTP::Post.new(receiver_uri, 'Content-Type' => 'application/json')
        request.basic_auth(key, secret)
        request.body =
          {
            delivery: {
              payment_method_token: @payment_token,
              url: "https://spreedly-echo.herokuapp.com",
              headers: "Content-Type: application/json",
              body: "{ \"product_id\": \"916598\"}"
            }
          }.to_json
        response = Net::HTTP.start(receiver_uri.hostname, receiver_uri.port, use_ssl: receiver_uri.scheme = "https") do |http|
          http.request(receiver_request)
      end
    end
  end
end

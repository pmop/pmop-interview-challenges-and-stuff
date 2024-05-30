# frozen_string_literal: true
require_relative 'config/application'
require 'sinatra'
require_relative 'config/environment'

AtmChallenge::Application.autoload

controller = ::Controllers::AtmController.new

put '/atm/supply' do
  request.body.rewind

  content_type :json
  JSON.pretty_generate(controller.supply(request.body.read))
end

post '/atm/withdraw' do
  request.body.rewind

  content_type :json
  JSON.pretty_generate(controller.withdraw(request.body.read))
end

get '/atm' do

  content_type :json
  JSON.pretty_generate(controller.state)
end

delete '/atm' do

  content_type :json
  JSON.pretty_generate(controller.reset)
end



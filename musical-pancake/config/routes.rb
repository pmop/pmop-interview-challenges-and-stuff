Rails.application.routes.draw do
  resources :form_data
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  get '/streets/search/', to: 'streets#search', as: 'street'
  get '/streets/:name_upper_case/numbers/', to: 'streets#numbers', as: 'street_numbers'

  get '/cities/:city/streets/', to: 'cities#streets', as: 'city_street'
  get '/buildings/search/', to: 'buildings#search', as: 'building'
  get '/postal-codes/:postal_code/cities/', to: 'postal_codes#search_cities', as: 'postal_code_city'
end

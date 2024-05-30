$APP_ENV = ENV['APP_ENV'] || 'development'

if $APP_ENV == 'production'
  set :environment, :production
end

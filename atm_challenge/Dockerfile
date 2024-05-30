FROM ruby:3.1

RUN bundle config --global frozen 1

WORKDIR /atm_challenge

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY . ./

EXPOSE 4567

ENV APP_ENV="production"

ENTRYPOINT ["./entrypoint.sh"]

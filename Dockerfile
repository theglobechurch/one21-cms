FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /one21-cms
WORKDIR /one21-cms
COPY Gemfile /one21-cms/Gemfile
COPY Gemfile.lock /one21-cms/Gemfile.lock
RUN bundle install
COPY . /one21-cms

FROM ruby:2.5.7-stretch
RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
RUN apt-get update -qq
RUN apt-get install -y build-essential
RUN apt-get install -y libpq-dev
RUN mkdir /one21-cms
WORKDIR /one21-cms
COPY Gemfile /one21-cms/Gemfile
#COPY Gemfile.lock /one21-cms/Gemfile.lock
RUN bundle install
COPY . /one21-cms

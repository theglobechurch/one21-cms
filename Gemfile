source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.5'

gem 'rails', '~> 7.0.0'
gem 'pg', '~> 1.5'
gem 'puma', '~> 7.1.0'
gem 'httparty', '~> 0.23.2'
gem 'net-smtp', require: false
gem 'jbuilder', '~> 2.5'
gem 'dragonfly', '~> 1.1.5'
gem 'devise'
gem 'devise_invitable'
gem 'stringex', '~> 2.8', '>= 2.8.4'
gem 'active_model_serializers', '~> 0.10.14'
gem 'draper', '~> 4.0'
gem 'redcarpet', '~> 3.6'
gem 'figaro'
gem 'mailgun_rails'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '~> 6.5.1'
  gem 'rails-controller-testing'
  gem 'rubocop', '~> 1.81.7'
  gem 'timecop'
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'simplecov', require: false
  gem 'minitest-reporters'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.8'
  gem 'letter_opener'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 5.0'
  gem 'webmock'
end

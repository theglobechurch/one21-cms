source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'sass-rails', '~> 5.0'    # Sass for rails. Obvs
gem 'pg', '>= 0.18', '< 2.0'  # postgresql
gem 'puma', '~> 3.11'         # Web server
gem 'jbuilder', '~> 2.5'      # JSON APIs(https://github.com/rails/jbuilder)
gem 'dragonfly', '~> 1.1.5'   # File uploads
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'stringex', '~> 2.8', '>= 2.8.4'
gem 'active_model_serializers', '~> 0.10.0'
gem 'draper', '~> 3.0.1'
gem 'redcarpet', '~> 3.4.0'
gem 'multi_json'
gem 'faraday'
gem 'faraday_middleware'
gem 'faraday_middleware-multi_json'
gem "figaro"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'         # For testing
  gem 'rails-controller-testing'  # Does what it says
  gem 'rubocop'                   # Enforce styles
  gem 'timecop'                   # Test time cases
  gem 'brakeman'                  # security warnings
  gem 'bundler-audit'             # Beware of outdated gems
  gem 'simplecov', require: false # Check test coverage
  gem 'minitest-reporters'        # Improve the look of unit tests  
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

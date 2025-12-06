source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.5'

gem 'rails', '~> 7.0.0'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'httparty'
gem 'net-smtp', require: false
gem 'jbuilder', '~> 2.5'      # JSON APIs(https://github.com/rails/jbuilder)
gem 'dragonfly', '~> 1.1.5'   # File uploads
gem 'devise'
gem 'devise_invitable'
gem 'stringex', '~> 2.8', '>= 2.8.4'
gem 'active_model_serializers', '~> 0.10.14'
gem 'draper', '~> 4.0'
gem 'redcarpet', '~> 3.6'
gem 'figaro'                  # For config values
gem 'mailgun_rails'           # Send emails

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
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.8'
  gem 'letter_opener'             # Save email to /tmp rather than sending
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 5.0'
  gem 'webmock'
end

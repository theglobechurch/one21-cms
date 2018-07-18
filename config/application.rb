require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module One21Cms
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Autoload lib folder
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join("lib")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Disable error wrapping in forms
    # https://rubyplus.com/articles/3401-Customize-Field-Error-in-Rails-5
    config.action_view.field_error_proc = proc { |html_tag, _instance|
      html_tag
    }
  end
end

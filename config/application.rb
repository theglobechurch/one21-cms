require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module One21Cms
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("lib")

    # Support for inversing belongs_to -> has_many Active Record associations.
    config.active_record.has_many_inversing = true

    # Track Active Storage variants in the database.
    config.active_storage.track_variants = true

    # Apply random variation to the delay when retrying failed jobs.
    config.active_job.retry_jitter = 0.15

    # Stop executing `after_enqueue`/`after_perform` callbacks if
    # `before_enqueue`/`before_perform` respectively halts with `throw :abort`.
    config.active_job.skip_after_callbacks_if_terminated = true

    # Specify cookies SameSite protection level: either :none, :lax, or :strict.
    #
    # This change is not backwards compatible with earlier Rails versions.
    # It's best enabled when your entire app is migrated and stable on 6.1.
    config.action_dispatch.cookies_same_site_protection = :strict

    # Generate CSRF tokens that are encoded in URL-safe Base64.
    #
    # This change is not backwards compatible with earlier Rails versions.
    # It's best enabled when your entire app is migrated and stable on 6.1.
    config.action_controller.urlsafe_csrf_tokens = true

    # Specify whether `ActiveSupport::TimeZone.utc_to_local` returns a time with an
    # UTC offset or a UTC time.
    config.active_support.utc_to_local_returns_utc_offset_times = true

    # Change the default HTTP status code to `308` when redirecting non-GET/HEAD
    # requests to HTTPS in `ActionDispatch::SSL` middleware.
    config.action_dispatch.ssl_default_redirect_status = 308

    # Use new connection handling API. For most applications this won't have any
    # effect. For applications using multiple databases, this new API provides
    # support for granular connection swapping.
    config.active_record.legacy_connection_handling = false

    # Make `form_with` generate non-remote forms by default.
    config.action_view.form_with_generates_remote_forms = false

    # Set the default queue name for the analysis job to the queue adapter default.
    config.active_storage.queues.analysis = nil

    # Set the default queue name for the purge job to the queue adapter default.
    config.active_storage.queues.purge = nil

    # Set the default queue name for the incineration job to the queue adapter default.
    config.action_mailbox.queues.incineration = nil

    # Set the default queue name for the routing job to the queue adapter default.
    config.action_mailbox.queues.routing = nil

    # Set the default queue name for the mail deliver job to the queue adapter default.
    config.action_mailer.deliver_later_queue_name = nil

    # Generate a `Link` header that gives a hint to modern browsers about
    # preloading assets when using `javascript_include_tag` and `stylesheet_link_tag`.
    config.action_view.preload_links_header = true


  end
end

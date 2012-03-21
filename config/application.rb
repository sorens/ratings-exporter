require File.expand_path('../boot', __FILE__)

require 'rails/all'
#require "active_record/railtie"
#require "action_controller/railtie"
#require "action_mailer/railtie"
#require "active_resource/railtie"
#require "sprockets/railtie"
#require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module RatingsExporter
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/lib #{config.root}/lib/custom_jobs #{config.root}/lib/netflix)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.action_dispatch.session = 
    {
      :key    => '_app_session',
      :secret => ENV['SESSION_SECRET']
    }
    
    config.action_mailer.default_url_options = { :host => ENV['MAILER_HOST'] }
    
    #**********************************************************************#
    #                                                                      #
    #               A P P  S P E C I F I C  C O N F I G                    #
    #                                                                      #
    #**********************************************************************#
    
    # netflix callback location
    config.oauth_callback_domain            = ENV['OAUTH_CALLBACK_DOMAIN']
    # netflix application key
    config.netflix_app_key                  = ENV['NETFLIX_KEY']
    # netflix application secret
    config.netflix_app_secret               = ENV['NETFLIX_SECRET']
    # google analytics
    config.google_analytics_prop_id         = ENV['GOOGLE_ANALYTICS_PROP_ID']
    # facebook app id
    config.facebook_app_id                  = ENV['FB_APP_ID']
    # uservoice
    config.uservoice_id                     = ENV['USERVOICE_ID']
    # google ad_client
    config.google_ad_client                 = ENV['GOOGLE_AD_CLIENT']
    # google ad_slot
    config.google_ad_slot                   = ENV['GOOGLE_AD_SLOT']
  end
end

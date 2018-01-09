# Main entry point - DO NOT MODIFY THIS FILE
ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default, ENV['RACK_ENV'])

# Default application layout.
# NOTE: This layout need NOT be specified explicitly.
# It is provided just for illustration.
Praxis::Application.instance.layout do
  map :initializers, 'config/initializers/**/*'
  map :lib, 'lib/**/*'
  map :design, 'design/' do
    map :api, 'api.rb'
    map :media_types, '**/media_types/**/*'
    map :resources, '**/resources/**/*'
  end
  map :app, 'app/' do
    map :models, 'models/**/*'
    map :controllers, '**/controllers/**/*'
    map :responses, '**/responses/**/*'
  end
end


Praxis::Application.instance.config do
  attribute :temp_file_directory, String, required: true
  attribute :mailgun_domain, String, required: true
  attribute :mailgun_api_key, String, required: true
end

Praxis::Application.instance.config.temp_file_directory = '/tmp'
Praxis::Application.instance.config.mailgun_domain = ENV['MAILGUN_DOMAIN']
Praxis::Application.instance.config.mailgun_api_key = ENV['MAILGUN_API_KEY']

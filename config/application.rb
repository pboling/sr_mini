# frozen_string_literal: true

require_relative "boot"

require "rails"

require "stimulus_reflex"
require "action_cable/engine"
require "action_controller/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*(Rails.groups))

module ApplicationCable; end

class ApplicationCable::Connection < ActionCable::Connection::Base; end

class ApplicationCable::Channel < ActionCable::Channel::Base; end

class ApplicationController < ActionController::Base; end

class ApplicationReflex < StimulusReflex::Reflex; end

class CounterReflex < ApplicationReflex
  def increment
    @count = element.dataset.count.to_i + 1
  end

  def reset
    @count = 0
  end
end

class DemosController < ApplicationController
  def show
    @count ||= 0
    render inline: <<~HTML
      <html>
        <head>
          <title>StimulusReflex Mini Demo</title>
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet">
          <%= javascript_include_tag "/index.js", type: "module" %>
        </head>
        <body>
          <div class="container my-5">
            <h1>StimulusReflex <small class="text-muted fw-lighter fs-5">Mini Demo <%= "🤯 It's working!!!" if @count > 0 %></small></h1>
            <%= tag.span "counter: #{@count}", class: class_names("lead badge rounded-pill", "bg-secondary": @count.zero?, "bg-danger": !@count.zero?) %>
            <div class="button-group my-3">
              <%= tag.a "Increment Counter", class: "btn btn-primary", data: { reflex: "click->counter#increment", count: @count } %>
              <%= tag.a "Reset", class: "btn btn-link", data: { reflex: "click->counter#reset" } %>
            </div>
            <%= tag.span "You've incremented the counter #{@count} times.", class: "lead" if @count > 0 %>
          </div>
        </body>
      </html>
    HTML
  end
end

class MiniApp < Rails::Application
  require "stimulus_reflex/../../app/channels/stimulus_reflex/channel"

  config.action_controller.perform_caching = true
  config.consider_all_requests_local = true
  config.public_file_server.enabled = true
  config.secret_key_base = "cde22ece34fdd96d8c72ab3e5c17ac86"
  config.secret_token = "bf56dfbbe596131bfca591d1d9ed2021"
  config.session_store :cache_store

  Rails.cache = ActiveSupport::Cache::RedisCacheStore.new(url: "redis://localhost:6379/1")
  Rails.logger = ActionCable.server.config.logger = Logger.new($stdout)
  ActionCable.server.config.cable = {"adapter" => "redis", "url" => "redis://localhost:6379/1"}

  routes.draw do
    mount ActionCable.server => "/cable"
    resource :demo, only: :show
    root "demos#show"
  end
end

# Initialize the Rails application.
Rails.application.initialize!

require "importmap-rails"

module ObjectView
  class << self
    attr_accessor :importmap
  end
  class Engine < ::Rails::Engine
    isolate_namespace ObjectView
    paths["app/assets"]
    # paths["app/javascript"]
    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end

    initializer "object_view.importmap", before: "importmap" do |app|
      root = File.expand_path("../..", __dir__)
      css = File.expand_path("app/assets/stylesheets", root)
      app.config.assets.paths << css
      js = File.expand_path("app/javascript", root)
      app.config.assets.paths << js
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
    end
  end
end

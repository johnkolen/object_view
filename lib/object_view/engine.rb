require 'importmap-rails'

module ObjectView
  class Engine < ::Rails::Engine
    puts "ObjectView Engine"
    isolate_namespace ObjectView
    paths["app/assets"]
    #paths["app/javascript"]
    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end
    initializer "object_view.importmap", before: "importmap" do |app|
      puts "CONFIG IMPORTMAP"
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
      puts app.config.importmap.paths.inspect
    end
  end
end

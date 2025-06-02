require 'importmap-rails'

module ObjectView
  class << self
    attr_accessor :importmap
  end
  class Engine < ::Rails::Engine
    isolate_namespace ObjectView
    paths["app/assets"]
    #paths["app/javascript"]
    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end
    initializer "morphing.importmap", before: "importmap" do |app|
      app.config.assets.paths <<
        Rails.root.join("../object_view/app/assets/stylesheets")
      app.config.assets.paths <<
        Rails.root.join("../object_view/app/javascript")
      if false
      ObjectView.importmap = Importmap::Map.new
      #ObjectView.importmap.draw(app.root.join("config/importmap.rb"))
      puts root.join("config/importmap.rb")
      ObjectView.importmap.draw(root.join("config/importmap.rb"))
      puts ObjectView.importmap.to_json(resolver: ActionController::Base.helpers)
      ObjectView.importmap.directories.each do |d|
        puts d.inspect
      end
      end
    end
    initializer "object_view.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
    end
  end
end

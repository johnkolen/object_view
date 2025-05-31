require_relative "lib/object_view/version"

Gem::Specification.new do |spec|
  spec.name        = "object_view"
  spec.version     = ObjectView::VERSION
  spec.authors     = [ "John Kolen" ]
  spec.email       = [ "johnfkolen@gmail.com" ]
  spec.homepage    = "https://data4he.com"
  spec.summary     = "ObjectView is a Rails gem for simplifying creation of models, forms, and displays."
  spec.description = "#{spec.summary}..."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://github.com/foo"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end
  spec.test_files = Dir["spec/**/*_spec.rb"].select { |x| !(/^spec\/dummy/ =~ x) }

  spec.required_ruby_version = '>= 3.3.0'
  spec.add_dependency "rails", "~> 8.0"
end

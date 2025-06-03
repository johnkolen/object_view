class ObjectView::ScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)
  def all
    %w[helpers].each do |x|
      generate "object_view:#{x}"
    end
    %w[model controller erb].each do |x|
      generate "object_view:#{x}", name
    end
  end
end

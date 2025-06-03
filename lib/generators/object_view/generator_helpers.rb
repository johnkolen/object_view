module ObjectView::GeneratorHelpers
  def grep? file, content
    if File.exist? file
      File.open(file, "r") do |f|
        f.each_line do |line|
          return true if line.index content
        end
      end
    end
    false
  end

  def attributes_map(class_name, **options, &block)
    klass = class_name.constantize
    res = []
    klass.attribute_types.each do |attr, type|
      next if attr == "id"
      next if attr == "created_at"
      next if attr == "updated_at"
      res << yield(attr, type)
    end
    res
  end

  def attributes_each(class_name, **options, &block)
    klass = class_name.constantize
    klass.attribute_types.each do |attr, type|
      next if attr == "id"
      next if attr == "created_at"
      next if attr == "updated_at"
      yield(attr, type)
    end
  end
end

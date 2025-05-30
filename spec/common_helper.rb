module CommonHelper
  def fake_form &block
    helper.form_with model: object do |form|
      helper.ov_form = form
      helper.ov_obj = object
      r = helper.ov_allow? object, :edit do
        yield
      end
      expect(r).to be(true), "can't access object"
    end
  end

  def fake_display &block
    helper.ov_form = nil
    r = helper.ov_allow? object, :view do
      helper.ov_obj = object
      yield
    end
    expect(r).to be(true), "can't access object"
  end

  def assert_input elem, obj, attr, **options, &block
    assert_x :input, elem, obj, attr, div_class: "ov-text", **options, &block
  end

  def assert_textarea elem, obj, attr, **options, &block
    assert_x :textarea, elem, obj, attr, div_class: "ov-textarea", **options, &block
  end
  alias assert_text_area assert_textarea

  def assert_checkbox elem, obj, attr, **options, &block
    assert_x :input, elem, obj, attr, div_class: "ov-class", **options, &block
  end

  def assert_date elem, obj, attr, **options, &block
    assert_x :input, elem, obj, attr, div_class: "ov-date", **options, &block
  end

  def assert_datetime elem, obj, attr, **options, &block
    assert_x :input, elem, obj, attr, div_class: "ov-datetime", **options, &block
  end

  def assert_x x, elem, obj, attr, **options, &block
    expect(elem).not_to be_nil, "elem not generated"
    klass = obj.class_name_u
    node = elem.is_a?(String) ? Nokogiri::HTML(elem) : elem
    assert_dom node, "label[for=?]", attr
    unless options[:no_name]
      assert_dom node, "#{x}[name=?]", "#{klass}[#{attr}]"
    end
    assert_dom node,
               "div[class*=?]",
               options[:div_class] || "ov-text",
               0
    if block_given?
      yield node, klass
    end
  end

  def assert_display elem, obj, attr, **options, &block
    expect(elem).not_to be_nil, "elem not generated"
    klass = obj.class_name_u
    node = Nokogiri::HTML(elem)
    assert_dom node, "label[for=?]", attr
    assert_dom node, "input[name=?]", "#{klass}[#{attr}]", 0
    assert_dom node, "textarea[name=?]", "#{klass}[#{attr}]", 0
    assert_dom node,
               "div[class*=?]",
               options[:div_class] || "ov-text",
               1
    if block_given?
      yield node, klass
    end
  end
end

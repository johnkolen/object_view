module CommonHelper
  def fake_form **options, &block
    helper.form_with model: object do |form|
      helper.ov_form = form
      helper.ov_obj = object
      elems = nil
      r = helper.ov_allow? object, :edit do
        elems = yield
      end
      expect(r).to be(true), "can't access object"
      if options[:elements] == :only
        elems
      else
        r
      end
    end
  end

  def fake_display **options, &block
    helper.ov_form = nil
    elems = nil
    r = helper.ov_allow? object, :view do
      helper.ov_obj = object
      elems = yield
    end
    expect(r).to be(true), "can't access object"
    if options[:elements] == :only
      elems
    else
      r
    end
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

  def assert_form *args, **options, &block
    _assert_comp yield, :form, *args, **options
  end

  def assert_button(label, path = nil, method = nil, &block)
    elem = yield
    expect(elem).to match /#{label}/

    node = Nokogiri.HTML(elem)
    assert_dom node, "button[path=?]", path, 0 if path
    assert_dom node, "button[method=?]", method, 0 if method
  end

  DELTA = { form: 0, display: 1 }
  def _assert_comp elem, kind, obj, *rest, **options
    pp(elem) if options[:pp]
    head = obj.class.to_s.underscore
    attr = rest.last
    d = DELTA[kind]
    tail = rest.map { |x| "[#{x}]" }.join
    x = rest.pop
    mid = rest.map { |x| "[#{x}]" }.join
    rest.push x
    path = "#{head}#{tail}"
    node = Nokogiri.HTML(elem)
    @attributes ||= [ rest.last ]
    no_input = options[:no_input] || []
    no_label = options[:no_label] || []
    no_display = options[:no_display] || []
    display = options[:display] || []
    if kind == :form
      assert_dom node, "div[class*=?]", "ov-display", 0
      assert_dom node, "form[class*=?]", "ov-form", 1 do
        @attributes.each do |attr|
          assert_dom node, "label[for=?]", attr,
                     no_label.member?(attr) ? 0 : 1
          assert_dom node, "input[name=?]", "#{head}#{mid}[#{attr}]",
                     no_input.member?(attr) ? 0 : 1
        end
        assert_dom node, "div[class*=?]", "display-#{attr}",
                   display.member?(attr) ? 1 : 0
      end
    else
      assert_dom node, "form[class*=?]", "ov-form", 0
      assert_dom node, "div[class*=?]", "ov-display", { minimum: 1 } do
        @attributes.each do |attr|
          assert_dom node, "label[for=?]", attr,
                     no_label.member?(attr) ? 0 : 1
          assert_dom node, "input[name=?]", "#{head}#{mid}[#{attr}]", 0
          assert_dom node, "div[class*=?]", "display-#{attr}",
                     no_display.member?(attr) ? 0 : 1
        end
      end
    end
  ensure
    @attributes = nil
  end
end

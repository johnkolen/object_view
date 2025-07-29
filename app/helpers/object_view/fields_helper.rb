module ObjectView
  module FieldsHelper
    def ov_fields_for(oattr, **options, &block)
      if @ov_obj.is_a? ObjectView::TablesHelper::HeaderFor
        return ov_col(oattr, **options)
      else
        obj = @ov_obj.send(oattr)
        if options[:if] == :exists
          return nil unless obj
        end
      end
      # return nil unless obj
      # raise "missing attribute: #{oattr} in #{@ov_obj.class}" unless obj
      _ov_hold_state do
        if @ov_form
          _ov_fields_for_form oattr, **options, &block
        else
          _ov_fields_for_display oattr, **options, &block
        end
      end
    end

    ###################################

    # Generate the content for all the fields of oattr
    def _ov_fields_for_delegated_form(oattr, **options, &block)
      t = @ov_obj.send("#{oattr}_type")
      obj = @ov_obj.send(oattr)
      if options[:using] && options[:using] != t
        k = options[:using]
        k = k.constantize if k.is_a? String
        obj = k.new
        #@ov_obj.send("#{oattr}=", obj) if k
        t = k.to_s
      end
      #oattr = t.underscore.to_sym
      #_ov_fields_for_form_one oattr, **options, &block
      # raise "no obj: one(#{oattr}) #{@ov_obj}" unless obj
      return "" unless obj
      body = _ov_fields_for_form_element(oattr,
                                         obj,
                                         ov_obj_class_name_k,
                                         0,
                                         **options,
                                         delegated: t.underscore.to_s,
                                         &block)
      tag.div(id:"#{oattr}-#{t.underscore.dasherize}",
              name: t,
              data: options[:delegated_data]) do
        #@ov_form.hidden_field("#{oattr}_type", value: t) + body
        body
      end
    end

    ###################################
    # Generate the content for all the fields of oattr
    def _ov_fields_for_form(oattr, **options, &block)
      hold = @ov_obj
      if ov_one_to_one?(oattr)
        if ov_delegated?(oattr)
          _ov_fields_for_delegated_form oattr, **options, &block
        else
          _ov_fields_for_form_one oattr, **options, &block
        end
      else
        _ov_fields_for_form_many oattr, **options, &block
      end.html_safe
    ensure
      raise "ov_obj mismatch" unless @ov_obj == hold
    end

    def _ov_fields_for_display(oattr, **options, &block)
      one2one = ov_one_to_one? oattr
      if block_given?
        # process the fields from the block
        if one2one
          # treat the attributes at the same level as parent
          if ov_delegated?(oattr)
            oattr = @ov_obj.send("#{oattr}_type").underscore.to_sym
          end
          obj = @ov_obj.send(oattr)
          rv = nil
          @ov_obj = obj
          ov_allow? @ov_obj, @ov_access, **(options[:allow] || {}) do
            rv = capture(&block)
          end
          return rv || _ov_blocked(@ov_obj, oattr)
        elsif ov_belongs_to? oattr
          # treat the attributes at the same level as parent
          obj = @ov_obj.send(oattr)
          rv = nil
          @ov_obj = obj
          ov_allow? @ov_obj, @ov_access, **(options[:allow] || {}) do
            rv = capture(&block)
          end
          return rv || _ov_blocked(@ov_obj, oattr)
        else
          raise "TODO #{@ov_obj} #{oattr}"
        end
      end

      #raise "#{oattr} #{ov_obj.send(oattr).inspect}"
      # include all the allowable fields in attribute value
      elems = _get_all_objects oattr

      if ov_delegated? oattr
        #raise "delegated"
        return elems
      end
      if ov_superclass? oattr
        #raise "super"
        return elems
      end
      str = tag.div class: "ov-field" do
        [ tag.label(@ov_obj.send("#{oattr}_label"),
                    for: oattr,
                    class: @ov_form ? "form-label" : "ov-label"),
          tag.ul(elems, class: "ov-fields-for")
        ].join.html_safe
      end
      str.html_safe
    end

    ###################################

    def _get_all_objects(oattr, **options)
      elems = []
      if ov_one_to_one? oattr
        dclass = nil
        if ov_delegated?(oattr)
          dclass = @ov_obj.send("#{oattr}_type").underscore.to_sym
        end
        ov_with oattr do
          elems = [
            ov_render(partial: _partial(oattr, delegated: dclass),
                      locals: _locals(oattr))
          ]
        end
      else
        ov_with oattr do
          elems = @ov_obj.map do |obj|
            @ov_obj = obj
            raise "???"
            ov_render "#{oattr}/#{oattr}"  # Why isn't first pluralized?
          end.map do |x|
            tag.li x, class: "ov-object"
          end
        end
      end
      elems.join.html_safe
    end

    def _ov_blocked(obj, attr = nil)
      if attr
        "<!-- #{@ov_obj.class}.#{attr} blocked for #{@ov_access}-->"
      else
        "<!-- #{@ov_obj.class} blocked for #{@ov_access}-->"
      end
    end

    def ov_delegated?(oattr)
      r = @ov_obj.class.reflect_on_association(oattr)
      /able$/ =~ oattr.to_s &&
        r.inverse_of.nil? &&
        r.active_record.has_attribute?("#{oattr}_type") &&
        r.active_record.has_attribute?("#{oattr}_id")
    end

    def ov_superclass?(oattr)
      r = @ov_obj.class.reflect_on_association(oattr)
      return r.inverse_of && r.inverse_of.macro == :belongs_to
      puts r.inspect.gsub(", ", ",\n  ")
      puts r.inverse_of.macro.inspect
      return /able$/ =~ (r.inverse_of || "") &&
             r.active_record.has_attribute?("#{oattr}_type") &&
             r.active_record.has_attribute?("#{oattr}_id")
    end

    def ov_one_to_one?(oattr)
      r = @ov_obj.class.reflect_on_association(oattr)
      return true if ov_delegated? oattr
      return true if ov_superclass? oattr
      raise "one_to_one failed #{oattr.inspect} missing inverse_of" unless r.inverse_of
      r.macro == :belongs_to && r.inverse_of.macro == :has_one
    end

    def ov_belongs_to?(oattr)
      r = @ov_obj.class.reflect_on_association(oattr)
      r.macro == :belongs_to
    end

    # Generate the content for all the fields of a single oattr
    # from a one-to-one association
    def _ov_fields_for_form_one(oattr, **options, &block)
      # puts "_ov_fields_for_form_one"
      obj = @ov_obj.send(oattr)
      # raise "no obj: one(#{oattr}) #{@ov_obj}" unless obj
      return "" unless obj
      _ov_fields_for_form_element(oattr,
                                  obj,
                                  ov_obj_class_name_k,
                                  0,
                                  **options,
                                  &block)
    end

    # Generate the content for all the fields of all the oattr
    # from a one-to-many association
    def _ov_fields_for_form_many(oattr, **options, &block)
      # puts "_ov_fields_for_form_many"
      label = @ov_obj.send("#{oattr}_label")
      out = [ '<ul class="ov-fields-for" data-ov-fields-for-target="list">',
              ov_add ]
      num = -1
      @ov_obj.send(oattr).each do |obj|
        out << _ov_fields_for_form_element(oattr,
                                           obj,
                                           ov_obj_class_name_k,
                                           num += 1,
                                           removable: true,
                                           template: obj.new_record?,
                                           **options,
                                           &block)
      end
      out << "</ul>"
      [ tag.label(label,
                  for: oattr,
                  class: @ov_form ? "form-label" : "ov-label"),
        out.join.html_safe
      ].join.html_safe
    end

    # name should be kebab as it's used for css classes
    def _ov_fields_for_form_element(oattr, obj, css_name, num, **options, &block)
      # puts "*" * 30
      # puts "fields_for_form_element node: #{ov_access_class.node.inspect}"
      # puts "_ov_fields_for_form_element"
      # raise "#{oattr.inspect} #{options.inspect}"

      delegated = ov_delegated? oattr

      _ov_hold_state do
        @ov_form.fields_for oattr, obj  do |form|
          @ov_form = form
          @ov_obj = form.object
          raise "no form object: element(#{oattr},#{obj.inspect})" unless @ov_obj
          elem = "<!-- access block #{oattr} element -->"
          fields = if block_given?
                     rv = ""
                     # options[:allow] = { why: true }
                     ov_allow? @ov_obj, @ov_access, **(options[:allow] || {}) do
                       rv = capture(&block)
                     end
                     rv
          else
            # no allow? since render will do it
            #ov_render(_template(oattr), oattr => @ov_obj)
            #hold = @ov_neseted_form
            #@ov_neseted_form = oattr
            rv = ov_render(_form(oattr,
                                 delegated: options[:delegated]),
                                 oattr => @ov_obj)
            #@ov_nested_form = hold
            rv
          end
          li_id = "#{css_name}-li-#{num}"
          # include object"s id  if it's been persisted
          pid = @ov_obj.persisted? ? @ov_form.hidden_field(:id) : ""
          li_body = pid + fields
          if options[:removable]
            r = ov_remove(li_id)
            li_body += r if r
          end
          #raise "delegated #{oattr}" if delegated
          if delegated
            elem = li_body.html_safe
          else
            elem = tag.li(li_body.html_safe,
                          id: li_id,
                          class: "ov-object collapse show").html_safe
          end
          if options[:template]
            tag.template(elem,
                         id: "ov-#{css_name}-template",
                         data: { "ov-fields-for-target": "template" })
          else
            elem
          end
          elem.html_safe
        end
      end
    end
  end
end

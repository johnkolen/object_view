module ObjectView
  module BaseHelper
    puts "loading BaseBelper"

    def ov_obj=(obj)
      @ov_obj = obj
    end

    def ov_obj
      @ov_obj
    end

    def ov_form=(form)
      @ov_form = form
    end

    # Using get_, otherwise it collides with the form maker
    def get_ov_form
      @ov_form
    end

    # def dep_object_view(obj)
    #  @ov_obj = obj
    # end

    def ov_access_class
      @ov_access_class || ObjectView::AccessAlways
    end

    def ov_access_class=(klass)
      @ov_access_class = klass
    end

    def ov_with_access_class(klass, &block)
      hold = @ov_access_class
      @ov_access_class = klass
      yield
    ensure
      @ov_access_class = hold
    end

    # lowercase and underscores
    def ov_obj_class_name_u
      @ov_obj.class.to_s.underscore
    end

    # lowercase and dashes (kebab style)
    def ov_obj_class_name_k
      @ov_obj.class.to_s.underscore.dasherize
    end

    alias ov_obj_class_name_css ov_obj_class_name_k

    # humanized lowercase
    def ov_obj_class_name_h
      @ov_obj.class.to_s.underscore.humanize(capitalize: false)
    end

    def _ov_hold_state(&block)
      hold = [ @ov_obj, @ov_form ]
      yield
    ensure
      @ov_obj, @ov_form = hold
    end

    def ov_obj_path(params = {})
      polymorphic_path(@ov_obj, params: params)
    end

    def ov_allow? resource, label, **options, &block
      hold = [ @ov_access, @ov_allow_override ]
      @ov_access ||= label
      if options[:why]
        puts "-" * 30
        puts "node  #{ov_access_class.node.inspect}"
        puts "allow? #{resource.inspect}\n  label #{@ov_access}\n  user #{ov_access_class.user.inspect}"
        puts "   -> #{ov_access_class.allow? resource, label}"
        puts ov_access_class.explain
        puts "=" * 30
      end
      unless block_given?
        return @ov_allow_override ||
               options[:allow] ||
               ov_access_class.allow?(resource, label)
      end
      @ov_allow_override = true if options[:allow]
      if @ov_allow_override
        yield
      else
        ov_access_class.allow? resource, @ov_access, &block
      end
    ensure
      @ov_access, @ov_allow_override = hold
    end

    def ov_render *args, **opts
      # puts "render #{args.inspect}, #{opts.inspect}"
      render *args, **opts
    end

    def ov_render_partial obj=nil, f=nil
      p = _partial_src(obj || @ov_obj, f)
      l = _locals(obj || @ov_obj)
      ov_render(partial: p, locals: l)
    end

    # TODO: change to _ov_*
    def _partial(oattr)
      "#{oattr.to_s.pluralize}/#{oattr}"
    end

    def _partial_src(obj, f = nil)
      if obj.is_a? TablesHelper::HeaderFor
        "#{obj.class_name_plural_u}/#{f || 'form'}"
      else
        "#{obj.class_name_plural_u}/#{f || 'form'}"
      end
    end

    def _template(oattr)
      "#{oattr.to_s.pluralize}/#{oattr}"
    end

    def _locals(oattr)
      if oattr.is_a? Symbol
        { oattr => @ov_obj }
      elsif oattr.is_a? TablesHelper::HeaderFor
        { oattr.class_name_u.to_sym => oattr }
      else
        { oattr.class_name_u.to_sym => oattr }
      end
    end
  end
end

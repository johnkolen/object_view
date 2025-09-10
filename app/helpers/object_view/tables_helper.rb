module ObjectView
  module TablesHelper
    # puts "loading #{self}"

    class HeaderFor
      attr_reader :obj
      def initialize(obj)
        @obj = obj
      end
      def class_name_plural_u
        @obj.class_name_plural_u
      end
      def class_name_u
        @obj.class_name_u
      end
      def method_missing(name, *args, &block)
        return @obj.send("#{name}") if /^(.*)_label$/ =~ name.to_s
        puts @obj.inspect
        puts name.inspect
        super
      end
    end

    def ov_table(klass, objs = [], **options, &block)
      unless klass.is_a? Class
        raise "ov_table received a non-class argument: #{klass.inspect}"
      end
      return unless objs
      unless objs.is_a? Enumerable
        raise "ov_table received a non-enumerable argument: #{objs.inspect}"
      end
      sym = klass.to_s.underscore.to_sym
      obj = klass.new
      obj.add_builds!

      @ov_search = []
      @ov_sort = []
      @ov_exclude = options[:exclude]
      content = [
        if block_given?
          ov_table_row(HeaderFor.new(obj), **options, &block)
        else
          ov_render_partial(HeaderFor.new(obj), "table_row")
        end
      ]

      objs.each do |obj|
        if block_given?
          content << ov_table_row(obj, **options, &block)
        else
          content << ov_render_partial(obj, "table_row")
        end
      end
      @ov_exclude = nil
      out = []
      if @q && klass.respond_to?(:ransackable_attributes)
        out << ov_ransack_form(klass)
      end
      @ov_search = nil
      out << tag.table(content.join.html_safe,
                       id: "#{klass.to_s.underscore}_table")
      out << pagy_bootstrap_nav(@pagy) if @pagy && @pagy.pages > 1
      tag.div(out.join.html_safe,
              class: "ov-display")
    end

    def ov_ransack_form klass
      return nil unless @q && @ov_search && !@ov_search.empty?
      sf = search_form_for(@q, class:"ov-search-form") do |f|
        s=@ov_search.map do |oattr, sfield|
          tag.div(f.label(@ov_obj.send("#{oattr}_label"),
                          class: "form-label ov-label") +
                  f.search_field(sfield, class:"form-control ov-text"),
                  class: "ov-search-field")
        end
        s << tag.div(ov_submit('Search'), class: 'ov-button-bag')
        s.join.html_safe
      end
    end

    def ov_table_row(obj = nil, &block)
      @ov_obj = obj || @ov_obj
      @ov_table_row = true
      content = capture &block
      @ov_table_row = false
      if @ov_obj.is_a? HeaderFor
        tag.tr content.html_safe,  class: "ov-table-row-head"
      else
        content += '<td class="ov-table-col">'.html_safe
        content += ov_show
        content += ov_edit
        content += ov_delete
        content += "</td>".html_safe
        tag.tr content.html_safe, id: dom_id(@ov_obj), class: "ov-table-row"
      end
    end

    def ov_col(oattr, **options)
      if @ov_obj.is_a? HeaderFor
        return "" if @ov_exclude && @ov_exclude.member?(oattr)
        if options[:search]
          nmkey = "#{oattr}_name"
          key = @ov_obj.obj.respond_to?(nmkey) ? nmkey : oattr
          @ov_search << [oattr, :"#{key}_#{options[:search]}"]
        end
        label = @ov_obj.send("#{oattr}_label")
        if @q && options[:sort]
          #raise oattr.inspect
          nmkey = "#{oattr}_name"
          #raise oattr.inspect if oattr == :name
          #raise @ov_obj.obj.respond_to?(nmkey).inspect if oattr == :name
          key = @ov_obj.obj.respond_to?(nmkey) ? nmkey : oattr
          tag.td(sort_link(@q, key, label), class: "ov-table-hdr")
        else
          tag.td(label, class: "ov-table-hdr")
        end
      else
        if options[:display]
          tag.td(send(options[:display], oattr, oattr, **options),
                 class: "ov-table-col")
        else
          tag.td(@ov_obj.send("#{oattr}_str"), class: "ov-table-col")
        end
      end
    end
  end
end

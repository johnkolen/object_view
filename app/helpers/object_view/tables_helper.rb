module ObjectView
  module TablesHelper
    puts "loading #{self}"

    class HeaderFor
      attr_reader :obj
      def initialize obj
        @obj = obj
      end
      def class_name_plural_u
        @obj.class_name_plural_u
      end
      def class_name_u
        @obj.class_name_u
      end
      def method_missing(name, *args, &block)
        return @obj.send(name) if /^(.*)_label$/ =~ name
        super
      end
    end

    def ov_table(klass, objs = [])
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

      content = [
        ov_render_partial(HeaderFor.new(obj), "table_row")
      ]
      objs.each do |obj|
        content << ov_render_partial(obj, "table_row")
      end
      tag.table content.join.html_safe,
                id: "#{klass.to_s.underscore}_table",
                class: "ov-display"
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

    def ov_col(oattr)
      if @ov_obj.is_a? HeaderFor
        tag.td(@ov_obj.send("#{oattr}_label"), class: "ov-table-hdr")
      else
        tag.td(@ov_obj.send("#{oattr}_str"), class: "ov-table-col")
      end
    end
  end
end

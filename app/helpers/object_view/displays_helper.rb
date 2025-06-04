module ObjectView
  module DisplaysHelper
    def ov_display(obj = nil, **options, &block)
      raise "ov_diplay object is nil" if obj.nil?
      _ov_hold_state do
        # puts "*" * 30
        # puts "display node: #{ov_access_class.node.inspect}"
        rv = "<!-- access block display #{obj.class} -->"
        # options[:allow] = {why: true}
        ov_allow? obj, :view, **(options[:allow] || {}) do
          # puts "  a?> display node: #{ov_access_class.node.inspect}"
          return capture &block if @ov_form
          @ov_obj = obj || @ov_obj
          old = @ov_obj
          content = capture &block
          raise "wtf" unless old == @ov_obj
          rv = tag.div content, id: dom_id(@ov_obj), class: "ov-display"
        end
        rv
      end
    end
  end
end

module ObjectView
  module FormsHelper
    # puts "loading #{self}"

    def ov_form(obj = nil, **options, &block)
      raise "ov_form object is nil" if obj.nil?
      _ov_hold_state do
        # puts "*" * 30
        # puts "form node: #{ov_access_class.node.inspect}"
        rv = "<!-- access block form #{obj.class} -->"
        # options[:allow] = {why: true}
        ov_allow? obj, :edit, **(options[:allow]||{}) do
          # puts "  a?> form node: #{ov_access_class.node.inspect}"
          @ov_obj = obj || @ov_obj
          p = {}
          if options[:turbo]
            p = { tf: 1 }
          end
          if block_given?
            rv = tag.div class: "ov-form-wrapper", data: options[:wrapper_data] do
              if @ov_nested_form
                raise @ov_nested_form.inspect
                ov_fields_for @ov_nested_form,
                              **options,
                              &block
              else
                form_with(model: @ov_obj,
                          url: ov_obj_path(p),
                          class: "ov-form",
                          **options) do |form|
                  @ov_form = form
                  capture &block
                end
              end
            end
          else
            rv = ov_render_partial
          end
        end
        rv
      end
    end
  end
end

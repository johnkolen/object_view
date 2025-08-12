module ObjectView
  module ModalsHelper
    def ov_modal_header **options
      id = options[:id] || "modal"
      tag.div class: "modal-header ov-modal-header" do
        [ tag.div(options[:title] || "Title",
                  class: "modal-title ov-modal-title", # add fs-5 to css
                  id: "#{id}Label"),
          tag.button(type: "button",
                     class: "btn-close",
                     data: { "bs-dismiss": "modal" },
                     aria: { label: "Close" })
        ].join.html_safe
      end
    end

    def ov_modal_body **options, &block
      tag.div class: "modal-body ov-modal-body" do
        if block_given?
          capture &block
        else
          tag.div "Hello"
        end
      end
    end

    def ov_modal_footer **options
      tag.div class: "modal-footer ov-modal-footer" do
        [ tag.button("Close",
                     type: "button",
                     class: "btn btn-secondary",
                     data: { "bs-dismiss": "modal" },
                     aria: { label: "Close" })
        ].concat(options[:footer_buttons] || []).join.html_safe
      end
    end

    def ov_modal **options, &block
      id = options[:id] || "ov-modal"
      #raise "#{id} #{options.inspect}"
      tag.div class: "modal fade ov-modal",
              id: id,
              tabindex: -1,
              # data: {action:"show.bs.modal->fill hide.bs.modal->close"},
              aria: { labelledby: "#{id}Label", hidden: "true" } do
        tag.div class: "modal-dialog ov-modal-dialog" do
          tag.div class: "modal-content ov-modal-content" do
            [ ov_modal_header(**options, id: id),
              ov_modal_body(**options, id: id, &block),
              ov_modal_footer(**options, id: id)
            ].join.html_safe
          end
        end
      end
    end

    def ov_modal_objects klass, **options, &block
      obj = klass.first || klass
      id = "#{klass.to_s.underscore}_frame"
      tag.div data: { controller: "ov-modal-object" } do
        [ capture(&block),
          ov_modal_object_modal(id, obj)
        ].join.html_safe
      end
    end

    def ov_modal_object_modal id, obj, **options, &block
      buttons = [
        tag.button("Edit",
                   type: "button",
                   data: { action: "click->ov-modal-object#edit" },
                   class: "btn btn-primary"),
        tag.button("Show",
                   type: "button",
                   data: { action: "click->ov-modal-object#view" },
                   class: "btn btn-primary")
      ]
      if obj.is_a? Class
        edit_path = new_polymorphic_path(obj, params: { tf: 1 })
        # TODO: view_path should be nil since there isn't anything to view
        view_path = polymorphic_path(obj, params: { tf: 1 })
      else
        edit_path = edit_polymorphic_path(obj, params: { tf: 1 })
        view_path = polymorphic_path(obj, params: { tf: 1 })
      end
      ov_modal footer_buttons: buttons do
        turbo_frame_tag id,
                        src: nil,
                        # loading: :lazy,
                        data: {
                          "ov-modal-object-target": :frame,
                          edit: edit_path,
                          view: view_path
                        }
      end
    end

    def ov_modal_objects_view klass, turbo_content, **options, &block
      if @turbo || options[:turbo]
        id = "#{klass.to_s.underscore}_frame"
        if options[:object]
          obj = options[:object]
          edit_path = edit_polymorphic_path(obj, params: { tf: 1 })
          view_path = polymorphic_path(obj, params: { tf: 1 })
          turbo_frame_tag(id,
                          data: {
                            "ov-modal-object-target": :frame,
                            # edit: edit_path,
                            # view: view_path,
                            "object-id": options[:object].id
                          }) do
            turbo_content
          end
        else
          turbo_frame_tag(id) do
            turbo_content
          end
        end
      else
        capture(&block)
      end
    end
  end
end

module ObjectView
  module ButtonsHelper
    BUTTON_PRIMARY_CLASS = "btn btn-primary"
    BUTTON_SECONDARY_CLASS = "btn btn-secondary"

    def ov_button_to(label, path, **options)
      button_to label,
                path,
                method: options[:method] || :get,
                form_class: options[:form_class] || "ov-button",
                form: options[:form],
                class: options[:class] || "btn btn-primary"
    end

    def _skip? obj
      obj.is_a? Array
    end

    def ov_edit(obj = nil, **options)
      obj ||= @ov_obj
      return if _skip? obj
      return unless ov_allow? obj, :edit
      ov_button_to "Edit",
                   options[:path] || edit_polymorphic_path(obj),
                   **options
    end

  end
end

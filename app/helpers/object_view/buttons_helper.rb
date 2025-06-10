module ObjectView
  module ButtonsHelper
    # puts "loading #{self}"
    BUTTON_PRIMARY_CLASS = "btn btn-primary"
    BUTTON_SECONDARY_CLASS = "btn btn-secondary"
    BUTTON_DANGER_CLASS = "btn btn-secondary"

    def ov_button_to(label, path, **options)
      button_to label,
                path,
                method: options[:method] || :get,
                form_class: options[:form_class] || "ov-button",
                form: options[:form],
                class: options[:class] || BUTTON_PRIMARY_CLASS
    end

    def _ov_button_guard(obj, label, &block)
      obj ||= @ov_obj
      return if obj.is_a? TablesHelper::HeaderFor
      return unless ov_allow? obj, label
      yield obj
    end

    def ov_edit(obj = nil, **options)
      _ov_button_guard obj, :edit do |obj|
        ov_button_to "Edit",
                     options[:path] || edit_polymorphic_path(obj),
                     **options
      end
    end

    def ov_show(obj = nil, **options)
      _ov_button_guard obj, :view do  |obj|
        ov_button_to "Show",
                     polymorphic_path(obj),
                     **options
      end
    end

  def ov_delete(obj = nil, **options)
    _ov_button_guard obj, :delete do |obj|
      ov_button_to "Delete",
                   polymorphic_path(obj),
                   method: options[:method] || :delete,
                   form: { data: { turbo_confirm: "Are you sure?" } },
                   class: options[:class] || BUTTON_DANGER_CLASS
    end
  end

  def ov_new(klass, **options)
    return unless ov_allow? klass, :create
    ov_button_to "New",
                 new_polymorphic_path(klass),
                 **options
  end

  def ov_index(klass, **options)
    return unless ov_allow? klass, :index
    ov_button_to klass.to_s.pluralize,
                 polymorphic_path(klass),
                 **options
  end

  def ov_add
    return unless ov_allow? @ov_obj, :edit
    button_class = [
      "add-btn",
      "add-#{ov_obj_class_name_k}-btn",
      BUTTON_PRIMARY_CLASS
    ].join " "
    # Signals ov_fields_for that this tag will be used as a template
    @ov_new_record_found ||= @ov_obj.new_record?
    tag.button "Add",
               class: button_class,
               type: "button",
               data: { action: "click->ov-fields-for#add" }
  end

  def ov_remove(id)
    # return unless ov_allow? @ov_obj, :edit
    button_class = [
      "remove-btn",
      "remove-#{ov_obj_class_name_k}-btn",
      BUTTON_DANGER_CLASS
    ].join " "
    (@ov_form.hidden_field("_destroy",
                           class: "ov-hidden-destroy",
                           value: "true").gsub("_destroy", "DESTROY") +
     tag.button("Remove",
                class: button_class,
                type: "button",
                data: { action: "click->ov-fields-for#remove" },
                "data-bs-toggle": "collapse",
                "data-bs-target": "##{id}")).html_safe
  end

  def ov_submit(label = "Submit")
    return unless ov_allow? @ov_obj, @ov_access
    tag.button label, type: :submit, class: BUTTON_PRIMARY_CLASS
  end
  end
end

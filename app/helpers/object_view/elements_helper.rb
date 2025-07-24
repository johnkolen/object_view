module ObjectView
  module ElementsHelper
    def ov_text_field(oattr, **options)
      _ov_x_field(oattr,
                  :_ov_label,
                  :_ov_text_input,
                  :_ov_text_display,
                  **options)
    end

    def ov_string_field(oattr, **options)
      ov_text_field oattr, **options
    end

    def ov_integer_field(oattr, **options)
      ov_text_field oattr,
                    pattern: "^[0-9]+$" ,
                    **options
    end

    def ov_decimal_field(oattr, **options)
      ov_text_field oattr,
                    pattern: "^[0-9]+(\.[0-9]+)?$" ,
                    **options
    end

    def ov_textarea(oattr, **options)
      _ov_x_field(oattr,
                  :_ov_label,
                  :_ov_text_area_input,
                  :_ov_text_area_display,
                  **options)
    end
    alias ov_text_area ov_textarea

    def ov_password_field(oattr, **options)
      _ov_x_field(oattr,
                  :_ov_label,
                  :_ov_password_input,
                  :_ov_password_display,
                  **options)
    end

    def ov_checkbox(oattr, **options)
      _ov_x_field(oattr,
                  :_ov_no_label,
                  :_ov_checkbox_input,
                  :_ov_checkbox_display,
                  **options)
    end
    alias ov_boolean_field ov_checkbox

    def ov_select_field(oattr, **options)
      _ov_x_field(oattr,
                  :_ov_label,
                  :_ov_select_input,
                  :_ov_select_display,
                  **options)
    end
    alias ov_select ov_select_field

    def ov_date_field(oattr, **options)
      _ov_x_field(oattr,
                  :_ov_label,
                  :_ov_date_input,
                  :_ov_date_display,
                  **options)
    end

    def ov_datetime_field(oattr, **options)
      _ov_x_field(oattr,
                  :_ov_label,
                  :_ov_datetime_input,
                  :_ov_datetime_display,
                  **options)
    end

    def ov_hidden_field(oattr, **options)
      _ov_x_field(oattr,
                  :_ov_no_label,
                  :_ov_hidden_input,
                  nil,
                  **options)
    end
    ##############################################################

    def _ov_label oattr, id, **options
      tag.label(@ov_obj.send("#{oattr}_label"),
                for: id,
                class: @ov_form ? "form-label" : "ov-label")
    end

    def _ov_no_label oattr, id, **options
      # no label
    end

    ##############################################################

    def _ov_text_input oattr, id, **options
      @ov_form.text_field(oattr,
                          class: "form-control",
                          pattern: @ov_obj.send("#{oattr}_pattern") || options[:pattern],
                          id: id,
                          **options)
    end

    def _ov_text_display oattr, id, **options
      tag.div(@ov_obj.send("#{oattr}"),
              class: "ov-text display-#{oattr}",
              **options)
    end

    ##############################################################

    def _ov_text_input oattr, id, **options
      @ov_form.text_field(oattr,
                          class: "form-control",
                          pattern: @ov_obj.send("#{oattr}_pattern"),
                          id: id,
                          **options)
    end

    def _ov_text_display oattr, id, **options
      tag.div(@ov_obj.send("#{oattr}"),
              class: "ov-textarea display-#{oattr}",
              **options)
    end

    ##############################################################

    def _ov_text_area_input oattr, id, **options
      @ov_form.text_area(oattr,
                         class: "form-control",
                         pattern: @ov_obj.send("#{oattr}_pattern"),
                         id: id,
                         **options)
    end

    def _ov_text_area_display oattr, id, **options
      tag.div(@ov_obj.send("#{oattr}"), class: "ov-textarea display-#{oattr}")
    end

    ##############################################################

    def _ov_password_input oattr, id, **options
      @ov_form.password_field(oattr,
                              class: "form-control",
                              pattern: @ov_obj.send("#{oattr}_pattern"),
                              id: id,
                              **options)
    end

    def _ov_password_display oattr, id, **options
      tag.div(@ov_obj.send("#{oattr}"), class: "ov-password display-#{oattr}")
    end

    ##############################################################

    def _ov_checkbox_input oattr, id, **options
      cb_class = "form-check-input ov-checkbox"
      [
        @ov_form.checkbox(oattr,
                          class: cb_class,
                          id: id,
                          **options),
        tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: "form-check-label")
      ]
    end

    def _ov_checkbox_display oattr, id, **options
      cb_class = "form-check-input ov-checkbox"
      [
        tag.div(tag.input(type: "checkbox",
                          checked: @ov_obj.send("#{oattr}"),
                          onclick: "return false",
                          class: cb_class), class: "ov-checkbok-holder display-#{oattr}"),
        tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: "ov-checkbox-label")
      ]
    end

    ##############################################################

    def _ov_select_input oattr, id, **options
      mthd = "#{oattr}_id".to_sym
      if /(.+able)_type$/ =~ oattr
        mthd = oattr
      end
      opts = options_for_select(@ov_obj.send("#{oattr}_options"),
                                selected: @ov_obj.send(mthd))
      s_class = "form-select ov-select"
      tag.div(@ov_form.select(mthd,
                              opts,
                              {},
                              { class: s_class,
                                data: options[:data]}
                             )
             )
    end

    def _ov_select_display oattr, id, **options
      tag.div(@ov_obj.send("#{oattr}_str"), class: "ov-text")
    end

    ##############################################################

    # In progress
    def _ov_radio_input oattr, id, **options
      radio_name = "radio-#{radio_name ||= oattr}"
      r_class = "form-check-input ov-checkbox"
      @ov_form.radio_button(oattr,
                            class: rb_class,
                            name: radio_name,
                            id: id)
    end

    def _ov_radio_display oattr, id, **options
      tag.input("",
                value: @ov_obj.send("#{oattr}") ? "true" : "false",
                checked: @ov_obj.send("#{oattr}") ? "checked" : nil,
                type: "radio",
                class: cb_class)
    end

    ##############################################################

    def _ov_date_input oattr, id, **options
      @ov_form.date_field(oattr, class: "form-control", id: id)
    end

    def _ov_date_display oattr, id, **options
      tag.div(@ov_obj.send("#{oattr}_str"), class: "ov-date")
    end

    ##############################################################

    def _ov_datetime_input oattr, id, **options
      @ov_form.datetime_field(oattr, class: "form-control", id: id)
    end

    def _ov_datetime_display oattr, id, **options
      tag.div(@ov_obj.send("#{oattr}_str"), class: "ov-datetime")
    end

    ##############################################################

    def _ov_hidden_input oattr, id, **options
      @ov_form.hidden_field(oattr,
                            **options)
    end

    ##############################################################

    def _ov_x_field(oattr, labelx, inputx, displayx, **options)
      rv = ov_allow? oattr, @ov_access # , why: true
      can_edit = @ov_access == :edit && @ov_form && rv
      # puts "can_edit #{oattr} = #{can_edit}"
      can_view = !can_edit && ov_allow?(oattr, :view) # , why: true)
      # puts "can_view #{oattr} = #{can_view}"
      blocked = "<!-- access block #{@ov_obj.class}.#{oattr} -->"

      return blocked unless can_edit || can_view
      return ov_col(oattr, **options) if @ov_table_row
      return if @ov_obj.is_a? TablesHelper::HeaderFor  # table header
      id = oattr
      raise "wtf @ov_obj is nil" if @ov_obj.nil?

      tag.div(class: "ov-field") do
        out = []
        unless options[:no_label]
          out << send(labelx, oattr, id, **options)
        end
        if can_edit
          out << send(inputx, oattr, id, **options)
        elsif can_view
          out << send(displayx, oattr, id, **options)
        end
        out.join.html_safe
      end
    end

  end
end

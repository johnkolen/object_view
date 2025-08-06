module ObjectView
  module MessagesHelper
    # puts "loading #{self}"

    def ov_errors
      return nil unless @ov_obj && @ov_obj.errors.any?
      tag.div class: "alert alert-danger ov-error" do
        out = [ tag.h2("#{pluralize(@ov_obj.errors.count, "error")} " +
                       "prohibited this " +
                       ov_obj_class_name_h +
                       " from being saved:",
                       class: "ov-error-header"), "<ul>" ]
        @ov_obj.errors.each do |error|
          out << tag.li(error.full_message, class: "ov-error-item")
        end
        out << "</ul>"
        out.join.html_safe
      end.html_safe
    end
  end
end

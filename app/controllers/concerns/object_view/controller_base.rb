require "active_support/concern"

module ObjectView
  module ControllerBase
    extend ActiveSupport::Concern

    included do |base|
      base.before_action :set_access_user
    end

    def set_klass
      @klass = eval(controller_name.classify)
      @klass_str = @klass.to_s
      @klass_sym = @klass.to_s.underscore.to_sym
      @klass_p_str = @klass.to_s.pluralize
    end

    def set_access_user
      if defined? current_user
        ObjectView::AccessAlways.user = current_user
      else
        ObjectView::AccessAlways.user = nil
      end
    end

    def set_turbo
      @turbo = params[:tf]
      @tfp = @turbo ? { tf: params[:tf] } : {}
    end
  end
end

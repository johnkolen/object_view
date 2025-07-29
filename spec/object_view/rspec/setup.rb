module ObjectView
  module Rspec
    module Setup
      def klass_setup
        if controller
          begin
            @klass = controller.controller_path.classify.constantize
          rescue NameError
            return
          end
          @klass_str = @klass.to_s
          @klass_sym = @klass.to_s.underscore.to_sym
          @klass_p_str = @klass.to_s.pluralize
        end
      end

      def object
        self.class.object
      end

      def objects
        self.class.objects
      end

      def user
        self.class.user
      end

      def access_class
        self.class.access_class
      end

      def build_or_create(sym)
        case sym.to_s
        when /^create_(.*)/
          x = create $1.to_sym
          self.class.destroy_list << x
          x
        when /^build_(.*)/
          build $1.to_sym
        else
          sym
        end
      end

      def setup_object
        if object && object.is_a?(Symbol)
          self.class.object = build_or_create object
        end
      end

      def setup_objects
        self.class.objects = (self.class.objects || []).map do |x|
          if x && x.is_a?(Symbol)
            build_or_create x
          else
            x
          end
        end
      end

      def sign_in_user u
        if self.class.user_path &&
           respond_to?(self.class.user_path)
          begin
            put send(self.class.user_path, u)
            return
          rescue
          end
        end
        if defined? Devise::Test::IntegrationHelpers
          login_as u, scope: :user
          sign_in u, scope: :user
          return
        end
        rasie "could not log #{u.inspect} in"
      end

      def setup_user
        return unless defined?(Devise::Test::IntegrationHelpers) ||
                      access_class
        u = build(self.class.user)
        email = u.email
        if u.respond_to? :email
          u = u.class.find_by(email: email)
          unless u
            u = create(self.class.user)
            self.class.destroy_list << u
          end
        else
          raise "user does not have email field"
        end

        sign_in_user u

        if access_class
          access_class.user = user
          if respond_to? :sign_in
            sign_in(access_class.user, scope: :user) if access_class.user
          end
        end
      end

      def cleanup_objects
        delayed = []
        dlsize = self.class.destroy_list.size
        until self.class.destroy_list.empty?
          begin
            m = self.class.destroy_list.pop
            m.destroy!
          rescue ActiveRecord::InvalidForeignKey
            delayed << m
          end
          unless delayed.empty?
            unless dlsize == delayed.size
              self.class.destroy_list = delayed
              cleanup_objects
            end
          end
        end
      end

      def cleanup_user
        if defined? Devise::Test::IntegrationHelpers
          logout :user
        end
      end

      #########################################################

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        attr_accessor :destroy_list
        attr_accessor :access_class

        def commonSetup **options
          @options = options.dup
          @destroy_list = []
        end

        def object
          @object || @options[:object]
        end

        def object=(obj)
          @object = obj
        end

        def objects
          @objects || @options[:objects]
        end

        def objects=(objs)
          @objects = objs
        end

        def user
          @user || @options[:user]
        end

        def user_path
          @user_path || @options[:user_path]
        end

        def user=(user)
          @user = user
        end

        def object_class
          tgt = @options[:object] || (@options[:objects] || []).first
          if /(create|build)_(.*)/ =~ tgt
            $2.classify.constantize
          end
        end

        def object_entity
          tgt = @options[:object] || (@options[:objects] || []).first
          if /(create|build)_(.*)/ =~ tgt
            $2
          end
        end
      end
    end
  end
end

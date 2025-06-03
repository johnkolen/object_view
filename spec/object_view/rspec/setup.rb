module ObjectView
  module Rspec
    module Setup

      def klass_setup
        if controller
          @klass = controller.controller_path.classify.constantize
          @klass_str = @klass.to_s
          @klass_sym = @klass.to_s.underscore.to_sym
          @klass_p_str = @klass.to_s.pluralize
        end
      end

      def view_setup
        klass_setup
        if @klass
          assign(:klass, @klass)
          assign(:klass_str, @klass_str)
          assign(:klass_sym, @klass_sym)
          assign(:klass_p_str, @klass_p_str)
        end
        assign(@klass_sym, object) if @klass_sym
        assign(:object, object)
        assign(:objects, objects)
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
        if object && object.is_a? Symbol
          self.class.object = build_or_create object
        end
      end

      def setup_objects
        self.class.objects = self.class.objects.map do |x|
          if x && x.is_a? Symbol
            build_or_create x
          else
            x
          end
        end
      end

      def setup_user
        if access_class
          u = build(self.class.user)
          if u.respond_to? :email
            unless u.class.find_by(email: u.email)
              u = create(self.class.user)
              self.class.destroy_list << u
            end
          else
            raise "user does not have email field"
          end
          access_class.user = user
          if respond_to? :sign_in
            sign_in(access_class.user, scope: :user) if access_class.user
          end
        end
      end

      def cleanup_objects
        until self.class.destroy_list.empty?
          self.class.destroy_list.pop.destroy
        end
      end

      #########################################################

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        attr_accessor destroy_list
        attr_accessor access_class

        def commonSetup **options
          @options = options.dup
          @destroy_list = []
        end

        def object
          @object || @options[:object]
        end
        def object= obj
          @object = obj
        end
        def objects
          @objects || @options[:objects]
        end
        def objects= objs
          @objects = objs
        end
        def user
          @user || @options[:user]
        end
        def user= user
          @user = user
        end
      end
    end
  end
end

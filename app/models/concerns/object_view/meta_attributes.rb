require "active_support/concern"

module ObjectView
  module MetaAttributes
    extend ActiveSupport::Concern

    included do
      def is_field?(x)
        attribute_names.member?(x) ||
          self.class.reflect_on_association(x)
      end

      def method_missing(name, *args, &block)
        case name
        when /^(.*)_str$/
          if is_field? $1
            return send($1).to_s
          end
          if /^(.*?)_(.*)$/ =~ name
            assoc = $1
            rest = $2
            if respond_to? assoc
              # puts "sending #{assoc} #{rest}"
              return send(assoc).send(rest)
            end
          end
        when /^(.*)_label$/
          if is_field? $1
            return $1.humanize
          end
          if /^(.*?)_(.*)$/ =~ name
            assoc = $1
            rest = $2
            if respond_to? assoc
              # puts "sending #{assoc} #{rest}"
              a = send(assoc) || send("build_#{assoc}")
              raise "cain #{assoc} / #{rest}" unless a
              return a.send(rest)
            end
          end
        when /^(.*)_pattern$/
          if is_field? $1
            return nil
          end
        when /^(.*)_localtime$/
          if is_field? $1
            t = send($1)
            return t ? t.localtime.to_s : t
          end
        when /^(.*)_attributes$/
          if is_field?("#{$1}_type") && is_field?("#{$1}_id")
            t = send("#{$1}_type")
            return send(t.underscore) if t
            return nil
          end
        else
          if /^(.*?)_(.*)$/ =~ name
            assoc = $1
            rest = $2
            if respond_to? assoc
              a = send(assoc) || send("build_#{assoc}")
              raise "cain #{assoc} / #{rest}" unless a
              return a.send(rest)
            end
          end
        end
        super
      end

      def respond_to?(name, include_private = false)
        case name
        when /^(.*)_str$/,
             /^(.*)_label$/,
             /^(.*)_pattern$/,
             /^(.*)_localtime$/
          return true if is_field? $1
        end
        super
      end
    end

    module ClassMethods
      def fields_for?(x)
        return nil unless /(.*)_id$/ =~ x.to_s
        a = reflect_on_association($1)
        return nil if a.nil?
        a.macro == :belongs_to || a.macro == :has_many
      end
    end
  end
end

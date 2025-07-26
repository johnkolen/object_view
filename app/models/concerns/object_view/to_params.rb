require "active_support/concern"

module ObjectView
  module ToParams
    extend ActiveSupport::Concern

    included do
      def to_params
        raise "dep"
        h = attributes
        h.delete_if { |k, v| v.nil? }
        hx = {}
        h.each do |k, v|
          hx[k] = v.to_s
        end
        hasmany = self.class.reflect_on_all_associations(:has_many)
        belongsto = self.class.reflect_on_all_associations(:belongs_to)
        [ hasmany, belongsto ].flatten.each do |q|
          nm = q.name
          r = send(nm)
          z = {}
          if r.respond_to? :each_with_index
            r.each_with_index do |v, idx|
              z[idx] = v.to_params
            end
          else
            z = r.to_params
          end
          hx["#{nm}_attributes"] = z
        end
        hx
      end

      def add_values(h, keys)
        case keys
        when Symbol
          return h unless respond_to? keys
          v = send(keys)
          if v.is_a? ActiveRecord::Base
            v = v.to_params
          end
          h[keys.to_sym] = v
        when Hash
          keys.each do |k, attrs|
            if /(.*)_attributes/ =~ k.to_s
              # For some reason, when using has_one with a delegate_type
              # shoes up as a pluralized attribute (e.g. assets_attributes)
              if respond_to? $1
                r = send($1)
              else
                r = send($1.singularize)
              end
              next unless r
              if r.respond_to? :each_with_index
                z = {}
                r.each_with_index do |v, idx|
                  z[idx] = v.add_values({}, attrs)
                end
                h[k.to_sym] = z
              else
                h[k.to_sym] = r.add_values({}, attrs)
              end
            end
          end
        when Array
          keys.each do |k|
            add_values(h, k)
          end
        end
        h
      end

      def to_params **additional
        c = "#{self.class.name.pluralize}Controller"
        p = "#{self.class.name.underscore}_params"
        add_values({}, c.constantize.send(p)).merge! additional
      end
    end
  end
end

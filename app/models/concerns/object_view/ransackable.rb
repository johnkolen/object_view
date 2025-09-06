require "active_support/concern"

module ObjectView
  module Ransackable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def ransackable_attributes(auth_object=nil)
        @rattrs ||= []
      end

      def ransackable_associations(auth_object=nil)
        @rassoc ||= _reflections.select do |name, reflection|
          reflection.macro == :belongs_to
        end.keys
      end

      def ransortable_attributes(auth_object = nil)
        @rsattrs ||= []
      end

      def ransackable attr
        (@rattrs ||= []) << attr.to_s
        @rattrs = @rattrs.union
      end

      def ransortable attr
        (@rsattrs ||= []) << attr.to_s
        @rsattrs = @rsattrs.union
      end

      def make_ransacker attr, *pattrs, **mattrs
        ransackable attr

        ransacker attr,
                  formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
          values = [Arel::Nodes::SqlLiteral.new("' '")]
          pattrs.each do |attr|
            values << parent.table[attr]
          end
          mattrs.each do |model, attr|
            klass = model.to_s.constantize
            if attr.is_a? Symbol
              values << klass.arel_table[attr]
            else
              attr.each do |attr|
                values << klass.arel_table[attr]
              end
            end
          end
          Arel::Nodes::NamedFunction.
            new('LOWER', [
                  Arel::Nodes::NamedFunction.
                    new('CONCAT_WS', values)
                ])
        end
      end
    end
  end
end

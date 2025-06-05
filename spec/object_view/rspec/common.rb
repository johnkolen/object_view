module ObjectView
  module Rspec
    module Common
      def pp x
        node = Nokogiri::HTML(x)
        puts node.to_xhtml(indent: 2)
      end

      def errors_from x
        node = Nokogiri::HTML(x)
        errors = node.css('.ov-error')
        if errors
          errors.to_xhtml(indent: 2)
        else
          nil
        end
      end

      def process_attributes attrx, &block
        if attrx.is_a? Hash
          yield attrx
        elsif attrx.is_a? Enumerable
          attrx.each do |attrs|
            yield attrs
          end
        else
          raise "cannot process attributes: #{attrx.inspect}"
        end
      end

      def one attrx
        if attrx.is_a? Array
          attrx.first
        else
          attrx
        end
      end
    end
  end
end

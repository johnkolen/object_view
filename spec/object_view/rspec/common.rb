module ObjectView
  module Rspec
    module Common
      def pp x
        node = Nokogiri::HTML(x)
        puts node.to_xhtml(indent: 2)
      end

      def process_attributes attrx, &block
        if attrx.is_a? Enumerable
          attrx.each do |attrs|
            yield attrs
          end
        else
          yield attrx
        end
      end
    end
  end
end

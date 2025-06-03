module ObjectView
  module Rspec
    module Common
      def pp x
        node = Nokogiri::HTML(x)
        puts node.to_xhtml(indent: 2)
      end
    end
  end
end

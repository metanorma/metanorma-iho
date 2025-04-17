module IsoDoc
  module Iho
    module BaseConvert
      # terms not defined in standoc
      # KILL 
      def error_parsex(node, out)
        case node.name
        when "appendix" then clause_parse(node, out)
        else
          super
        end
      end

      def configuration
        Metanorma::Iho.configuration
      end
    end
  end
end

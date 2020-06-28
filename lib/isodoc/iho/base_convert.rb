module IsoDoc
  module IHO
    module BaseConvert
      # terms not defined in standoc
      def error_parse(node, out)
        case node.name
        when "appendix" then clause_parse(node, out)
        else
          super
        end
      end

      def info(isoxml, out)
        @meta.series isoxml, out
        @meta.commentperiod isoxml, out
        super
      end
    end
  end
end

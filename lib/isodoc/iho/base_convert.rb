require_relative "xref"

module IsoDoc
  module IHO
    module BaseConvert
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end

      def xref_init(lang, script, klass, labels, options)
        @xrefs = Xref.new(lang, script, klass, labels, options)
      end

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

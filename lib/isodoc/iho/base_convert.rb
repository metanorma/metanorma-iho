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
        super
      end

      def std_bibitem_entry(list, bib, ordinal, biblio)
        list.p **attr_code(iso_bibitem_entry_attrs(bib, biblio)) do |ref|
          prefix_bracketed_ref(ref, "[#{ordinal}]")
          reference_format(bib, ref)
        end
      end

      def omit_docid_prefix(prefix)
        return true if prefix == "IHO"

        super
      end
    end
  end
end

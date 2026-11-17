module Metanorma
  module Iho
    class Cleanup < ::Metanorma::Generic::Cleanup
      extend Forwardable

      # Boilerplate is selected by document language (en/fr/es,
      # metanorma-iho#566); any other language keeps the English IHO
      # boilerplate rather than falling through to the standoc default.
      def boilerplate_file(xmldoc)
        f = configuration.boilerplate
        f.is_a?(Hash) && !f[@lang] && f["en"] and
          return @conv.baselocation(f["en"])
        super
      end

      def bibdata_docidentifier_cleanup(isoxml)
        bibdata_docidentifier_i18n(isoxml)
        super
      end

      def bibdata_docidentifier_i18n(isoxml)
        id, parts = bibdata_docidentifier_i18n_prep(isoxml)
        (parts.empty? || id.nil?) and return
        id_alt = id.dup
        id.next = id_alt
        id["type"] and id_alt["type"] = "#{id["type"]}-parent-document"
        id_alt.delete("primary")
        bibdata_docidentifier_enhance(id, parts)
      end

      def bibdata_docidentifier_i18n_prep(isoxml)
        # Mutate the identifier the document actually carries
        # (metanorma-iho#577): a document compiled under a taste carries
        # that taste's organisation type on its primary docidentifier,
        # so a hardcoded type string is not a legal match key.
        id = isoxml.at("//bibdata/docidentifier[@primary = 'true']") ||
          isoxml.at("//bibdata/docidentifier")
        parts = %w(appendixid annexid part supplementid)
          .each_with_object({}) do |w, m|
          dn = isoxml.at("//bibdata/ext/structuredidentifier/#{w}") and
            m[w] = dn.text
        end
        [id, parts]
      end

      ID_LABELS = {
        appendixid: "Appendix",
        annexid: "Annex",
        part: "Part",
        supplementid: "Suppl",
      }.freeze

      # not language-specific, just space-delimited
      def bibdata_docidentifier_enhance(id, parts)
        ret = %w(appendixid part annexid supplementid)
          .each_with_object([]) do |w, m|
          p = parts[w] and m << "#{ID_LABELS[w.to_sym]} #{p}"
        end
        id.children = "#{id.text} #{ret.join(' ')}"
      end
    end
  end
end

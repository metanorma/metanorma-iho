require "isodoc"
require_relative "metadata"
require_relative "xref"

module IsoDoc
  module IHO
    module Init
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end

      def xref_init(lang, script, _klass, labels, options)
        html = HtmlConvert.new(language: lang, script: script)
        @xrefs = Xref.new(lang, script, html, labels, options)
      end

      def i18n_init(lang, script, i18nyaml = nil)
        @i18n = I18n.new(
          lang, script, i18nyaml: i18nyaml ||
          Metanorma::IHO.configuration.i18nyaml || @i18nyaml
        )
      end

      def info(isoxml, out)
        @meta.series isoxml, out
        super
      end

      def omit_docid_prefix(prefix)
        return true if prefix == "IHO"

        super
      end
    end
  end
end

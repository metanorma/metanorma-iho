require "isodoc"
require_relative "metadata"
require_relative "xref"

module IsoDoc
  module IHO
    module Init
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end

      def xref_init(lang, script, klass, labels, options)
        html = HtmlConvert.new(language: lang, script: script)
        @xrefs = Xref.new(lang, script, html, labels, options)
      end

      def i18n_init(lang, script, i18nyaml = nil)
        @i18n = I18n.new(
          lang, script, i18nyaml || 
          Metanorma::IHO.configuration.i18nyaml || @i18nyaml)
      end
    end
  end
end


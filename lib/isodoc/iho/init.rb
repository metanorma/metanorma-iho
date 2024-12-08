require "isodoc"
require_relative "metadata"
require_relative "xref"

module IsoDoc
  module Iho
    module Init
      def metadata_init(lang, script, locale, labels)
        @meta = Metadata.new(lang, script, locale, labels)
      end

      def xref_init(lang, script, _klass, labels, options)
        html = HtmlConvert.new(language: lang, script: script)
        @xrefs = Xref.new(lang, script, html, labels, options)
      end

      def i18n_init(lang, script, locale, i18nyaml = nil)
        @i18n = I18n.new(
          lang, script, locale: locale,
                        i18nyaml: i18nyaml ||
          Metanorma::Iho.configuration.i18nyaml || @i18nyaml
        )
      end

      def bibrenderer(options = {})
        ::Relaton::Render::Iho::General.new(options
          .merge(language: @lang, i18nhash: @i18n.get))
      end

      def info(isoxml, out)
        @meta.series isoxml, out
        super
      end
    end
  end
end

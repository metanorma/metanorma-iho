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
        i18ns = [i18nyaml, flavor_i18nyaml(lang), @i18nyaml]
        @i18n = I18n.new(lang, script, locale: locale, i18nyaml: i18ns)
      end

      # The flavour ships English, French and Spanish strings, selected
      # by document language (metanorma-iho#566: S-4 is published in
      # all three, with identical numbering). Any other language keeps
      # the English flavour overrides on top of the isodoc base strings,
      # as before the per-language split.
      def flavor_i18nyaml(lang)
        f = Metanorma::Iho.configuration.i18nyaml
        f.is_a?(Hash) or return f
        f[lang] || f["en"]
      end

      def bibrenderer(options = {})
        require_relative "../../metanorma/iho/citation_style"

        Metanorma::Iho::CitationStyle.new(options
          .merge(language: @lang, script: @script, i18nhash: @i18n.get))
      end

      def info(isoxml, out)
        @meta.series isoxml, out
        super
      end
    end
  end
end

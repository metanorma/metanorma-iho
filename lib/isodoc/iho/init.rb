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
    end
  end
end


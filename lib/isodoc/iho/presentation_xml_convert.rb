require_relative "init"
require "isodoc"
require "metanorma-generic"
require_relative "../../relaton/render/general"

module IsoDoc
  module IHO
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def bibrenderer
        ::Relaton::Render::IHO::General.new(language: @lang)
      end

      def norm_ref_entry_code(ordinal, _idents, _ids, _standard, _datefn, _bib)
        "[#{ordinal}]<tab/>"
      end

      def biblio_ref_entry_code(ordinal, _idents, _ids, _standard, _datefn, _bib)
        "[#{ordinal}]<tab/>"
      end

      include Init
    end
  end
end

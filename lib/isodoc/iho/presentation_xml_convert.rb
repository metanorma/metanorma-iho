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

      def biblio_ref_entry_code(ordinal, _idents, _ids, _standard, _datefn,
_bib)
        "[#{ordinal}]<tab/>"
      end

      def preface_rearrange(doc)
        preface_move(doc.at(ns("//preface/abstract")),
                     %w(foreword executivesummary introduction clause acknowledgements), doc)
        preface_move(doc.at(ns("//preface/foreword")),
                     %w(executivesummary introduction clause acknowledgements), doc)
        preface_move(doc.at(ns("//preface/executivesummary")),
                     %w(introduction clause acknowledgements), doc)
        preface_move(doc.at(ns("//preface/introduction")),
                     %w(clause acknowledgements), doc)
        preface_move(doc.at(ns("//preface/acknowledgements")),
                     %w(), doc)
      end

      include Init
    end
  end
end

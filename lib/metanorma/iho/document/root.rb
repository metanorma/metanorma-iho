# frozen_string_literal: true

module Metanorma
  module Iho::Document
    class Root < Lutaml::Model::Serializable
      include Metanorma::StandardDocument::RootAttributes

      attribute :bibdata, Metadata::IhoBibliographicItem
      attribute :preface,
                Metanorma::StandardDocument::Sections::Preface
      attribute :sections,
                Metanorma::StandardDocument::Sections::Sections
      attribute :annex,
                Metanorma::StandardDocument::Sections::AnnexSection,
                collection: true

      xml do
        element "metanorma"
        namespace Metanorma::StandardDocument::Namespace

        Metanorma::StandardDocument::RootXmlMapping.apply(self)
      end
    end
  end
end
# frozen_string_literal: true

module Metanorma
  module Iho::Document
    module Metadata
      # Series classification for IHO documents.
      class IhoSeries < Lutaml::Model::Serializable
        attribute :type, :string
        attribute :title, Metanorma::Document::Components::DataTypes::LocalizedString,
                  collection: true
        attribute :abbreviation, Metanorma::Document::Components::DataTypes::LocalizedString

        xml do
          element "series"
          map_attribute "type", to: :type
          map_element "title", to: :title
          map_element "abbreviation", to: :abbreviation
        end
      end
    end
  end
end
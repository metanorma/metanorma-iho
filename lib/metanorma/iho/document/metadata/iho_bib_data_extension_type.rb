# frozen_string_literal: true

module Metanorma
  module Iho::Document
    module Metadata
      # Extension point for bibliographical definitions of IHO documents.
      class IhoBibDataExtensionType < Lutaml::Model::Serializable
        attribute :doctype,
                  Metanorma::IsoDocument::Metadata::DoctypeElement,
                  collection: true
        attribute :flavor, :string
        attribute :editorial_group, IhoEditorialGroup

        xml do
          element "ext"
          map_element "doctype", to: :doctype
          map_element "flavor", to: :flavor
          map_element "editorialgroup", to: :editorial_group
        end
      end
    end
  end
end
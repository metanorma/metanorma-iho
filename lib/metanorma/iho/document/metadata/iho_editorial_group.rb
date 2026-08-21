# frozen_string_literal: true

module Metanorma
  module Iho::Document
    module Metadata
      # Editorial group for IHO documents with committee and workgroup.
      class IhoEditorialGroup < Lutaml::Model::Serializable
        attribute :committee, IhoSubGroup, collection: true
        attribute :workgroup, IhoSubGroup, collection: true

        xml do
          element "editorialgroup"
          map_element "committee", to: :committee
          map_element "workgroup", to: :workgroup
        end
      end
    end
  end
end
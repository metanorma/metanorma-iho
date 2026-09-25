# frozen_string_literal: true

module Metanorma
  module Iho::Document
    module Metadata
      # An editorial group sub-unit (committee, workgroup, etc.)
      # with an abbreviation child element.
      class IhoSubGroup < Lutaml::Model::Serializable
        attribute :abbreviation, :string

        xml do
          element "subgroup"
          map_element "abbreviation", to: :abbreviation
        end
      end
    end
  end
end

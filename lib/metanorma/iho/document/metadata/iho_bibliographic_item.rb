# frozen_string_literal: true

module Metanorma
  module Iho::Document
    module Metadata
      # The bibliographical description of an IHO document.
      # IHO-specific: series in bibdata, IHO editorial group in ext.
      class IhoBibliographicItem < Metanorma::IsoDocument::Metadata::IsoBibliographicItem
        attribute :ext, IhoBibDataExtensionType
        attribute :series, IhoSeries, collection: true

        xml do
          element "bibdata"
          map_element "ext", to: :ext
          map_element "series", to: :series
        end
      end
    end
  end
end

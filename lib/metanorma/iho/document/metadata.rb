# frozen_string_literal: true

module Metanorma
  module Iho::Document
    module Metadata
      autoload :IhoBibDataExtensionType,
               "#{__dir__}/metadata/iho_bib_data_extension_type"
      autoload :IhoBibliographicItem,
               "#{__dir__}/metadata/iho_bibliographic_item"
      autoload :IhoEditorialGroup, "#{__dir__}/metadata/iho_editorial_group"
      autoload :IhoSeries, "#{__dir__}/metadata/iho_series"
      autoload :IhoSubGroup, "#{__dir__}/metadata/iho_sub_group"
    end
  end
end
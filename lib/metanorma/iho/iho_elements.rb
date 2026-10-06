# frozen_string_literal: true

module Metanorma
  module Iho
    # IHO-specific data elements extending the engine's ISO 690
    # vocabulary, passed to the renderer as its element map
    module IhoElements
      # The IHO edition cites only for IHO-published documents (the
      # 1.x edition_fields_format gate), as the raw numeric edition
      # carrying its own label ("edition 3.1.0"); worded editions
      # ("Revision 1") cite as nothing
      class IhoEdition < ::Relaton::Render::Iso690::Elements::Edition
        def render
          return "" unless iho_publisher?

          text = edition_text
          text.match?(/\A\d/) ? "edition #{text}" : ""
        end

        private

        def edition_text
          raw = @model.edition
          raw.respond_to?(:content) ? raw.content.to_s : raw.to_s
        end

        def iho_publisher?
          Array(@model.contributor).any? do |c|
            next false unless Array(c.role).any? do |r|
              r.is_a?(String) ? r == "publisher" : r.type == "publisher"
            end

            org = c.organization or next false
            names = Array(org.name).map(&:content) +
                    [org.abbreviation&.content.to_s]
            names.any? do |n|
              %w[IHO International Hydrographic Organization].include?(n)
            end
          end
        end
      end
    end
  end
end

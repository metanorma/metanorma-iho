# frozen_string_literal: true

module Metanorma
  module Iho
    # IHO-specific data elements extending the engine's ISO 690
    # vocabulary, passed to the renderer as its element map
    module IhoElements
      # The IHO creator cites the affiliation's organization name
      # after the creator list ("D. Balenson, Internet Engineering
      # Task Force"), the 1.x name_fields affiliation behaviour
      class IhoCreator < ::Relaton::Render::Iso690::Elements::Creator
        def render
          out = super.to_s
          aff = affiliation_names
          out.empty? || aff.empty? ? out : "#{out}, #{aff}"
        end

        private

        def affiliation_names
          creators.filter_map do |c|
            person = c.person or next ""

            Array(person.affiliation).filter_map do |a|
              Array(a.organization&.name).map(&:content).first.to_s
            end.reject(&:empty?).first.to_s
          end.reject(&:empty?).uniq.join(", ")
        end
      end

      # The IHO edition cites only for IHO-published documents (the
      # 1.x edition_fields_format gate), as the raw numeric edition
      # carrying its own label ("edition 3.1.0"); worded editions
      # ("Revision 1") cite as nothing
      class IhoEdition < ::Relaton::Render::Iso690::Elements::Edition
        def render
          return "" unless iho_publisher?

          text = edition_text
          text.match?(/\A\d/) ? " edition #{text}" : ""
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

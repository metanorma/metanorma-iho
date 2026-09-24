# frozen_string_literal: true

module Metanorma
  module Iho
    module Html
      # Renders IHO documents on the harness's standard renderer: IHO
      # documents reuse the standoc section vocabulary, so only the
      # flavor-owned root and the clause/title pair left to flavors
      # need defining here.
      class Renderer < Metanorma::Html::StandardRenderer
        register_render "Metanorma::Iho::Document::Root",
                        :render_standard_document
        register_render "Metanorma::Standoc::Document::Sections::Sections",
                        :render_sections

        # IHO bibdata carries a structured IsoLocalizedTitle, which the
        # harness's generic title extraction does not decompose.
        def extract_display_title(bibdata)
          title = super
          return title unless title.nil? || title.to_s.empty?

          localized = bibdata.respond_to?(:title) ? bibdata.title : nil
          return title unless localized.is_a?(Metanorma::Iso::Document::Metadata::IsoLocalizedTitle)

          text = localized.to_s
          text && !text.empty? ? text : title
        end

        def render_sections(sections, **_opts)
          children = collect_ordered_children(sections)
          parts = []
          children.each do |node|
            next if node.is_a?(String)
            next if is_title_element?(node, sections)

            parts << (render(node, level: 1) || "")
          end
          parts.join
        end

        # The harness registers ContentSection / DefinitionSection to
        # :render_clause but leaves the method to flavors; ISO defines
        # the same pair in its renderer.
        def render_clause(clause, level: 1, **_opts)
          attrs = element_attrs(id: safe_attr(clause, :id))
          title = render_title(clause, level)
          content = render_ordered_content(clause, level)
          render_liquid("_element.html.liquid", "tag" => "div",
                                                "extra_attrs" => attrs,
                                                "content" => "#{title}#{content}")
        end

        def render_title(section, level)
          title_element = safe_attr(section, :fmt_title) ||
                          safe_attr(section, :title)
          return nil unless title_element

          section_id = safe_attr(section, :id)
          title_content = render_mixed_inline(title_element)
          register_toc_entry(id: section_id, level: level,
                             text: extract_plain_text(title_element))

          h = "h#{[[level, 6].min, 1].max}"
          render_liquid("_heading.html.liquid", tag: h, class_attr: "",
                                                content: title_content)
        end
      end
    end
  end
end

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

        # IHO cover matter: document identity strapline, development
        # stage and publisher line, content-equivalent to the former
        # isodoc title page (html_iho_titlepage.html).
        def render_coverpage(doc)
          super + render_liquid("_element.html.liquid", {
            "tag" => "div",
            "extra_attrs" => element_attrs(class: "iho-cover-details"),
            "content" => iho_cover_details(doc),
          })
        end

        def iho_cover_details(doc)
          bibdata = doc.bibdata
          return "" unless bibdata

          lines = []
          docnumber = scalar_bibdata_value(bibdata, :docnumber)
          edition = iho_edition(bibdata)
          identity = [
            docnumber ? "S-#{docnumber}" : nil,
            edition ? "Edition #{edition}" : nil,
          ].compact.join(" · ")
          lines << identity unless identity.empty?

          stage = iho_stage(bibdata)
          lines << stage if stage

          lines << "IHO Standard" if docnumber

          owner_line = iho_copyright_line(bibdata)
          lines << owner_line if owner_line

          lines.map { |l| render_liquid("_element.html.liquid", {
            "tag" => "p",
            "extra_attrs" => "",
            "content" => escape_html(l),
          }) }.join
        end

        def scalar_bibdata_value(bibdata, attr_name)
          v = bibdata.respond_to?(attr_name) ? bibdata.public_send(attr_name) : nil
          v.is_a?(String) ? v : nil
        end

        def iho_edition(bibdata)
          return nil unless bibdata.respond_to?(:edition)

          Array(bibdata.edition).filter_map do |e|
            next e if e.is_a?(String)
            next e.content if e.respond_to?(:content) && e.content.is_a?(String)

            nil
          end.first
        end

        def iho_stage(bibdata)
          st = bibdata.respond_to?(:status) ? bibdata.status : nil
          stage = st.respond_to?(:stage) ? st.stage : nil
          # status.stage is an Array of StageElement (mixed-content):
          # stringifying the array inspects model objects and can hit
          # self-referential structures — extract the text value.
          element = Array(stage).first
          return nil unless element.respond_to?(:value)

          text = Array(element.value).join.strip
          return nil if text.empty?

          text.split("-").map(&:capitalize).join(" ")
        end

        def iho_copyright_line(bibdata)
          cr = bibdata.respond_to?(:copyright) ? bibdata.copyright : nil
          entry = Array(cr).first
          return nil unless entry

          year = entry.respond_to?(:from) ? entry.from : nil
          year = nil unless year.is_a?(String)
          owner_name = nil
          owner = entry.respond_to?(:owner) ? Array(entry.owner).first : nil
          if owner.respond_to?(:content) && owner.content.is_a?(String)
            owner_name = owner.content
          elsif owner.respond_to?(:name)
            names = owner.name
            owner_name = names.is_a?(Array) ? names.filter_map do |n|
              n.respond_to?(:content) && n.content.is_a?(String) ? n.content : nil
            end.first : (names.is_a?(String) ? names : nil)
          end
          return nil unless owner_name

          year ? "© #{year} #{owner_name}" : owner_name
        end
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

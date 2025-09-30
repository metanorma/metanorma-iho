module Metanorma
  module Iho
    class Converter < Metanorma::Generic::Converter
      SERIESNAME = {
        B: "Bathymetric",
        C: "Capacity Building",
        M: "Miscellaneous",
        P: "Periodic",
        S: "Standards and Specifications",
      }.freeze

      def metadata_series(node, xml)
        series = node.attr("series") or return
        xml.series type: "main" do |s|
          s.title SERIESNAME[series.to_sym] || "N/A"
          s.abbreviation series
        end
      end

      def metadata_ext(node, ext)
        unless node.attr("workgroup")
          @log.add("AsciiDoc Input", nil,
                   "Missing workgroup attribute for document")
        end
        super
        metadata_commentperiod(node, ext)
      end

      def metadata_commentperiod(node, xml)
        from = node.attr("comment-from") or return
        to = node.attr("comment-to")
        xml.commentperiod do |c|
          c.from from
          c.to to if to
        end
      end

      def metadata_version(node, xml)
        if node.attr("edition-major")
          ed = node.attr("edition-major")
          e1 = node.attr("edition-minor") and ed += ".#{e1}"
          (e2 = node.attr("edition-patch")) && e1 and ed += ".#{e2}"
          node.set_attribute("edition", ed)
        end
        super
      end

      def title_main(node, xml)
        title = node.attr("title") or return
        add_title_xml(xml, title, "en", "title-main")
      end

      def title(node, xml)
        m = full_title_prep(node)
        full_title(m, xml)
        title_main(node, xml)
        %i(appendix annex part supplement).each do |w|
          typed_title(m, xml, w)
        end
        title_fallback(node, xml)
      end

      def typed_title(metadata, xml, type)
        metadata[type] or return
        title = full_title_part(metadata, type, TITLE_COMPONENTS[type][:id],
                                TITLE_COMPONENTS[type][:info])
        add_title_xml(xml, title, "en", "title-#{type}")
      end

      TITLE_COMPONENTS = {
        main: {},
        part: { id: :partid },
        annex: { id: :annexid, info: :infoannex },
        appendix: { id: :appendixid },
        supplement: { id: :supplementid },
      }.freeze

      def full_title(metadata, xml)
        parts = TITLE_COMPONENTS.keys.each_with_object([]) do |p, acc|
          acc << full_title_part(metadata, p, TITLE_COMPONENTS[p][:id],
                                 TITLE_COMPONENTS[p][:info])
        end
        add_title_xml(xml, parts.compact.join(", "), "en", "main")
      end

      TITLE_ID_LABELS = { main: "", annex: "Annex", appendix: "Appendix",
                          part: "Part", supplement: "Supplement" }.freeze

      def full_title_part(metadata, type, id, info)
        metadata[type] or return nil
        lbl = TITLE_ID_LABELS[type.to_sym]
        metadata[id] and lbl += " #{metadata[id]}"
        metadata[info] and lbl += " (Informative)"
        %i(appendix supplement part).include?(type) and lbl += ":"
        lbl == :main or lbl += " "
        lbl + metadata[type]
      end

      def full_title_prep(node)
        { main: node.attr("title") || node.title,
          annex: node.attr("title-annex"),
          appendix: node.attr("title-appendix"),
          supplement: node.attr("title-supplement"),
          part: node.attr("title-part"),
          partid: node.attr("partnumber"),
          annexid: node.attr("annex-id"),
          appendixid: node.attr("appendix-id"),
          supplementid: node.attr("supplement-id"),
          infoannex: node.attr("semantic-metadata-annex-informative") == "true" }
      end
    end
  end
end

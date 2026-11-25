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
          add_noko_elem(s, "title", SERIESNAME[series.to_sym] || "N/A")
          add_noko_elem(s, "abbreviation", series)
        end
      end

      # The :urn: document attribute carries the document's URN; bibdata
      # keeps it as a typed uri (metanorma-iho#579). Generating the URN
      # through pubid belongs to the consuming taste; this is the
      # generic attribute-to-bibdata propagation, inert when the
      # attribute is absent.
      def metadata_source(node, xml)
        super
        add_noko_elem(xml, "uri", node.attr("urn"), type: "urn")
      end

      def metadata_ext(node, ext)
        # Compile probes run the converter on bare internal documents
        # without user attributes; only warn on real document headers.
        if node.attr("docnumber") && node.attr("workgroup").nil?
          @log.add("IHO_1", nil)
        end
        super
        metadata_committee(node, ext)
        metadata_commentperiod(node, ext)
      end

      # S-158:1xx validation-check specifications carry the product
      # number as a Pubid::Iho `checks_for` member ("S-158:102" is
      # S-158 checks for S-102), not as part of the document number.
      # The :checks-for: document attribute carries it; the identifier is
      # constructed through Pubid::Iho so the face and the MRN URN
      # stay grammar-canonical. Documents without :checks-for: keep the
      # generic docid_template path.
      def metadata_id(node, xml)
        if (id = checks_for_identifier(node))
          # The IHO document face is unprefixed ("S-158:102"); the
          # publisher rides the docidentifier type and the URN.
          urn = id.to_urn
          id.publisher = nil
          add_noko_elem(xml, "docidentifier", id.to_s.strip,
                        primary: "true", boilerplate: true,
                        type: metadata_id_primary_type(node))
          add_noko_elem(xml, "docidentifier", urn, type: "URN")
        else
          super
        end
      end

      def checks_for_identifier(node)
        checks_for = node.attr("checks-for") or return nil
        number = node.attr("docnumber") or return nil
        Pubid::Iho::Identifier.parse("S-#{number}:#{checks_for}")
      rescue Pubid::Errors::ParseError
        @log.add("IHO_4", nil, params: [number, checks_for])
        nil
      end

      # IHO S-4 documents carry their editorial group as plain attributes:
      # :committee:/:workgroup: (with _2, _3… suffixes for additional
      # groups). Emitted into bibdata <ext><editorialgroup>, the shape
      # relaton's IHO hash parser normalizes
      # (relaton/iho/hash_parser_v1#editorialgroup_hash_to_bib). The
      # emission was dropped in d1af149 as an IEC-motivated ride-along
      # (metanorma-iec#191); IHO genuinely uses it.
      def metadata_committee(node, xml)
        node.attr("workgroup") or return
        i = 1
        while node.attr("workgroup#{i == 1 ? "" : "_#{i}"}")
          sfx = i == 1 ? "" : "_#{i}"
          xml.editorialgroup do |a|
            a.committee do |n|
              n.abbreviation node.attr("committee#{sfx}").to_s.upcase
            end
            a.workgroup do |n|
              n.abbreviation node.attr("workgroup#{sfx}").upcase
            end
          end
          i += 1
        end
      end

      # Loose-leaf sections (metanorma-iho#573). In a Part document
      # (:partnumber: B) a top-level clause declares its update unit with
      # [update-unit=B-400], a Pubid::Iho spec citation (B-400 is the
      # section-level citation of Section 400 of Part B). Each declaring
      # clause is enumerated in bibdata as a hasPart relation whose
      # bibitem carries the section title and the Pubid::Iho identifiers.
      def metadata_relations(node, xml)
        super
        metadata_update_units(node, xml)
      end

      def metadata_update_units(node, xml)
        part = node.attr("partnumber") or return
        update_unit_sections(node).each do |sect|
          id = update_unit_identifier(sect, part) or next
          xml.relation type: "hasPart" do |r|
            r.bibitem do |b|
              add_noko_elem(b, "title", sect.title)
              add_noko_elem(b, "docidentifier", id.to_s,
                            type: "IHO", primary: "true")
              add_noko_elem(b, "docidentifier", id.to_urn, type: "URN")
            end
          end
        end
      end

      def update_unit_sections(node)
        node.find_by(context: :section) do |s|
          s.level == 1 && s.attr("update-unit")
        end
      end

      def update_unit_identifier(sect, part)
        val = sect.attr("update-unit").to_s.strip
        id = update_unit_parse(val)
        if id.nil?
          @log.add("IHO_2", sect, params: [val])
        elsif id.part.to_s.casecmp(part.to_s).nonzero?
          @log.add("IHO_3", sect, params: [val, part])
          id = nil
        end
        id
      end

      def update_unit_parse(val)
        id = Pubid::Iho::Identifier.parse(val)
        id.respond_to?(:spec) && id.spec && id.part ? id : nil
      rescue StandardError
        nil
      end

      def metadata_commentperiod(node, xml)
        from = node.attr("comment-from") or return
        xml.commentperiod do |c|
          add_noko_elem(c, "from", from)
          add_noko_elem(c, "to", node.attr("comment-to"))
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
        title_nums(node, xml, @lang)
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

      def title_nums_prep(node)
        { part: node.attr("partnumber"),
          annex: node.attr("annex-id"),
          appendix: node.attr("appendix-id"),
          supplement: node.attr("supplement-id") }
      end

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

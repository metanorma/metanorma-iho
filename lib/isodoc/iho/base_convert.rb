module IsoDoc
  module IHO
    module BaseConvert
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end

      def annex_name_lbl(clause, num)
        lbl = clause["obligation"] == "informative" ? @appendix_lbl : @annex_lbl
        l10n("<b>#{lbl} #{num}</b>")
      end

      def annex_names(clause, num)
        appendix_names(clause, num)
        lbl = clause["obligation"] == "informative" ? @appendix_lbl : @annex_lbl
        @anchors[clause["id"]] =
          { label: annex_name_lbl(clause, num), type: "clause",
            xref: "#{lbl} #{num}", level: 1 }
        clause.xpath(ns("./clause | ./references | ./terms | ./definitions")).
          each_with_index do |c, i|
          annex_names1(c, "#{num}.#{i + 1}", 2)
        end
        hierarchical_asset_names(clause, num)
      end

      def back_anchor_names(docxml)
        super
          docxml.xpath(ns("//annex[@obligation = 'informative']")).each_with_index do |c, i|
            annex_names(c, i + 1)
          end
          docxml.xpath(ns("//annex[not(@obligation = 'informative')]")).each_with_index do |c, i|
            annex_names(c, (65 + i + (i > 7 ? 1 : 0)).chr.to_s)
          end
      end

      def annex_names1(clause, num, level)
        lbl = clause.at("./ancestor::xmlns:annex/@obligation").text == "informative" ? @appendix_lbl : @annex_lbl
        @anchors[clause["id"]] =
          { label: num, xref: "#{lbl} #{num}",
            level: level, type: "clause" }
        clause.xpath(ns("./clause | ./references | ./terms | ./definitions")).each_with_index do |c, i|
          annex_names1(c, "#{num}.#{i + 1}", level + 1)
        end
      end

      # terms not defined in standoc
      def error_parse(node, out)
        case node.name
        when "appendix" then clause_parse(node, out)
        else
          super
        end
      end

      def appendix_names(clause, num)
        clause.xpath(ns("./appendix")).each_with_index do |c, i|
          @anchors[c["id"]] = anchor_struct(i + 1, nil, @appendix_lbl, "clause")
          @anchors[c["id"]][:level] = 2
          @anchors[c["id"]][:container] = clause["id"]
        end
      end

      def info(isoxml, out)
        @meta.series isoxml, out
        @meta.commentperiod isoxml, out
        super
      end
    end
  end
end

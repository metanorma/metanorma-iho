require "isodoc/generic/xref"

module IsoDoc
  module IHO
    class Xref < IsoDoc::Generic::Xref
      def annex_name_lbl(clause, num)
        lbl = clause["obligation"] == "informative" ?
          @labels["appendix"] : @labels["annex"]
        l10n("<strong>#{lbl} #{num}</strong>")
      end

      def annex_names(clause, num)
        appendix_names(clause, num)
        lbl = clause["obligation"] == "informative" ?
          @labels["appendix"] : @labels["annex"]
        @anchors[clause["id"]] =
          { label: annex_name_lbl(clause, num), type: "clause",
            xref: "#{lbl} #{num}", level: 1 }
        if a = single_annex_special_section(clause)
          annex_names1(a, "#{num}", 1)
        else
          clause.xpath(ns("./clause | ./references | ./terms | ./definitions")).
            each_with_index do |c, i|
            annex_names1(c, "#{num}.#{i + 1}", 2)
          end
        end
        hierarchical_asset_names(clause, num)
      end

      def back_anchor_names(docxml)
        super
        docxml.xpath(ns("//annex[@obligation = 'informative']")).
          each_with_index do |c, i|
          annex_names(c, i + 1)
        end
        docxml.xpath(ns("//annex[not(@obligation = 'informative')]")).
          each_with_index do |c, i|
          annex_names(c, (65 + i + (i > 7 ? 1 : 0)).chr.to_s)
        end
      end

      def annex_names1(clause, num, level)
        lbl = clause.at("./ancestor::xmlns:annex/@obligation").
          text == "informative" ?  @labels["appendix"] : @labels["annex"]
        @anchors[clause["id"]] =
          { label: num, xref: "#{lbl} #{num}",
            level: level, type: "clause" }
        clause.xpath(ns("./clause | ./references | ./terms | ./definitions")).
          each_with_index do |c, i|
          annex_names1(c, "#{num}.#{i + 1}", level + 1)
        end
      end

      def appendix_names(clause, num)
        clause.xpath(ns("./appendix")).each_with_index do |c, i|
          @anchors[c["id"]] =
            anchor_struct(i + 1, nil, @labels["appendix"], "clause")
          @anchors[c["id"]][:level] = 2
          @anchors[c["id"]][:container] = clause["id"]
        end
      end

    def section_names1(clause, num, level)
      @anchors[clause["id"]] =
        { label: num, level: level, xref: l10n("#{@labels["subclause"]} #{num}"),
          type: "clause" }
      clause.xpath(ns(SUBCLAUSES)).
        each_with_index do |c, i|
        section_names1(c, "#{num}.#{i + 1}", level + 1)
      end
    end
    end
  end
end

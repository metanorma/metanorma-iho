require "isodoc/generic/xref"

module IsoDoc
  module IHO
    class Counter < IsoDoc::XrefGen::Counter
    end

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
            xref: l10n("#{lbl} #{num}"), level: 1, value: lbl }
        if a = single_annex_special_section(clause)
          annex_names1(a, "#{num}", 1)
        else
          i = Counter.new
          clause.xpath(ns("./clause | ./references | ./terms | ./definitions")).
            each do |c|
            i.increment(c)
            annex_names1(c, "#{num}.#{i.print}", 2)
          end
        end
        hierarchical_asset_names(clause, num)
      end

      def back_anchor_names(docxml)
        super
        i = Counter.new
        docxml.xpath(ns("//annex[@obligation = 'informative']")).
          each do |c|
          i.increment(c)
          annex_names(c, i.print)
        end
        i = Counter.new("@", skip_i: true)
        docxml.xpath(ns("//annex[not(@obligation = 'informative')]")).
          each do |c|
          i.increment(c)
          annex_names(c, i.print)
        end
      end

      def annex_names1(clause, num, level)
        lbl = clause.at("./ancestor::xmlns:annex/@obligation").
          text == "informative" ?  @labels["appendix"] : @labels["annex"]
        @anchors[clause["id"]] =
          { label: num, xref: l10n("#{lbl} #{num}"),
            level: level, type: "clause" }
         i = Counter.new
        clause.xpath(ns("./clause | ./references | ./terms | ./definitions")).
          each do |c|
          i.increment(c)
          annex_names1(c, "#{num}.#{i.print}", level + 1)
        end
      end

      def appendix_names(clause, num)
         i = Counter.new
        clause.xpath(ns("./appendix")).each_with_index do |c|
          i.increment(c)
          @anchors[c["id"]] =
            anchor_struct(i.print, nil, @labels["appendix"], "clause")
          @anchors[c["id"]][:level] = 2
          @anchors[c["id"]][:container] = clause["id"]
        end
      end

    def section_names1(clause, num, level)
      @anchors[clause["id"]] =
        { label: num, level: level, xref: l10n("#{@labels["subclause"]} #{num}"),
          type: "clause" }
      i = Counter.new
      clause.xpath(ns(SUBCLAUSES)).each_with_index do |c|
        i.increment(c)
        section_names1(c, "#{num}.#{i.print}", level + 1)
      end
    end
    end
  end
end

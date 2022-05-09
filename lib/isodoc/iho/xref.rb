require "isodoc/generic/xref"

module IsoDoc
  module IHO
    class Counter < IsoDoc::XrefGen::Counter
    end

    class Xref < IsoDoc::Generic::Xref
      def annexlbl(cond)
        cond ? @labels["appendix"] : @labels["annex"]
      end

      def annex_name_lbl(clause, num)
        lbl = annexlbl(clause["obligation"] == "informative")
        l10n("<strong>#{lbl} #{num}</strong>")
      end

      def annex_names(clause, num)
        appendix_names(clause, num)
        lbl = annexlbl(clause["obligation"] == "informative")
        @anchors[clause["id"]] =
          { label: annex_name_lbl(clause, num), type: "clause", elem: lbl,
            xref: l10n("#{lbl} #{num}"), level: 1, value: num }
        if @klass.single_term_clause?(clause)
          annex_names1(clause.at(ns("./references | ./terms | ./definitions")),
                       num.to_s, 1)
        else
          i = Counter.new
          clause.xpath(ns("./clause | ./references | ./terms | ./definitions"))
            .each do |c|
            i.increment(c)
            annex_names1(c, "#{num}.#{i.print}", 2)
          end
        end
        hierarchical_asset_names(clause, num)
      end

      def back_anchor_names(docxml)
        super
        if @parse_settings.empty? || @parse_settings[:clauses]
          i = Counter.new
          docxml.xpath(ns("//annex[@obligation = 'informative']"))
            .each do |c|
            i.increment(c)
            annex_names(c, i.print)
          end
          i = Counter.new("@", skip_i: true)
          docxml.xpath(ns("//annex[not(@obligation = 'informative')]"))
            .each do |c|
            i.increment(c)
            annex_names(c, i.print)
          end
        end
      end

      def annex_names1(clause, num, level)
        lbl = annexlbl(clause.at("./ancestor::xmlns:annex/@obligation")
            .text == "informative")
        @anchors[clause["id"]] =
          { label: num, xref: l10n("#{lbl} #{num}"),
            level: level, type: "clause" }
        i = Counter.new
        clause.xpath(ns("./clause | ./references | ./terms | ./definitions"))
          .each do |c|
          i.increment(c)
          annex_names1(c, "#{num}.#{i.print}", level + 1)
        end
      end

      def appendix_names(clause, _num)
        i = Counter.new
        clause.xpath(ns("./appendix")).each do |c|
          i.increment(c)
          @anchors[c["id"]] =
            anchor_struct(i.print, nil, @labels["appendix"], "clause")
          @anchors[c["id"]][:level] = 2
          @anchors[c["id"]][:container] = clause["id"]
        end
      end

      def section_names1(clause, num, level)
        @anchors[clause["id"]] =
          { label: num, level: level,
            xref: l10n("#{@labels['subclause']} #{num}"),
            type: "clause", elem: @labels["subclause"] }
        i = Counter.new
        clause.xpath(ns(SUBCLAUSES)).each do |c|
          i.increment(c)
          section_names1(c, "#{num}.#{i.print}", level + 1)
        end
      end
    end
  end
end

require "isodoc/generic/xref"

module IsoDoc
  module Iho
    class Counter < IsoDoc::XrefGen::Counter
    end

    class Xref < IsoDoc::Generic::Xref
      def hiersep
        "-"
      end

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
        annex_names_recurse(clause, num)
        annex_asset_names(clause, num, lbl)
      end

      def annex_names_recurse(clause, num)
        @klass.single_term_clause?(clause) and
          return annex_names1(clause.at(ns("./references | ./terms | ./definitions")),
                              num.to_s, 1)
        i = Counter.new
        clause.xpath(ns("./clause | ./references | ./terms | ./definitions"))
          .each do |c|
          i.increment(c)
          annex_names1(c, "#{num}.#{i.print}", 2)
        end
      end

      def annex_asset_names(clause, num, lbl)
        @annex_prefix = lbl
        hierarchical_asset_names(clause, num)
        @annex_prefix = nil
      end

      def anchor_struct_value(lbl, elem)
        @annex_prefix and lbl = l10n("#{@annex_prefix} #{lbl}")
        super
      end

      def clause_order_main(docxml)
        if docxml.at(ns("//bibliography//references[@normative = 'true']")) ||
            docxml.at(ns("//sections/references[@normative = 'true']"))
          [
            { path: "//sections/clause[@type = 'scope']" },
            { path: "#{@klass.norm_ref_xpath} | //sections/references" },
            { path: "//sections/terms | //sections/definitions | " \
              "//sections/clause[not(@type = 'scope')]", multi: true },
          ]
        else
          [
            { path: "//sections/terms | //sections/definitions | " \
              "//sections/references | " \
              "//bibliography/references[@normative = 'true'] | " \
              "//bibliography/clause[.//references[@normative = 'true']] | " \
              "//sections/clause", multi: true },
          ]
        end
      end

      def clause_order_annex(_docxml)
        [{ path: "//annex[not(@obligation = 'informative')]", multi: true },
         { path: "//annex[@obligation = 'informative']", multi: true }]
      end

      def annex_anchor_names(docxml)
        clause_order_annex(docxml).each_with_index do |a, i|
          n = i.zero? ? Counter.new("@", skip_i: true) : Counter.new
          docxml.xpath(ns(a[:path]))
            .each do |c|
            annex_names(c, n.increment(c).print)
            a[:multi] or break
          end
        end
      end

      def annex_names1(clause, num, level)
        lbl = annexlbl(clause.at("./ancestor::xmlns:annex/@obligation")
            .text == "informative")
        @anchors[clause["id"]] =
          { label: num, xref: l10n("#{lbl} #{num}"),
            level: level, type: "clause" }
        i = Counter.new(0, prefix: "#{num}.")
        clause.xpath(ns("./clause | ./references | ./terms | ./definitions"))
          .each do |c|
          annex_names1(c, i.increment(c).print, level + 1)
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
        i = Counter.new(0, prefix: "#{num}.")
        clause.xpath(ns(SUBCLAUSES)).each do |c|
          section_names1(c, i.increment(c).print, level + 1)
        end
      end

      def middle_sections
        "//sections/clause | #{@klass.norm_ref_xpath} | " \
          "//sections/terms | //sections/definitions | //sections/clause"
      end

      def middle_section_asset_names(doc)
        doc.xpath(ns(middle_sections)).each do |c|
          hierarchical_asset_names(c, @anchors[c["id"]][:label])
        end
      end

      def preface_names(clause)
        super
        sequential_asset_names(clause, container: true)
      end
    end
  end
end

require_relative "init"
require "isodoc"
require "metanorma-generic"
require_relative "../../relaton/render/general"

module IsoDoc
  module Iho
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def norm_ref_entry_code(ordinal, _idents, _ids, _standard, _datefn, _bib)
        "[#{ordinal}]<tab/>"
      end

      def biblio_ref_entry_code(ordinal, _idents, _ids, _standard, _datefn,
_bib)
        "[#{ordinal}]<tab/>"
      end

      def middle_title(docxml); end

      def bibdata(docxml)
        super
        dochistory(docxml)
      end

      UPDATE_RELATIONS = <<~XPATH.freeze
        //bibdata/relation[@type = 'updatedBy' or @type = 'merges' or @type = 'splits' or @type = 'hasDraft']/bibitem
      XPATH

      def dochistory(docxml)
        updates = docxml.xpath(ns(UPDATE_RELATIONS))
        updates.empty? and return
        pref = preface_insert_point(docxml)
        generate_dochistory(updates, pref)
      end

      def preface_insert_point(docxml)
        docxml.at(ns("//preface")) || docxml.at(ns("//sections"))
          .add_previous_sibling("<preface> </preface>").first
      end

      def generate_dochistory(updates, pref)
        ret = updates.map { |u| generate_dochistory_row(u) }.flatten.join("\n")
        pref << <<~XML
          <clause #{add_id_text}>
          <title #{add_id_text}>#{@i18n.dochistory}</title>
          <table #{add_id_text} unnumbered="true"><thead>
          <tr #{add_id_text}><th #{add_id_text}>Version Number</th><th #{add_id_text}>Date</th><th #{add_id_text}>Author</th><th #{add_id_text}>Description</th></tr>
          </thead><tbody>
          #{ret}
          </tbody></table></clause>
        XML
      end

      def generate_dochistory_row(item)
        e = item.at(ns("./edition"))&.text
        date = dochistory_date(item)
        c = dochistory_contributors(item)
        desc = dochistory_description(item)
        <<~XML
          <tr #{add_id_text}><td #{add_id_text}>#{e}</td><td #{add_id_text}>#{date}</td><td #{add_id_text}>#{c}</td><td #{add_id_text}>#{desc}</td></tr>
        XML
      end

      def dochistory_date(item)
        d = item.at(ns("./date[@type = 'updated']")) ||
          item.at(ns("./date[@type = 'published']")) ||
          item.at(ns("./date[@type = 'issued']")) or return ""
        ddMMMyyyy(d.text.strip)
      end

      def dochistory_contributors(item)
        item.xpath(ns("./contributor")).map do |c|
          dochistory_contributor(c)
        end.join(", ")
      end

      def dochistory_contributor(contrib)
        ret = contrib.at(ns("./organization/abbreviation")) ||
          contrib.at(ns("./organization/subdivision")) ||
          contrib.at(ns("./organization/name")) ||
          contrib.at(ns("./person/name/abbreviation")) ||
          contrib.at(ns("./person/name/completename"))
        ret and return ret.text
        format_personalname(contrib)
      end

      def format_personalname(contrib)
        Relaton::Render::General.new(template: { book: "{{ creatornames }}" })
          .render("<bibitem type='book'>#{contrib.to_xml}</bibitem>",
                  embedded: true)
      end

      def dochistory_description(item)
        d = item.at(ns("./amend/description")) or return ""
        d.children.to_xml
      end

      def ddMMMyyyy(isodate)
        isodate.nil? and return nil
        arr = isodate.split("-")
        if arr.size == 1 && (/^\d+$/.match isodate)
          Date.new(*arr.map(&:to_i)).strftime("%Y")
        elsif arr.size == 2
          Date.new(*arr.map(&:to_i)).strftime("%B %Y")
        else
          Date.parse(isodate).strftime("%d %B %Y")
        end
      end

      def omit_docid_prefix(prefix)
        prefix == "IHO" and return true
        super
      end

      def term1(elem); end

      def termsource1(elem)
        elem.parent.nil? and return
        super
      end

      def termsource_label(elem, sources)
        elem.at("./ancestor::xmlns:term") or return
        elem.replace(l10n("[#{sources}]"))
      end

      def termcleanup(docxml)
        collapse_term docxml
        super
      end

      def collapse_term(docxml)
        docxml.xpath(ns("//term")).each { |t| collapse_term1(t) }
      end

      def collapse_term1(term)
        defn = term.at(ns("./fmt-definition")) or return
        source = term.at(ns("./fmt-termsource")) or return
        defn.elements.last << source.children
        source.remove
      end

      def clausedelim
        ""
      end

      def ul_label_list(_elem)
        %w(&#x2022; &#x2014; &#x6f;)
      end

      include Init
    end
  end
end

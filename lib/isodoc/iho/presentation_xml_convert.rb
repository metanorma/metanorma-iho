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

      def preface_rearrange(doc)
        preface_move(doc.at(ns("//preface/abstract")),
                     %w(foreword executivesummary introduction clause acknowledgements), doc)
        preface_move(doc.at(ns("//preface/foreword")),
                     %w(executivesummary introduction clause acknowledgements), doc)
        preface_move(doc.at(ns("//preface/executivesummary")),
                     %w(introduction clause acknowledgements), doc)
        preface_move(doc.at(ns("//preface/introduction")),
                     %w(clause acknowledgements), doc)
        preface_move(doc.at(ns("//preface/acknowledgements")),
                     %w(), doc)
      end

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
          <clause id='_#{UUIDTools::UUID.random_create}'>
          <title>#{@i18n.dochistory}</title>
          <table unnumbered="true"><thead>
          <tr><th>Version Number</th><th>Date</th><th>Author</th><th>Description</th></tr>
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
        "<tr><td>#{e}</td><td>#{date}</td><td>#{c}</td><td>#{desc}</td></tr>"
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
        ret = contrib.at("./organization/abbreviation") ||
          contrib.at("./organization/subdivision") ||
          contrib.at("./organization/name") ||
          contrib.at("./person/name/abbreviation") ||
          contrib.at("./person/name/completename")
        ret and return ret.text
        format_personalname(contrib)
      end

      def format_personalname(contrib)
        Relaton::Render::General.new(template: { book: "{{ creatornames }}" })
          .render("<bibitem type='book'>#{contrib.to_xml}</bibitem>")
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

      def clausedelim
        ""
      end

      include Init
    end
  end
end

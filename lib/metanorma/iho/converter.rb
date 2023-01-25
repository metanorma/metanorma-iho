require "metanorma/standoc/converter"
require "metanorma/generic/converter"

module Metanorma
  module IHO
    class Converter < Metanorma::Generic::Converter
      XML_ROOT_TAG = "iho-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/iho".freeze

      register_for "iho"

      def clause_parse(attrs, xml, node)
        node.option? "appendix" and
          return appendix_parse(attrs, xml, node)
        super
      end

      def appendix_parse(attrs, xml, node)
        attrs[:"inline-header"] = node.option? "inline-header"
        set_obligation(attrs, node)
        xml.appendix **attr_code(attrs) do |xml_section|
          xml_section.title { |name| name << node.title }
          xml_section << node.content
        end
      end

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

      def metadata_committee(node, xml)
        unless node.attr("workgroup")
          @log.add("AsciiDoc Input", nil,
                   "Missing workgroup attribute for document")
          return
        end
        metadata_committee1(node, xml)
      end

      def metadata_committee1(node, xml)
        xml.editorialgroup do |a|
          a.committee do |n|
            n.abbreviation node.attr("committee").upcase
          end
          a.workgroup do |n|
            n.abbreviation node.attr("workgroup").upcase
          end
        end
        i = 2
        while node.attr("workgroup_#{i}")
          xml.editorialgroup do |a|
            a.committee do |n|
              n.abbreviation node.attr("committee_#{i}").upcase
            end
            a.workgroup do |n|
              n.abbreviation node.attr("workgroup_#{i}").upcase
            end
          end
          i += 1
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

      def configuration
        Metanorma::IHO.configuration
      end

      def presentation_xml_converter(node)
        IsoDoc::IHO::PresentationXMLConvert.new(html_extract_attributes(node))
      end

      def html_converter(node)
        IsoDoc::IHO::HtmlConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")

        IsoDoc::IHO::PdfConvert.new(pdf_extract_attributes(node))
      end

      def doc_converter(node)
        IsoDoc::IHO::WordConvert.new(doc_extract_attributes(node))
      end
    end
  end
end

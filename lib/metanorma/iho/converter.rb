require "metanorma/standoc/converter"
require "metanorma/generic/converter"

module Metanorma
  module Iho
    class Converter < Metanorma::Generic::Converter
      register_for "iho"

      def support_appendix?(_node)
        true
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
        Metanorma::Iho.configuration
      end

      def presentation_xml_converter(node)
        IsoDoc::Iho::PresentationXMLConvert
          .new(html_extract_attributes(node)
          .merge(output_formats: ::Metanorma::Iho::Processor.new.output_formats))
      end

      def html_converter(node)
        IsoDoc::Iho::HtmlConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        node.attr("no-pdf") and return nil
        IsoDoc::Iho::PdfConvert.new(pdf_extract_attributes(node))
      end

      def doc_converter(node)
        IsoDoc::Iho::WordConvert.new(doc_extract_attributes(node))
      end
    end
  end
end

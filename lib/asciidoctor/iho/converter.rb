require "asciidoctor/standoc/converter"
require 'asciidoctor/generic/converter'

module Asciidoctor
  module IHO
    # A {Converter} implementation that generates RSD output, and a document
    # schema encapsulation of the document for validation
    #
    class Converter < Asciidoctor::Generic::Converter
      XML_ROOT_TAG = 'iho-standard'.freeze
      XML_NAMESPACE = 'https://www.metanorma.org/ns/iho'.freeze

      register_for "iho"

      def clause_parse(attrs, xml, node)
        node.option? "appendix" and
          return appendix_parse(attrs, xml, node)
        super
      end

      def appendix_parse(attrs, xml, node)
        attrs["inline-header".to_sym] = node.option? "inline-header"
        set_obligation(attrs, node)
        xml.appendix **attr_code(attrs) do |xml_section|
          xml_section.title { |name| name << node.title }
          xml_section << node.content
        end
      end

      def metadata_series(node, xml)
        series = node.attr("series") or return
        xml.series **{ type: "main" } do |s|
          s.title series
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
        return unless node.attr("workgroup")
        xml.editorialgroup do |a|
          a.committee node.attr("committee")
          a.workgroup node.attr("workgroup")
        end
        i = 2
        while node.attr("workgroup_#{i}") do
          xml.editorialgroup do |a|
            a.committee node.attr("committee_#{i}")
            a.workgroup node.attr("workgroup_#{i}")
          end
          i += 1
        end
      end

      def configuration
        Metanorma::IHO.configuration
      end

      def html_converter(node)
        IsoDoc::IHO::HtmlConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")
        IsoDoc::IHO::PdfConvert.new(html_extract_attributes(node))
      end

      def word_converter(node)
        IsoDoc::IHO::WordConvert.new(doc_extract_attributes(node))
      end
    end
  end
end

require "metanorma/standoc/converter"
require "metanorma/generic/converter"
require_relative "cleanup"
require_relative "front"

module Metanorma
  module Iho
    class Converter < Metanorma::Generic::Converter
      register_for "iho"

      def support_appendix?(_node)
        true
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

require_relative "log"

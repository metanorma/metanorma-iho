require "metanorma-standoc"
require "metanorma-generic"
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

      # IHO M-3 (2026) development-stage vocabulary (metanorma-iho#553):
      # a `:status:` value may be the stage slug or its M-3 abbreviation;
      # both normalize to the slug with the abbreviation carried on the
      # stage element. Values outside the M-3 vocabulary pass through
      # unchanged (in-force, draft, ...).
      def metadata_status(node, xml)
        return super unless node.attr("status")

        stage, abbr = M3Stages.normalize(node.attr("status"))
        abbr ||= node.attr("docstage-abbrev")
        xml.status do |s|
          add_noko_elem(s, "stage", stage, abbreviation: abbr)
          add_noko_elem(s, "substage", node.attr("docsubstage") ||
                        node.attr("substage"))
          add_noko_elem(s, "iteration", node.attr("iteration"))
        end
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

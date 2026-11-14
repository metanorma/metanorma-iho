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

      # A taste registers its own vocabulary through its metanorma.yml,
      # handed to the converter as the :customize: document attribute
      # (metanorma-iho#578). The generic implementation files it under
      # the generic flavour's configuration, which nothing on this
      # flavour's path reads: file it under this flavour's
      # configuration instead, and re-register this flavour's
      # processor. The taste's doctype vocabulary extends the base's
      # rather than replacing it: a document of the base vocabulary
      # stays legal under a taste that declares its own.
      def read_config_file(path_to_config_file)
        base_doctypes = configuration.doctypes || {}
        configuration.set_default_values_from_yaml_file(path_to_config_file)
        taste_doctypes = configuration.doctypes and
          configuration.doctypes = base_doctypes.merge(taste_doctypes)
        Metanorma::Registry.instance.register(Metanorma::Iho::Processor)
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

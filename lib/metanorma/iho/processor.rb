require "metanorma/processor"

module Metanorma
  module Iho
    class Processor < Metanorma::Generic::Processor
      def configuration
        Metanorma::Iho.configuration
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf",
        )
      end

      def version
        "Metanorma::Iho #{Metanorma::Iho::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options={})
        options_preprocess(options)
        case format
        when :html
          IsoDoc::Iho::HtmlConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :doc
          IsoDoc::Iho::WordConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::Iho::PdfConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::Iho::PresentationXMLConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end

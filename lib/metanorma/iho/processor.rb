require "metanorma/processor"

module Metanorma
  module IHO
    def self.fonts_used
      {
        html: ["SourceSansPro-Light", "SourceSerifPro", "SourceCodePro-Light", "HanSans"],
        doc: ["SourceSansPro-Light", "SourceSerifPro", "SourceCodePro-Light", "HanSans"],
        pdf: ["SourceSansPro-Light", "SourceSerifPro", "SourceCodePro-Light", "HanSans"],
      }
    end

    class Processor < Metanorma::Generic::Processor
      def configuration
        Metanorma::IHO.configuration
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf",
        )
      end

      def version
        "Metanorma::IHO #{Metanorma::IHO::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options={})
        case format
        when :html
          IsoDoc::IHO::HtmlConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :doc
          IsoDoc::IHO::WordConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::IHO::PdfConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::IHO::PresentationXMLConvert.new(options).convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end

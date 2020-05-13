require "metanorma/processor"

module Metanorma
  module IHO
    def self.fonts_used
      ["SourceSansPro-Light", "SourceSerifPro", "SourceCodePro-Light", "HanSans"]
    end

    class Processor < Metanorma::Generic::Processor
      def configuration
        Metanorma::IHO.configuration
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
        ).tap { |hs| hs.delete(:pdf) }
      end

      def version
        "Metanorma::IHO #{Metanorma::IHO::VERSION}"
      end

      def output(isodoc_node, outname, format, options={})
        case format
        when :html
          IsoDoc::IHO::HtmlConvert.new(options).convert(outname, isodoc_node)
        when :doc
          IsoDoc::IHO::WordConvert.new(options).convert(outname, isodoc_node)
        else
          super
        end
      end
    end
  end
end

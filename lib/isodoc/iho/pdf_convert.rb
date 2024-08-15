require "isodoc"
require "metanorma-generic"
require_relative "base_convert"

module IsoDoc
  module IHO
    # A {Converter} implementation that generates PDF HTML output, and a
    # document schema encapsulation of the document for validation
    class PdfConvert < IsoDoc::Generic::PdfConvert
      def initialize(options)
        super
        @libdir = File.dirname(__FILE__)
      end

      def pdf_stylesheet(docxml)
        case @doctype
        when "standard" then "iho.standard.xsl"
        else
          "iho.specification.xsl"
        end
      end

      include BaseConvert
      include Init
    end
  end
end

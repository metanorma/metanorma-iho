require "isodoc"

module IsoDoc
  module IHO
    # A {Converter} implementation that generates PDF HTML output, and a
    # document schema encapsulation of the document for validation
    class PdfConvert <  IsoDoc::XslfoPdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def pdf_stylesheet(docxml)
        case doctype = docxml&.at(ns("//bibdata/ext/doctype"))&.text
        when "standard" then "iho.standard.xsl"
        else
          "iho.specification.xsl"
        end
      end
    end
  end
end


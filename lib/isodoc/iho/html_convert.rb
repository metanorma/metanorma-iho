require "isodoc"
require "isodoc/generic/html_convert"
require_relative "init"

module IsoDoc
  module IHO
    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
    class HtmlConvert < IsoDoc::Generic::HtmlConvert
      def configuration
        Metanorma::IHO.configuration
      end

      def make_body3(body, docxml)
        body.div **{ class: "main-section" } do |div3|
          boilerplate docxml, div3
          abstract docxml, div3
          foreword docxml, div3
          introduction docxml, div3
          preface docxml, div3
          acknowledgements docxml, div3
          middle docxml, div3
          footnotes div3
          comments div3
        end
      end

      include BaseConvert
      include Init
    end
  end
end


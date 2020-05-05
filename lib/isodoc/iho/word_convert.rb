require "isodoc"
require "isodoc/generic/word_convert"
require "isodoc/iho/metadata"

module IsoDoc
  module IHO
    # A {Converter} implementation that generates Word output, and a document
    # schema encapsulation of the document for validation
    class WordConvert < IsoDoc::Generic::WordConvert
      def configuration
        Metanorma::IHO.configuration
      end

      def make_body2(body, docxml)
        body.div **{ class: "WordSection2" } do |div2|
          boilerplate docxml, div2
          abstract docxml, div2
          foreword docxml, div2
          introduction docxml, div2
          preface docxml, div2
          acknowledgements docxml, div2
          div2.p { |p| p << "&nbsp;" } # placeholder
        end
        section_break(body)
      end

      include BaseConvert
    end
  end
end

require "isodoc"
require "isodoc/generic/word_convert"
require_relative "init"

module IsoDoc
  module IHO
    # A {Converter} implementation that generates Word output, and a document
    # schema encapsulation of the document for validation
    class WordConvert < IsoDoc::Generic::WordConvert
      def configuration
        Metanorma::IHO.configuration
      end

      def make_body1(body, _docxml)
        body.div class: "WordSection1" do |div1|
          div1.p style: "font-size:0pt;" do |p|
            p << "&nbsp;"
          end # placeholder
        end
        section_break(body)
      end

      def authority_cleanup(docxml)
        super
        docxml.xpath("//div[@class = 'boilerplate-feedback']/p").each do |p|
          p["style"] = "font-size:8pt;font-family:Arial;text-align:right"
        end
      end

      include BaseConvert
      include Init
    end
  end
end

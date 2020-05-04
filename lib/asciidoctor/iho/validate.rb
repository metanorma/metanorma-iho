module Asciidoctor
  module IHO
    class Converter < Standoc::Converter
      def content_validate(doc)
        super
        bibdata_validate(doc.root)
      end

      def bibdata_validate(doc)
        stage_validate(doc)
      end

      def stage_validate(xmldoc)
        stage = xmldoc&.at("//bibdata/status/stage")&.text
        %w(proposal working-draft committee-draft draft-standard final-draft
        published withdrawn).include? stage or
        @log.add("Document Attributes", nil, "#{stage} is not a recognised status")
      end
    end
  end
end


require_relative "init"
require "isodoc"
require "metanorma-generic"
require_relative "../../relaton/render/general"

module IsoDoc
  module IHO
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def bibrenderer
        ::Relaton::Render::IHO::General.new(language: @lang)
      end

      include Init
    end
  end
end

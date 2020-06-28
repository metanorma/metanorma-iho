require_relative "init"
require "isodoc"
require "metanorma-generic"

module IsoDoc
  module IHO
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      include Init
    end
  end
end


require "isodoc"
require "isodoc/generic/html_convert"
require_relative "init"

module IsoDoc
  module Iho
    class HtmlConvert < IsoDoc::Generic::HtmlConvert

      include BaseConvert
      include Init
    end
  end
end


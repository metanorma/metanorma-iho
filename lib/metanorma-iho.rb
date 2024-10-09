require "asciidoctor" unless defined? Asciidoctor::Converter
require_relative "metanorma/iho/converter"
require_relative "isodoc/iho/base_convert"
require_relative "isodoc/iho/html_convert"
require_relative "isodoc/iho/word_convert"
require_relative "isodoc/iho/pdf_convert"
require_relative "isodoc/iho/presentation_xml_convert"
require_relative "metanorma/iho/version"
require "metanorma"

if defined? Metanorma::Registry
  require_relative "metanorma/iho"
  Metanorma::Registry.instance.register(Metanorma::Iho::Processor)
end

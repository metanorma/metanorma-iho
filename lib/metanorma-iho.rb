require "asciidoctor" unless defined? Asciidoctor::Converter
require_relative "asciidoctor/iho/converter"
require_relative "isodoc/iho/base_convert"
require_relative "isodoc/iho/html_convert"
require_relative "isodoc/iho/word_convert"
require_relative "isodoc/iho/pdf_convert"
require_relative "isodoc/iho/presentation_xml_convert"
require_relative "metanorma/iho/version"

if defined? Metanorma
  require_relative "metanorma/iho"
  Metanorma::Registry.instance.register(Metanorma::IHO::Processor)
end

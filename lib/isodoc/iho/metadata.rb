require "isodoc"

module IsoDoc
  module Iho
    class Metadata < IsoDoc::Generic::Metadata
      class << self
        include ::IsoDoc::ClassUtils
      end

      def initialize(lang, script, locale, i18n, fonts_options = {})
        super
        @tempfile_cache = []
      end

      def configuration
        Metanorma::Iho.configuration
      end

      def series(xml, _out)
        set(:series, xml.at(ns("//bibdata/series[@type = 'main']/title"))&.text)
        a = xml.at(ns("//bibdata/series[@type = 'main']/abbreviation"))
        a&.text and set(:seriesabbr, a.text)
      end

      def title1(xml, type)
        xml.at(ns("//bibdata/title[@type='title-#{type}']"))
          &.children&.to_xml
      end

      def title(isoxml, _out)
        set(:doctitle, isoxml.at(ns("//bibdata/title[@type='main']"))
                                    &.children&.to_xml || "")
        %w(main appendix annex part supplement).each do |e|
          t = title1(isoxml, e) and set("#{e}title".to_sym, t)
        end
      end

      def images_logo_xpaths
        org = "//bibdata/contributor[role/@type = 'publisher']/organization"
        {
          logo: "//#{org}/logo[@type = 'full']/image",
          logo_desc: "//#{org}/logo[@type = 'desc']/image",
          logo_mark: "//#{org}/logo[@type = 'mark']/image",
          logo_sign: "//#{org}/logo[@type = 'sign']/image",
        }
      end

      def images(xml, out)
        super
        images_logo_xpaths.each do |k, v|
          i = xml.at(ns(v))
          set(k, i ? to_xml(i.at("./*[local-name() = 'svg']"))&.strip : nil)
          # require "debug"; binding.b if i&.at(ns("./emf/@src"))
          src = i&.at(ns("./emf/@src"))
          src and set("#{k}_emf".to_sym, save_dataimage(src.text))
        end
      end

      include ::IsoDoc::Function::Utils
    end
  end
end

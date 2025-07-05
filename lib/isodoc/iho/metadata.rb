require "isodoc"

module IsoDoc
  module Iho

    class Metadata < IsoDoc::Generic::Metadata
      def configuration
        Metanorma::Iho.configuration
      end

      def series(xml, _out)
        set(:series, xml.at(ns("//bibdata/series[@type = 'main']/title"))&.text)
        a = xml.at(ns("//bibdata/series[@type = 'main']/abbreviation"))&.text and
          set(:seriesabbr, a)
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
    end
  end
end

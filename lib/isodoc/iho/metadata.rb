require "isodoc"

module IsoDoc
  module IHO

    class Metadata < IsoDoc::Generic::Metadata
      def configuration
        Metanorma::IHO.configuration
      end

      def series(xml, _out)
        set(:series, xml.at(ns("//bibdata/series[@type = 'main']/title"))&.text)
        a = xml.at(ns("//bibdata/series[@type = 'main']/abbreviation"))&.text and
          set(:seriesabbr, a)
      end
    end
  end
end

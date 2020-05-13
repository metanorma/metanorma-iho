require "isodoc"

module IsoDoc
  module IHO

    class Metadata < IsoDoc::Generic::Metadata
      def configuration
        Metanorma::IHO.configuration
      end

      def commentperiod(ixml, _out)
        from = ixml.at(ns("//bibdata/ext/commentperiod/from"))&.text
        to = ixml.at(ns("//bibdata/ext/commentperiod/to"))&.text
        extended = ixml.at(ns("//bibdata/ext/commentperiod/extended"))&.text
        set(:comment_from, from) if from
        set(:comment_to, to) if to
      end

      def series(xml, _out)
        set(:series, xml.at(ns("//bibdata/series[@type = 'main']/title"))&.text)
        a = xml.at(ns("//bibdata/series[@type = 'main']/abbreviation"))&.text and
          set(:seriesabbr, a)
      end
    end
  end
end

require "isodoc"

module IsoDoc
  module IHO

    class Metadata < IsoDoc::Generic::Metadata
      def configuration
        Metanorma::IHO.configuration
      end

      def version(isoxml, _out)
        super
        revdate = get[:revdate]
        set(:revdate_MMMddyyyy, MMMddyyyy(revdate))
      end

      def MMMddyyyy(isodate)
        return nil if isodate.nil?
        arr = isodate.split("-")
        date = if arr.size == 1 and (/^\d+$/.match isodate)
                 Date.new(*arr.map(&:to_i)).strftime("%Y")
               elsif arr.size == 2
                 Date.new(*arr.map(&:to_i)).strftime("%B %Y")
               else
                 Date.parse(isodate).strftime("%B %d, %Y")
               end
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
      end
    end
  end
end

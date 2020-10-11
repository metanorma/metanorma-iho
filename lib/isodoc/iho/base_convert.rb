module IsoDoc
  module IHO
    module BaseConvert
      # terms not defined in standoc
      def error_parse(node, out)
        case node.name
        when "appendix" then clause_parse(node, out)
        else
          super
        end
      end

      def info(isoxml, out)
        @meta.series isoxml, out
        super
      end

      def std_bibitem_entry(list, b, ordinal, biblio)
        list.p **attr_code(iso_bibitem_entry_attrs(b, biblio)) do |ref|
          prefix_bracketed_ref(ref, "[#{ordinal}]")
          standard_citation(ref, b)
        end
      end

      def nodes_to_span(n)
        noko do |xml|
          xml.span do |s|
            n&.children&.each { |x| parse(x, s) }
          end
        end.join("")
      end

      def multiplenames_and(names)
        return "" if names.length == 0
        return names[0] if names.length == 1
        return "#{names[0]} and #{names[1]}" if names.length == 2
        names[0..-2].join(", ") + " and #{names[-1]}"
      end

      def extract_publisher(b)
        c = b.xpath(ns("./contributor[role/@type = 'publisher'][organization]"))
        abbrs = []
        names = []
        c&.each do |c1|
          n = c1.at(ns("./organization/name")) or next
          abbrs << (c1.at(ns("./organization/abbreviation")) || n)
          names << nodes_to_span(n)
        end
        return [nil, nil] if names.empty?
        return [multiplenames_and(names), (abbrs.map { |x| x.text }).join("/")]
      end

      def inline_bibitem_ref_code(b)
        id = b.at(ns("./docidentifier[not(@type = 'DOI' or @type = 'metanorma' "\
                     "or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]"))
        id ||= b.at(ns("./docidentifier[not(@type = 'metanorma')]"))
        return [nil, id, nil] if id
        id = Nokogiri::XML::Node.new("docidentifier", b.document)
        id << "(NO ID)"
        [nil, id, nil]
      end

      def extract_edition(b)
        b&.at(ns("./edition"))&.text
      end

      def extract_uri(b)
        b.at(ns("./uri"))
      end

      def omit_docid_prefix(prefix)
        return true if prefix == "IHO"
        super
      end

      def render_identifier(id)
        if !id[1].nil? and id[1]["type"] == "IHO"
          id[1].children = id[1].text.sub(/^IHO /, "")
        end
        super
      end

      def extract_publisher(b)
        c = b.xpath(ns("./contributor[role/@type = 'publisher'][organization]"))
        abbrs = []
        names = []
        c&.each do |c1|
          n = c1.at(ns("./organization/name")) or next
          abbrs << (c1.at(ns("./organization/abbreviation")) || n)
          names << nodes_to_span(n)
        end
        return [nil, nil] if names.empty?
        return [multiplenames_and(names), (abbrs.map { |x| x.text }).join("/")]
      end

      def extract_author(b)
        c = b.xpath(ns("./contributor[role/@type = 'author']"))
        c = b.xpath(ns("./contributor[role/@type = 'editor']")) if c.empty?
        return extract_publisher(b)[0] if c.empty?
        c.map do |c1|
          c1&.at(ns("./organization/name"))&.text || extract_person_name(c1)
        end.reject { |e| e.nil? || e.empty? }.join(", ")
      end

      def extract_person_name(b)
        p = b.at(ns("./person/name")) or return
        c = p.at(ns("./completename")) and return c.text
        s = p&.at(ns("./surname"))&.text or return
        i = p.xpath(ns("./initial")) and
          front = i.map { |e| e.text.gsub(/[^[:upper:]]/, "") }.join("")
        i.empty? and f = p.xpath(ns("./forename")) and
          front = f.map { |e| e.text[0].upcase }.join("")
        front ? "#{s} #{front}" : s
      end

      def is_iho?(b)
        extract_publisher(b)[1] == "IHO"
      end

      # [{number}] {docID} edition {edition}: {title}, {author/organization}
      def standard_citation(out, b)
        if ftitle = b.at(ns("./formattedref"))
          ftitle&.children&.each { |n| parse(n, out) }
        else
          id = render_identifier(inline_bibitem_ref_code(b))
          out << id[1] if id[1]
          ed = extract_edition(b) if is_iho?(b)
          out << " edition #{ed}" if ed
          out << ": " if id[1] || ed
          iso_title(b)&.children&.each { |n| parse(n, out) }
          out << ", "
          author = extract_author(b)
          out << author
          u = extract_uri(b)
          out << " (<a href='#{u.text}'>#{u.text}</a>)" if u
        end
      end
    end
  end
end

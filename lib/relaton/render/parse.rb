module Relaton
  module Render
    module IHO
      class Parse < ::Relaton::Render::Parse
        def standardidentifier(doc)
          out = doc.docidentifier.each_with_object([]) do |id, ret|
            ret << id.id unless standardidentifier_exclude1.include? id.type
          end
          return out unless out.empty?

          super
        end

        def standardidentifier_exclude1
          %w(metanorma metanorma-ordinal DOI ISSN ISBN rfc-anchor)
        end

        def uri(doc)
          uri = nil
          %w(src).each do |t|
            uri = doc.link.detect { |u| u.type == t } and break
          end
          uri ||= doc.link.first
          return nil unless uri

          uri.content.to_s
        end
      end
    end
  end
end

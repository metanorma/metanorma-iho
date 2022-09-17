module Relaton
  module Render
    module IHO
      class Parse < ::Relaton::Render::Parse
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

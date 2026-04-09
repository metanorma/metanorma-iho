module Relaton
  module Render
    module Iho
      class Parse < ::Relaton::Render::Parse
        def uri(doc)
          uri = nil
          %w(src).each do |t|
            uri = Array(doc.source).detect { |u| u.type == t } and break
          end
          uri ||= Array(doc.source).first
          return nil unless uri

          uri.content.to_s
        end
      end
    end
  end
end

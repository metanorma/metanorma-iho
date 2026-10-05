module Relaton
  module Render
    module Iho
      class Fields < ::Relaton::Render::Fields
        def edition_fields_format(hash)
          super
          hash[:publisher_raw]&.any? do |p|
            ["IHO", "International Hydrographic Organization"]
              .include?(p[:nonpersonal])
          end or hash[:edition] = nil
        end

        def misc_fields_format(hash)
          super
          hash[:authoritative_identifier].map! do |x|
            x.sub(/^IHO /, "")
          end
          hash
        end
      end
    end
  end
end

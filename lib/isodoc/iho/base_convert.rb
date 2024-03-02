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

      def bibrenderer(options = {})
      ::Relaton::Render::IHO::General.new(options.merge(language: @lang,
                                                          i18nhash: @i18n.get))
    end
    end
  end
end

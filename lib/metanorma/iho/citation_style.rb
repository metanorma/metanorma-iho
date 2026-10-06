require "relaton-render"

module Metanorma
  module Iho
    #
    # The IHO flavor's citation renderer: an extension of the
    # relaton-render General facade carrying this gem's CitationStyle
    # instance. Supersedes the 1.x stack this gem carried under
    # lib/relaton/render, which subclassed relaton-render 1.x internals
    # that the 3.0.0.pre engine no longer ships.
    #
    class CitationStyle < ::Relaton::Render::General
      STYLE_PATH = File.join(__dir__, "iho-style.yml")

      # The IHO data elements, scoped to this renderer alone: the raw
      # numeric edition, and the creator citing its affiliation
      ELEMENTS = { edition: IhoElements::IhoEdition,
                   creator: IhoElements::IhoCreator }.freeze

      def initialize(options = {})
        super
        options = deep_symbolize(options)
        @renderer = ::Relaton::Render::Iso690::Renderer.new(
          lang: @lang,
          script: options[:script] || "Latn",
          labels: options[:i18nhash] || {},
          style: options[:style] || STYLE_PATH,
          elements: ELEMENTS,
        )
      end
    end
  end
end

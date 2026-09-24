# frozen_string_literal: true

module Metanorma
  module Iho
    # HTML rendering for IHO documents.
    module Html
      autoload :Renderer, File.expand_path("html/renderer", __dir__)
    end
  end
end

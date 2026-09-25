# frozen_string_literal: true

# Forward-declare parent namespace so this file is safe to require
# directly (without first requiring metanorma/iho.rb).
module Metanorma
  module Iho
    autoload :Html, File.expand_path("html", __dir__)
  end
end


module Metanorma
  module Iho::Document
    autoload :Metadata, "metanorma/iho/document/metadata"
    autoload :Root, "metanorma/iho/document/root"
  end
end

# Backwards-compat alias so external consumers that reference
# Metanorma::IhoDocument keep resolving during the transition.
module Metanorma
  existing = defined?(Metanorma::IhoDocument) && Metanorma::IhoDocument
  if !existing.equal?(Metanorma::Iho::Document)
    Metanorma.send(:remove_const, :IhoDocument) if existing
    IhoDocument = Metanorma::Iho::Document
  end
end

if defined?(Metanorma::Registers::Setup.setup_iho_register)
  Metanorma::Registers::Setup.setup_iho_register
end

# OCP adoption: ONE registration in the metanorma-core flavor table —
# model root, processor, and pubid module. HTML rendering uses the
# flavor's renderer over the harness standard renderer.
require "metanorma-core"
require "metanorma/document"
Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :iho,
  gem: "metanorma-iho",
  model_root: Metanorma::Iho::Document::Root,
  processor: defined?(Metanorma::Iho::Processor) ? Metanorma::Iho::Processor : nil,
  pubid_module: :"Pubid::Iho",
  renderers: { html: Metanorma::Iho::Html::Renderer },
))

module Metanorma
  deprecate_constant :IhoDocument
end

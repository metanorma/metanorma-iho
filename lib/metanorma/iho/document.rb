# frozen_string_literal: true

require "metanorma/standoc"
require "metanorma/iso/document/models"
module Metanorma
  module Iho
  end
end

module Metanorma
  module Iho::Document
    autoload :Metadata, "metanorma/iho/document/metadata"
    autoload :Root, "metanorma/iho/document/root"
  end
end

module Metanorma
  existing = defined?(Metanorma::IhoDocument) && Metanorma::IhoDocument
  if !existing.equal?(Metanorma::Iho::Document)
    Metanorma.send(:remove_const, :IhoDocument) if existing
    IhoDocument = Metanorma::Iho::Document
  end
end

# OCP adoption: ONE registration in the metanorma-core flavor table
require "metanorma-core"

Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :iho,
  gem: "metanorma-iho",
  model_root: Metanorma::Iho::Document::Root,
  pubid_module: :"Pubid::Iho",
  renderers: { html: lambda do |_document, **_options|
    Metanorma::Html::StandardRenderer
  end },
))

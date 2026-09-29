# frozen_string_literal: true

require "bundler/setup"
require "rspec/matchers"
require "metanorma/iho/document"
require_relative "support/roundtrip_helper"
require_relative "support/shared_roundtrip_examples"

RSpec.describe "IHO document XML round-trip" do
  it_behaves_like "xml round-trip", flavor_dir: "iho",
                                    doc_class: Metanorma::Iho::Document::Root
end

# frozen_string_literal: true

require "bundler/setup"
require "rspec/matchers"
require "metanorma-iho"
require "asciidoctor"

RSpec.describe "IHO editorialgroup emission" do
  subject(:xml) do
    Metanorma::Registry.instance.register(Metanorma::Iho::Processor)
    Asciidoctor.convert(<<~"INPUT", backend: "iho", header_footer: true)
      = Document title
      :docnumber: 1234
      :committee: hssc
      :workgroup: ncwg
      :doctype: standard
      :language: en
      :script: Latn
      :copyright-year: 2026

      == Scope

      Text.
    INPUT
  end

  it "emits the editorial group into bibdata ext" do
    expect(xml).to include("<editorialgroup><committee>" \
                           "<abbreviation>HSSC</abbreviation></committee>" \
                           "<workgroup><abbreviation>NCWG</abbreviation>" \
                           "</workgroup></editorialgroup>")
  end

  it "emits additional groups from _2-suffixed attributes" do
    Metanorma::Registry.instance.register(Metanorma::Iho::Processor)
    xml2 = Asciidoctor.convert(<<~"INPUT", backend: "iho", header_footer: true)
      = Document title
      :docnumber: 1234
      :committee: hssc
      :workgroup: ncwg
      :committee_2: ircc
      :workgroup_2: ircc-wg
      :doctype: standard
      :language: en
      :script: Latn
      :copyright-year: 2026

      == Scope

      Text.
    INPUT
    expect(xml2.scan("<editorialgroup>").size).to eq(2)
    expect(xml2).to include("<abbreviation>IRCC</abbreviation>")
  end
end

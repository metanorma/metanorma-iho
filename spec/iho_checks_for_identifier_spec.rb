# frozen_string_literal: true

require "bundler/setup"
require "rspec/matchers"
require "metanorma-iho"
require "asciidoctor"

# S-158:1xx validation-check specifications carry the product number as
# a Pubid::Iho `checks_for` member ("S-158:102" is S-158 checks for
# S-102). The :checks-for: attribute routes the identifier through
# Pubid::Iho; documents without :checks-for: keep the generic path.
RSpec.describe "S-158:1xx checks-for identifier emission" do
  def compile(attrs)
    Metanorma::Registry.instance.register(Metanorma::Iho::Processor)
    Asciidoctor.convert(<<~"INPUT", backend: "iho", header_footer: true)
      = Bathymetric Surface Validation Checks
      #{attrs}

      == Scope

      Text.
    INPUT
  end

  let(:checks_for_attrs) do
    <<~ATTRS
      :docnumber: 158
      :checks-for: 102
      :doctype: specification
      :language: en
      :script: Latn
      :copyright-year: 2025
    ATTRS
  end

  it "emits the Pubid face as the primary docidentifier" do
    expect(compile(checks_for_attrs))
      .to include('<docidentifier primary="true" type="IHO">S-158:102' \
                  "</docidentifier>")
  end

  it "emits the IHO MRN URN as a docidentifier" do
    expect(compile(checks_for_attrs))
      .to include("<docidentifier type=\"URN\">" \
                  "urn:mrn:iho:pub:spec:s158-102</docidentifier>")
  end

  it "parses other S-158:1xx product numbers" do
    expect(compile(checks_for_attrs.sub(":checks-for: 102", ":checks-for: 101")))
      .to include("<docidentifier type=\"URN\">" \
                  "urn:mrn:iho:pub:spec:s158-101</docidentifier>")
  end

  it "keeps the generic docid_template path without :checks-for:" do
    xml = compile(<<~ATTRS)
      :docnumber: 158:102
      :doctype: specification
      :language: en
      :script: Latn
      :copyright-year: 2025
    ATTRS

    expect(xml).to include(">S-158:102</docidentifier>")
    expect(xml).not_to include("urn:mrn:iho:pub:spec")
  end
end

require "spec_helper"
require_relative "../support/taste_stub"

# Generic extension point: the :urn: document attribute propagates
# into bibdata as a typed uri, and stays absent when the attribute is
# absent (metanorma-iho#579).
RSpec.describe "Metanorma::Iho urn propagation", taste_stub: true do
  it "propagates the urn document attribute into bibdata " \
     "(metanorma-iho#579)" do
    xml = taste_compile(":urn: urn:x-iho:1000\n")
    expect(xml.at("//xmlns:bibdata/xmlns:uri[@type = 'urn']")&.text)
      .to eq("urn:x-iho:1000")
  end

  it "adds no uri element when the urn attribute is absent " \
     "(metanorma-iho#579)" do
    xml = taste_compile(":doctype: standard\n")
    expect(xml.at("//xmlns:bibdata/xmlns:uri")).to be_nil
  end
end

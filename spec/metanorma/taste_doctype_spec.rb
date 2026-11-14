require "spec_helper"
require_relative "../support/taste_stub"

# Generic extension point for a taste compiled on this flavour's base:
# the taste registers its own doctype vocabulary, and the legal
# doctype set unions it with the base's (metanorma-iho#578). The stub
# is a taste registering its own vocabulary; no specific taste is
# implicated.
RSpec.describe "Metanorma::Iho taste doctype vocabulary",
               taste_stub: true do
  it "keeps a doctype registered by a taste (metanorma-iho#578)" do
    xml = taste_compile(":doctype: guideline\n")
    expect(xml.at("//xmlns:bibdata/xmlns:ext/xmlns:doctype")&.text)
      .to eq("guideline")
  end

  it "keeps a base doctype legal alongside a taste vocabulary " \
     "(metanorma-iho#578)" do
    xml = taste_compile(":doctype: specification\n")
    expect(xml.at("//xmlns:bibdata/xmlns:ext/xmlns:doctype")&.text)
      .to eq("specification")
  end
end

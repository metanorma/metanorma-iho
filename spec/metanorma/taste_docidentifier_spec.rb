require "spec_helper"
require_relative "../support/taste_stub"

# Generic extension point for a taste compiled on this flavour's base:
# the structured docnumber/part is emitted onto whatever docidentifier
# the document actually carries, not onto a hardcoded type
# (metanorma-iho#577).
RSpec.describe "Metanorma::Iho taste docidentifier type",
               taste_stub: true do
  it "enhances the docidentifier the document actually carries, " \
     "not the hardcoded type (metanorma-iho#577)" do
    xml = taste_compile(<<~ATTRS)
      :partnumber: 2
      :publisher_abbr: TST
    ATTRS
    id = xml.at("//xmlns:bibdata/xmlns:docidentifier[@primary = 'true']")
    expect(id.text).to eq("TR-1000 Part 2")
    expect(id["type"]).to eq("TST")
    parent = id.at("./following-sibling::xmlns:docidentifier")
    expect(parent.text).to eq("TR-1000")
    expect(parent["type"]).to eq("TST-parent-document")
    expect(parent["primary"]).to be_nil
  end
end

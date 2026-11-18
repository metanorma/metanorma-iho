# frozen_string_literal: true

require "spec_helper"
require "metanorma/iho/html"

# The HTML cover identity strapline follows the document's publisher
# organization: "<abbr> Standard" — WMO for a WMO-published S-1XX
# product specification, IHO by default (the S-41X series).
RSpec.describe "publisher cover identity" do
  let(:xml) do
    <<~XML
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" flavor="iho">
        <bibdata type="standard">
          <title language="en" type="main">Test document</title>
          <docidentifier>S-409</docidentifier>
          <docnumber>409</docnumber>
          <language>en</language>
          <script>Latn</script>
          <status><stage>60</stage><substage>60</substage></status>
          <copyright><from>2026</from><owner><organization>
            <name>#{owner_name}</name>
            #{owner_abbr ? "<abbreviation>#{owner_abbr}</abbreviation>" : ""}
          </organization></owner></copyright>
          <contributor>
            <role type="publisher"/>
            <organization>
              <name>#{owner_name}</name>
              #{owner_abbr ? "<abbreviation>#{owner_abbr}</abbreviation>" : ""}
            </organization>
          </contributor>
        </bibdata>
        <sections>
          <clause id="c1"><title>Scope</title>
            <p id="p1">Test text.</p>
          </clause>
        </sections>
      </metanorma>
    XML
  end

  let(:i18n_obj) { IsoDoc::I18n.new("en", "Latn") }

  def cover_html
    pres = IsoDoc::Iho::PresentationXMLConvert.new({})
      .convert("test", xml, true)
    doc = Metanorma::Iho::Document::Root.from_xml(pres)
    Metanorma::Html::Generator.generate(doc)
  end

  context "with a non-IHO publisher (WMO)" do
    let(:owner_name) { "World Meteorological Organization" }
    let(:owner_abbr) { "WMO" }

    it "renders the publisher abbreviation in the modern-renderer strapline" do
      expect(cover_html).to include("WMO Standard")
      expect(cover_html).not_to include("IHO Standard")
    end
  end

  context "with no publisher organization" do
    let(:owner_name) { "International Hydrographic Organization" }
    let(:owner_abbr) { nil }

    it "defaults the modern-renderer strapline to IHO" do
      expect(cover_html).to include("IHO Standard")
      expect(cover_html).not_to include("WMO Standard")
    end
  end

  # The CLI html/doc lanes render the legacy isodoc titlepage, whose
  # identity comes from the org_name / org_abbrev labels; document
  # bibdata drives those labels (publisher_identity).
  describe "legacy titlepage lane" do
    let(:owner_name) { "World Meteorological Organization" }
    let(:owner_abbr) { "WMO" }

    it "drives the org_name / org_abbrev labels from bibdata" do
      pres = IsoDoc::Iho::PresentationXMLConvert.new({})
        .convert("test", xml, true)
      conv = IsoDoc::Iho::HtmlConvert.new({})
      conv.convert("test", pres, true)
      meta = conv.instance_variable_get(:@meta)

      expect(meta.labels["org_abbrev"]).to eq("WMO")
      expect(meta.labels["org_name"]).to eq("World Meteorological Organization")
    end

    it "keeps the IHO defaults when the document names no publisher" do
      xml2 = xml.sub(%r{<contributor>.*?</contributor>}m, "")
      pres2 = IsoDoc::Iho::PresentationXMLConvert.new({})
        .convert("test", xml2, true)
      conv = IsoDoc::Iho::HtmlConvert.new({})
      conv.convert("test", pres2, true)
      meta = conv.instance_variable_get(:@meta)

      expect(meta.labels["org_abbrev"]).to eq("IHO")
      expect(meta.labels["org_name"])
        .to eq("International Hydrographic Organization")
    end
  end
end

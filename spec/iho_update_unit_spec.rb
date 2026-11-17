# frozen_string_literal: true

require "bundler/setup"
require "rspec/matchers"
require "metanorma-iho"
require "asciidoctor"
require "nokogiri"

RSpec.describe "IHO section-level identifiers in Part bibdata" do
  def convert(header, body)
    Metanorma::Registry.instance.register(Metanorma::Iho::Processor)
    xml = Asciidoctor.convert(<<~INPUT, backend: "iho", header_footer: true)
      = S-4 Regulations
      :docnumber: 4
      :committee: hssc
      :workgroup: ncwg
      :doctype: standard
      :language: en
      :script: Latn
      :copyright-year: 2026
      #{header}

      #{body}
    INPUT
    Nokogiri::XML(xml).remove_namespaces!
  end

  def relation_ids(doc)
    doc.xpath("//bibdata/relation[@type = 'hasPart']").map do |r|
      [r.at("./bibitem/title").text,
       r.at("./bibitem/docidentifier[@type = 'IHO']").text,
       r.at("./bibitem/docidentifier[@type = 'URN']").text]
    end
  end

  let(:two_sections) do
    <<~BODY
      [update-unit=B-400]
      == Section 400

      Text.

      [update-unit=B-500]
      == Section 500

      Text.
    BODY
  end

  it "enumerates declared sections as hasPart relations" do
    doc = convert(":partnumber: B", two_sections)
    expect(relation_ids(doc)).to eq(
      [["Section 400", "IHO S-4 B-400", "urn:iho:s:4:part-B:spec-400"],
       ["Section 500", "IHO S-4 B-500", "urn:iho:s:4:part-B:spec-500"]],
    )
  end

  it "logs an error and omits a section whose part letter disagrees" do
    doc = nil
    expect do
      doc = convert(":partnumber: B", <<~BODY)
        [update-unit="IHO S-4 A-400"]
        == Section 400 of another part

        Text.

        [update-unit=B-500]
        == Section 500

        Text.
      BODY
    end.to output(/does not belong to Part B/).to_stderr
    expect(relation_ids(doc).map(&:first)).to eq(["Section 500"])
  end

  it "logs an error and omits an unparseable value" do
    doc = nil
    expect do
      doc = convert(":partnumber: B", <<~BODY)
        [update-unit=nonsense]
        == Section 400

        Text.
      BODY
    end.to output(/not a valid IHO S-4 section identifier/).to_stderr
    expect(relation_ids(doc)).to be_empty
  end

  it "emits nothing for a document without a part number" do
    doc = convert("", two_sections)
    expect(relation_ids(doc)).to be_empty
  end
end

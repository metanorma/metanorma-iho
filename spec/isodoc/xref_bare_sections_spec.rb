# frozen_string_literal: true

require "spec_helper"

RSpec.describe IsoDoc::Iho do
  # Resolution-style documents (IALA general-assembly resolutions and
  # their kin) transcribe their content as bare blocks directly under
  # <sections>, with no clause wrappers. The blocks must carry
  # displayorder, or the top-level render walk -- which presupposes it --
  # silently drops the entire document body from HTML, Word and PDF.
  it "orders bare blocks directly under sections in Presentation XML" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata><title language="en">Resolution A</title></bibdata>
      <preface/>
      <sections>
      <p id="p1">THE GENERAL ASSEMBLY,</p>
      <p id="p2">RECALLING Article 2 of the Constitution,</p>
      <p id="p3">DECIDES:</p>
      </sections>
      </iso-standard>
    INPUT
    pres_output = IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    doc = Nokogiri::XML(pres_output)
    orders = doc.xpath("//*[local-name() = 'sections']/*[@displayorder]")
      .map { |p| [p["id"], p["displayorder"].to_s.to_i] }
    expect(orders).to include(["p1", anything], ["p2", anything],
                              ["p3", anything])
  end

  it "renders bare blocks under sections in HTML output" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata><title language="en">Resolution A</title></bibdata>
      <preface/>
      <sections>
      <p id="p1">THE GENERAL ASSEMBLY,</p>
      <p id="p2">RECALLING Article 2 of the Constitution,</p>
      </sections>
      </iso-standard>
    INPUT
    pres_output = IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    html = Nokogiri::HTML5(IsoDoc::Iho::HtmlConvert.new({})
      .convert("test", pres_output, true)).at("//body")
    html.xpath("//script").each(&:remove)
    body = html.to_xhtml
    expect(body).to include("THE GENERAL ASSEMBLY,")
    expect(body).to include("RECALLING Article 2 of the Constitution,")
  end

  it "orders modelled sections before the bare blocks" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata><title language="en">Doc</title></bibdata>
      <preface/>
      <sections>
      <p id="p0">Preamble text.</p>
      <clause id="c1"><title>Scope</title><p id="p1">Text</p></clause>
      </sections>
      </iso-standard>
    INPUT
    pres_output = IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    doc = Nokogiri::XML(pres_output)
    top = doc.xpath("//*[local-name() = 'sections']/*[@displayorder]")
    clause = top.find { |x| x.name == "clause" }
    preamble = top.find { |x| x["id"] == "p0" }
    expect(clause).not_to be_nil
    expect(preamble).not_to be_nil
    # modelled sections keep their numbering precedence over the blocks
    expect(clause["displayorder"].to_s.to_i)
      .to be < preamble["displayorder"].to_s.to_i
  end
end

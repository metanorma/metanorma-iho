require "spec_helper"
require "metanorma"
require "fileutils"

RSpec.describe Metanorma::IHO::Processor do
  registry = Metanorma::Registry.instance
  registry.register(Metanorma::IHO::Processor)

  let(:processor) do
    registry.find_processor(:iho)
  end

  it "registers against metanorma" do
    expect(processor).not_to be nil
  end

  it "registers output formats against metanorma" do
    expect(processor.output_formats.sort.to_s).to be_equivalent_to <<~OUTPUT
      [[:doc, "doc"], [:html, "html"], [:pdf, "pdf"], [:presentation, "presentation.xml"], [:rxl, "rxl"], [:xml, "xml"]]
    OUTPUT
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::IHO })
  end

  it "generates IsoDoc XML from a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = Xml::C14n.format(strip_guid(<<~"OUTPUT"))
          #{BLANK_HDR}
      <sections/>
      </iho-standard>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(processor
      .input_to_isodoc(input, nil))))
      .to be_equivalent_to output
  end

  it "generates HTML from IsoDoc XML" do
    FileUtils.rm_f "test.xml"
    input = <<~INPUT
      <iho-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <terms id="H" obligation="normative" displayorder="1">
            <title>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <term id="J">
            <name>1.1.</name>
              <preferred>Term2</preferred>
            </term>
          </terms>
        </sections>
      </iho-standard>
    INPUT

    output = Xml::C14n.format(strip_guid(<<~OUTPUT))
       <main class="main-section">
         <button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
         <div id="H">
           <h1 id="_">
             <a class="anchor" href="#H"/>
             <a class="header" href="#H">1.  Terms, Definitions, Symbols and Abbreviated Terms</a>
           </h1>
           <p class="Terms" style="text-align:left;" id="J">
             <strong>1.1.</strong>
              Term2
           </p>
         </div>
       </main>
    OUTPUT

    processor.output(input, "test.xml", "test.html", :html)

    expect(
      Xml::C14n.format(strip_guid(File.read("test.html", encoding: "utf-8")
      .gsub(%r{^.*<main}m, "<main")
      .gsub(%r{</main>.*}m, "</main>"))),
    ).to be_equivalent_to output
  end
end

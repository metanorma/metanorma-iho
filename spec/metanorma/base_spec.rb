require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::IHO do
  it "has a version number" do
    expect(Metanorma::IHO::VERSION).not_to be nil
  end

  it "processes a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = xmlpp(<<~"OUTPUT")
          #{BLANK_HDR}
      <sections/>
      </iho-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho,
                                                       header_footer: true))))
      .to be_equivalent_to output
  end

  it "converts a blank document" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    output = xmlpp(<<~"OUTPUT")
          #{BLANK_HDR}
      <sections/>
      </iho-standard>
    OUTPUT

    FileUtils.rm_f "test.html"
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.pdf"
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho,
                                                       header_footer: true))))
      .to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
    expect(File.exist?("test.doc")).to be true
    expect(File.exist?("test.pdf")).to be true
  end

  it "processes default metadata" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee: hssc
      :workgroup: WG1
      :committee_2: ircc
      :workgroup_2: WG2
      :committee_3: hssc
      :workgroup_3: WG3
      :copyright-year: 2001
      :status: working-draft
      :language: en
      :title: Main Title
      :security: Client Confidential
      :recipient: tbd@example.com
      :implemented-date: 2000-01-01
      :obsoleted-date: 2001-01-01
      :comment-from: 2010-01-01
      :comment-to: 2011-01-01
      :series: B

    INPUT

    output = xmlpp(<<~"OUTPUT")
          <?xml version="1.0" encoding="UTF-8"?>
      <iho-standard xmlns="https://www.metanorma.org/ns/iho" type="semantic" version="#{Metanorma::IHO::VERSION}">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
      <docidentifier type="IHO">B-1000</docidentifier>
      <docnumber>1000</docnumber>
       <date type='implemented'>
         <on>2000-01-01</on>
       </date>
       <date type='obsoleted'>
         <on>2001-01-01</on>
       </date>
        <contributor>
          <role type="author"/>
          <organization>
            <name>International Hydrographic Organization</name>
            <abbreviation>IHO</abbreviation>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Hydrographic Organization</name>
            <abbreviation>IHO</abbreviation>
          </organization>
        </contributor>
        <edition>2</edition>
      <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>working-draft</stage>
        </status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
              <name>International Hydrographic Organization</name>
              <abbreviation>IHO</abbreviation>
            </organization>
          </owner>
        </copyright>
        <series type='main'>
        <title>Bathymetric</title>
        <abbreviation>B</abbreviation>
      </series>
        <ext>
        <doctype>standard</doctype>
        <editorialgroup>
                     <committee>
                       <abbreviation>HSSC</abbreviation>
                     </committee>
                     <workgroup>
                       <abbreviation>WG1</abbreviation>
                     </workgroup>
                   </editorialgroup>
                   <editorialgroup>
                     <committee>
                       <abbreviation>IRCC</abbreviation>
                     </committee>
                     <workgroup>
                       <abbreviation>WG2</abbreviation>
                     </workgroup>
                   </editorialgroup>
                   <editorialgroup>
                     <committee>
                       <abbreviation>HSSC</abbreviation>
                     </committee>
                     <workgroup>
                       <abbreviation>WG3</abbreviation>
                     </workgroup>
                   </editorialgroup>
                   <commentperiod>
        <from>2010-01-01</from>
        <to>2011-01-01</to>
      </commentperiod>
        </ext>
      </bibdata>
                         <metanorma-extension>
           <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>PDF TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
         </metanorma-extension>
          #{BOILERPLATE.sub(/International Hydrographic Organization #{Date.today.year}/, 'International Hydrographic Organization 2001')}
      <sections/>
      </iho-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor
      .convert(input, backend: :iho, header_footer: true))))
      .to be_equivalent_to output
  end

  it "processes committee-draft" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :status: committee-draft
      :iteration: 3
      :language: en
      :title: Main Title
    INPUT
    output = <<~OUTPUT
              <iho-standard xmlns="https://www.metanorma.org/ns/iho" type="semantic" version="#{Metanorma::IHO::VERSION}">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier type="IHO">S-1000</docidentifier>
        <docnumber>1000</docnumber>
        <contributor>
          <role type="author"/>
          <organization>
            <name>International Hydrographic Organization</name>
            <abbreviation>IHO</abbreviation>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Hydrographic Organization</name>
            <abbreviation>IHO</abbreviation>
          </organization>
        </contributor>
        <edition>2</edition>
      <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>committee-draft</stage>
          <iteration>3</iteration>
        </status>
        <copyright>
          <from>#{Date.today.year}</from>
          <owner>
            <organization>
              <name>International Hydrographic Organization</name>
              <abbreviation>IHO</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>standard</doctype>
        </ext>
      </bibdata>
                         <metanorma-extension>
           <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>PDF TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
         </metanorma-extension>
              #{BOILERPLATE}
      <sections/>
      </iho-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor
      .convert(input, backend: :iho, header_footer: true))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes edition components" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :edition: 2
      :edition-major: 3
    INPUT
    xml = Nokogiri::XML(Asciidoctor
      .convert(input, backend: :iho, header_footer: true))
    expect(xml.at("//xmlns:edition").text)
      .to be_equivalent_to "3"

    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :edition: 2
      :edition-minor: 3
    INPUT
    output <<~OUTPUT
      <iho-standard xmlns="https://www.metanorma.org/ns/iho" type="semantic" version="#{Metanorma::IHO::VERSION}">
      </iso-standard>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor
      .convert(input, backend: :iho, header_footer: true))
    expect(xml.at("//xmlns:edition").text)
      .to be_equivalent_to "2"

    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :edition-major: 3
      :edition-minor: 4
      :edition-patch: 5
    INPUT
    output <<~OUTPUT
      <iho-standard xmlns="https://www.metanorma.org/ns/iho" type="semantic" version="#{Metanorma::IHO::VERSION}">
      </iso-standard>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor
      .convert(input, backend: :iho, header_footer: true))
    expect(xml.at("//xmlns:edition").text)
      .to be_equivalent_to "3.4.5"

    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :edition-major: 3
      :edition-patch: 5
    INPUT
    output <<~OUTPUT
      <iho-standard xmlns="https://www.metanorma.org/ns/iho" type="semantic" version="#{Metanorma::IHO::VERSION}">
      </iso-standard>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor
      .convert(input, backend: :iho, header_footer: true))
    expect(xml.at("//xmlns:edition").text)
      .to be_equivalent_to "3"
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = xmlpp(<<~"OUTPUT")
      #{BLANK_HDR}
               <preface><foreword id="_" obligation="informative">
           <title>Foreword</title>
           <p id="_">This is a preamble</p>
         </foreword></preface><sections>
         <clause id="_" obligation="normative">
           <title>Section 1</title>
         </clause></sections>
         </iho-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho,
                                                       header_footer: true)))).to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :iho, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Fira Code"]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: -apple-system, BlinkMacSystemFont, "Segoe UI"]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: -apple-system, BlinkMacSystemFont, "Segoe UI"]m)
  end

  it "uses specified fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
      :no-pdf:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :iho, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Comic Sans;]m)
  end

  it "processes appendixes" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [appendix]
      == Annex

      === Annex A.1

      [%appendix]
      === Appendix 1

    INPUT

    output = xmlpp(<<~"OUTPUT")
          #{BLANK_HDR}
      <sections> </sections>
      <annex id='_' obligation='normative'>
        <title>Annex</title>
        <clause id='_' obligation='normative'>
          <title>Annex A.1</title>
        </clause>
        <appendix id='_' obligation='normative'>
          <title>Appendix 1</title>
        </appendix>
      </annex>
      </iho-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho,
                                                       header_footer: true)))).to be_equivalent_to output
  end
end

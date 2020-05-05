require "spec_helper"
require "fileutils"

RSpec.describe Asciidoctor::IHO do
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

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho, header_footer: true)))).to be_equivalent_to output
  end

  it "converts a blank document" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</iho-standard>
    OUTPUT

    FileUtils.rm_f "test.html"
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho, header_footer: true)))).to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
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
      :iteration: 3
      :language: en
      :title: Main Title
      :security: Client Confidential
      :recipient: tbd@example.com
      :implemented-date: 2000-01-01
      :obsoleted-date: 2001-01-01
      :comment-from: 2010-01-01
      :comment-to: 2011-01-01
      :series: iho-bathymetric
      
    INPUT

    output = xmlpp(<<~"OUTPUT")
    <?xml version="1.0" encoding="UTF-8"?>
<iho-standard xmlns="https://www.metanorma.org/ns/iho">
<bibdata type="standard">
  <title language="en" format="text/plain">Main Title</title>
<docidentifier>1000</docidentifier>
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
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Hydrographic Organization</name>
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
      </organization>
    </owner>
  </copyright>
  <series type='main'>
  <title>iho-bathymetric</title>
</series>
  <ext>
  <doctype>standard</doctype>
  <editorialgroup>
               <committee>hssc</committee>
               <workgroup>WG1</workgroup>
             </editorialgroup>
             <editorialgroup>
               <committee>ircc</committee>
               <workgroup>WG2</workgroup>
             </editorialgroup>
             <editorialgroup>
               <committee>hssc</committee>
               <workgroup>WG3</workgroup>
             </editorialgroup>
             <commentperiod>
  <from>2010-01-01</from>
  <to>2011-01-01</to>
</commentperiod>
  </ext>
</bibdata>
        #{BOILERPLATE.sub(/<legal-statement/, "#{LICENSE_BOILERPLATE}\n<legal-statement").sub(/Ribose Group Inc\. #{Time.new.year}/, "Ribose Group Inc. 2001")}
<sections/>
</iho-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho, header_footer: true)))).to be_equivalent_to output
  end

    it "processes committee-draft" do
    expect(xmlpp(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :iho, header_footer: true)))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
        <iho-standard xmlns="https://www.metanorma.org/ns/iho">
<bibdata type="standard">
  <title language="en" format="text/plain">Main Title</title>
  <docidentifier>1000</docidentifier>
  <docnumber>1000</docnumber>
  <contributor>
    <role type="author"/>
    <organization>
      <name>International Hydrographic Organization</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Hydrographic Organization</name>
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
  </status>
  <copyright>
    <from>#{Date.today.year}</from>
    <owner>
      <organization>
        <name>International Hydrographic Organization</name>
      </organization>
    </owner>
  </copyright>
  <ext>
  <doctype>standard</doctype>
  </ext>
</bibdata>
        #{BOILERPLATE.sub(/<legal-statement/, "#{LICENSE_BOILERPLATE}\n<legal-statement")}
<sections/>
</iho-standard>
        OUTPUT
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

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho, header_footer: true)))).to be_equivalent_to output
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
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Source Code Pro", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "Source Sans Pro", sans-serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "Source Sans Pro", sans-serif;]m)
  end

  it "uses Chinese fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :no-pdf:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :iho, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Source Code Pro", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "SimHei", sans-serif;]m)
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

  it "processes inline_quoted formatting" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      _emphasis_
      *strong*
      `monospace`
      "double quote"
      'single quote'
      super^script^
      sub~script~
      stem:[a_90]
      stem:[<mml:math><mml:msub xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">F</mml:mi> </mml:mrow> </mml:mrow> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">&#x391;</mml:mi> </mml:mrow> </mml:mrow> </mml:msub> </mml:math>]
      [keyword]#keyword#
      [strike]#strike#
      [smallcap]#smallcap#
    INPUT

    output = xmlpp(<<~"OUTPUT")
            #{BLANK_HDR}
       <sections>
        <p id="_"><em>emphasis</em>
       <strong>strong</strong>
       <tt>monospace</tt>
       “double quote”
       ‘single quote’
       super<sup>script</sup>
       sub<sub>script</sub>
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub><mi>a</mi><mn>90</mn></msub></math></stem>
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub> <mrow> <mrow> <mi mathvariant="bold-italic">F</mi> </mrow> </mrow> <mrow> <mrow> <mi mathvariant="bold-italic">Α</mi> </mrow> </mrow> </msub> </math></stem>
       <keyword>keyword</keyword>
       <strike>strike</strike>
       <smallcap>smallcap</smallcap></p>
       </sections>
       </iho-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho, header_footer: true)))).to be_equivalent_to output
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

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho, header_footer: true)))).to be_equivalent_to output

    end

end

require "spec_helper"
require "fileutils"

OPTIONS = [backend: :iho, header_footer: true].freeze

RSpec.describe Metanorma::Iho do
  it "has a version number" do
    expect(Metanorma::Iho::VERSION).not_to be nil
  end

  it "processes a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
          #{BLANK_HDR}
      <sections/>
      </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "converts a blank document" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
          #{BLANK_HDR}
      <sections/>
      </metanorma>
    OUTPUT

    FileUtils.rm_f "test.html"
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.pdf"
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
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

    output = Xml::C14n.format(<<~"OUTPUT")
          <?xml version="1.0" encoding="UTF-8"?>
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Iho::VERSION}" flavor="iho">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
      <docidentifier primary="true" type="IHO">B-1000</docidentifier>
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
        <flavor>iho</flavor>
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
      </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor
      .convert(input, *OPTIONS))))
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
              <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Iho::VERSION}" flavor="iho">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier primary="true" type="IHO">S-1000</docidentifier>
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
        <flavor>iho</flavor>
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
      </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor
      .convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
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
      .convert(input, *OPTIONS))
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
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Iho::VERSION}" flavor="iho">
      </iso-standard>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor
      .convert(input, *OPTIONS))
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
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Iho::VERSION}">
      </iso-standard>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor
      .convert(input, *OPTIONS))
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
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Iho::VERSION}" flavor="iho">
      </iso-standard>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor
      .convert(input, *OPTIONS))
    expect(xml.at("//xmlns:edition").text)
      .to be_equivalent_to "3"
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{BLANK_HDR}
               <preface><foreword id="_" obligation="informative">
           <title>Foreword</title>
           <p id="_">This is a preamble</p>
         </foreword></preface><sections>
         <clause id="_" obligation="normative">
           <title>Section 1</title>
         </clause></sections>
         </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
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
    Asciidoctor.convert(input, *OPTIONS)

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
    Asciidoctor.convert(input, *OPTIONS)

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

    output = Xml::C14n.format(<<~"OUTPUT")
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
      </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes errata in misc-container" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [.preface]
      == misc-container

      === document history

      [source,yaml]
      ----
      - date:
        - type: published
          value:  2012-04
        edition: 1.0.0
        contributor:
        - organization:
            name: International Hydrographic Organization
            subdivision: Transfer Standard Maintenance and Application Development
            abbreviation: TSMAD
        amend:
          - description: Approved edition of S-102
      - date:
        - type: published
          value:  2017-03
        edition: 2.0.0
        contributor:
        - organization:
            name: International Hydrographic Organization
            subdivision: S-102 Project Team
            abbreviation: S-102PT
        amend:
          description: >
            Updated clause 4.0 and 12.0.

            Populated clause 9.0 and Annex B.
          location:
            - clause=4.0
            - clause=12.0
            - clause=9.0
            - annex=B
      - date:
        - type: updated
          value:  2017-05
        edition: 2.0.0
        contributor:
        - organization:
            name: International Hydrographic Organization
            subdivision: S-102 Project Team
            abbreviation: S-102PT
        amend:
          description: >
            Modified clause 9.0 based on feedback at S-100WG2 meeting.
          location:
            - clause=9.0
      - date:
        - type: updated
          value:  2018-02
        edition: 2.0.0
        contributor:
        - organization:
            name: International Hydrographic Organization
            subdivision: S-102 Project Team
            abbreviation: S-102PT
        amend:
          description: >
            Modified clause 9.0. Deleted contents of Annex B in preparation for updated S-100 Part 10C guidance. Added Annex F: S-102 Dataset Size and Production, Annex G: Gridding Example, Annex H: Statement added for Multi-Resolution Gridding, Annex I: Statement for future S-102 Tiling.
          location:
            - clause=9.0
            - annex=B
            - annex=F
            - annex=G
            - annex=H
            - annex=I
      - date:
        - type: updated
          value:  2018-06
        edition: 2.0.0
        contributor:
        - organization:
            name: International Hydrographic Organization
            subdivision: S-102 Project Team
            abbreviation: S-102PT
        amend:
          description: |
            Modifications to align with S-100 v4.0.0, S-100 Part 10c development, and actions from 4th April S-102 Project Team Meeting.

            Modified content throughout the following sections:

            * Clause 1, 3, 4, 5, 6, 9, 10, 11, and 12.
            * Annexes A, B, D, F, G, and I.
          location:
            - clause=1
            - clause=3
            - clause=4
            - clause=5
            - clause=6
            - clause=9
            - clause=10
            - clause=11
            - clause=12
            - annex=A
            - annex=B
            - annex=D
            - annex=F
            - annex=G
            - annex=I
      ----
    INPUT
    output = Xml::C14n.format(<<~"OUTPUT")
      <bibdata type="standard">
        <title language="en" format="text/plain">Document title</title>
        <docidentifier primary="true" type="IHO">S-</docidentifier>
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
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>in-force</stage>
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
        <relation type="updatedBy">
          <bibitem>
            <docidentifier type="IHO">S-</docidentifier>
            <date type="published">
              <on>2012-04</on>
            </date>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>International Hydrographic Organization</name>
                <subdivision>Transfer Standard Maintenance and Application Development</subdivision>
                <abbreviation>TSMAD</abbreviation>
              </organization>
            </contributor>
            <edition>1.0.0</edition>
            <amend change="modify">
              <description>
                <p id="_">Approved edition of S-102</p>
              </description>
            </amend>
          </bibitem>
        </relation>
        <relation type="updatedBy">
          <bibitem>
            <docidentifier type="IHO">S-</docidentifier>
            <date type="published">
              <on>2017-03</on>
            </date>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>International Hydrographic Organization</name>
                <subdivision>S-102 Project Team</subdivision>
                <abbreviation>S-102PT</abbreviation>
              </organization>
            </contributor>
            <edition>2.0.0</edition>
            <amend change="modify">
              <description>
                <p id="_">Updated clause 4.0 and 12.0.
      Populated clause 9.0 and Annex B.</p>
              </description>
              <location>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>4.0</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>12.0</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>9.0</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>B</referenceFrom>
                  </locality>
                </localityStack>
              </location>
            </amend>
          </bibitem>
        </relation>
        <relation type="updatedBy">
          <bibitem>
            <docidentifier type="IHO">S-</docidentifier>
            <date type="updated">
              <on>2017-05</on>
            </date>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>International Hydrographic Organization</name>
                <subdivision>S-102 Project Team</subdivision>
                <abbreviation>S-102PT</abbreviation>
              </organization>
            </contributor>
            <edition>2.0.0</edition>
            <amend change="modify">
              <description>
                <p id="_">Modified clause 9.0 based on feedback at S-100WG2 meeting.</p>
              </description>
              <location>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>9.0</referenceFrom>
                  </locality>
                </localityStack>
              </location>
            </amend>
          </bibitem>
        </relation>
        <relation type="updatedBy">
          <bibitem>
            <docidentifier type="IHO">S-</docidentifier>
            <date type="updated">
              <on>2018-02</on>
            </date>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>International Hydrographic Organization</name>
                <subdivision>S-102 Project Team</subdivision>
                <abbreviation>S-102PT</abbreviation>
              </organization>
            </contributor>
            <edition>2.0.0</edition>
            <amend change="modify">
              <description>
                <p id="_">Modified clause 9.0. Deleted contents of Annex B in preparation for updated S-100 Part 10C guidance. Added Annex F: S-102 Dataset Size and Production, Annex G: Gridding Example, Annex H: Statement added for Multi-Resolution Gridding, Annex I: Statement for future S-102 Tiling.</p>
              </description>
              <location>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>9.0</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>B</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>F</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>G</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>H</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>I</referenceFrom>
                  </locality>
                </localityStack>
              </location>
            </amend>
          </bibitem>
        </relation>
        <relation type="updatedBy">
          <bibitem>
            <docidentifier type="IHO">S-</docidentifier>
            <date type="updated">
              <on>2018-06</on>
            </date>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>International Hydrographic Organization</name>
                <subdivision>S-102 Project Team</subdivision>
                <abbreviation>S-102PT</abbreviation>
              </organization>
            </contributor>
            <edition>2.0.0</edition>
            <amend change="modify">
              <description>
                <p id="_">Modifications to align with S-100 v4.0.0, S-100 Part 10c development, and actions from 4th April S-102 Project Team Meeting.</p>
                <p id="_">Modified content throughout the following sections:</p>
                <ul id="_">
                  <li>
                    <p id="_">Clause 1, 3, 4, 5, 6, 9, 10, 11, and 12.</p>
                  </li>
                  <li>
                    <p id="_">Annexes A, B, D, F, G, and I.</p>
                  </li>
                </ul>
              </description>
              <location>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>1</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>3</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>4</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>5</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>6</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>9</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>10</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>11</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="clause">
                    <referenceFrom>12</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>A</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>B</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>D</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>F</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>G</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack>
                  <locality type="annex">
                    <referenceFrom>I</referenceFrom>
                  </locality>
                </localityStack>
              </location>
            </amend>
          </bibitem>
        </relation>
        <ext>
          <doctype>standard</doctype>
        <flavor>iho</flavor>
        </ext>
      </bibdata>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml = xml.at("//xmlns:bibdata")
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to output
  end
end

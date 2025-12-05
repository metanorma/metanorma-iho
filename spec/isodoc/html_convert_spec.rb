require "spec_helper"

RSpec.describe IsoDoc::Iho do
  it "processes default metadata" do
    csdc = IsoDoc::Iho::HtmlConvert.new({})
    input = <<~"INPUT"
      <iho-standard xmlns="https://open.ribose.com/standards/iho">
      <bibdata type="standard">
        <title type="main" language="en" format="plain">Main Title, Part 1: Part</title>
        <title type="title-main" language="en" format="plain">Main Title</title>
        <title type="title-part" language="en" format="plain">Part Title</title>
        <title type="title-appendix" language="en" format="plain">Appendix Title</title>
        <title type="title-annex" language="en" format="plain">Annex Title</title>
        <title type="title-supplement" language="en" format="plain">Supplement Title</title>
        <docidentifier>1000(wd)</docidentifier>
        <docnumber>1000</docnumber>
        <edition>2</edition>
        <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
       <date type='implemented'>
         <on>2000-01-01</on>
       </date>
       <date type='obsoleted'>
         <on>2001-01-01</on>
       </date>
        <contributor>
          <role type="author"/>
          <organization>
            <name>Ribose</name>
          </organization>
        </contributor>
      <contributor>
         <role type="author">
            <description>committee</description>
         </role>
         <organization>
            <name>International Hydrographic Organization</name>
            <subdivision type="Committee">
               <name>hssc</name>
            </subdivision>
            <subdivision type="Workgroup">
               <name>WG1</name>
            </subdivision>
         </organization>
      </contributor>
      <contributor>
         <role type="author">
            <description>committee</description>
         </role>
         <organization>
            <name>International Hydrographic Organization</name>
            <subdivision type="Committee">
               <name>ircc</name>
            </subdivision>
            <subdivision type="Workgroup">
               <name>WG2</name>
            </subdivision>
         </organization>
      </contributor>
      <contributor>
         <role type="author">
            <description>committee</description>
         </role>
         <organization>
            <name>International Hydrographic Organization</name>
            <subdivision type="Committee">
               <name>hssc</name>
            </subdivision>
            <subdivision type="Workgroup">
               <name>WG3</name>
            </subdivision>
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
        <status><stage>working-draft</stage></status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
              <name>Ribose</name>
            </organization>
          </owner>
        </copyright>
        <series type="main">
        <title>Bathymetric</title>
        <abbreviation>B</abbreviation>
        </series>
        <ext>
        <doctype>standard</doctype>
        <editorialgroup>
          <committee type="A">TC</committee>
        </editorialgroup>
        <security>Client Confidential</security>
        <commentperiod>
        <from>2010</from>
        <to>2011</to>
        </commentperiod>
        </ext>
      </bibdata>
      <metanorma-extension>
      <semantic-metadata>
      <stage-published>false</stage-published>
      </semantic-metadata>
      </metanorma-extension>
      <sections/>
      </iho-standard>
    INPUT

    output =
      { accesseddate: "XXX",
        adapteddate: "XXX",
        agency: "IHO",
        annextitle: "Annex Title",
        announceddate: "XXX",
        appendixtitle: "Appendix Title",
        circulateddate: "XXX",
        confirmeddate: "XXX",
        copieddate: "XXX",
        correcteddate: "XXX",
        createddate: "XXX",
        docnumber: "1000(wd)",
        docnumeric: "1000",
        doctitle: "Main Title, Part 1: Part",
        doctype: "Standard",
        doctype_display: "Standard",
        docyear: "2001",
        draft: "3.4",
        draftinfo: " (draft 3.4, 2000-01-01)",
        edition: "2",
        edition_display: "second edition",
        implementeddate: "2000-01-01",
        issueddate: "XXX",
        lang: "en",
        maintitle: "Main Title",
        metadata_extensions: { "doctype" => "standard",
                               "editorialgroup" => { "committee_type" => "A",
                                                     "committee" => "TC" },
                               "security" => "Client Confidential",
                               "commentperiod" => {
                                 "from" => "2010", "to" => "2011"
                               } },
        obsoleteddate: "2001-01-01",
        parttitle: "Part Title",
        publisheddate: "XXX",
        publisher: "International Hydrographic Organization",
        receiveddate: "XXX",
        revdate: "2000-01-01",
        revdate_monthyear: "January 2000",
        script: "Latn",
        series: "Bathymetric",
        seriesabbr: "B",
        stable_untildate: "XXX",
        stage: "Working Draft",
        stage_display: "Working Draft",
        supplementtitle: "Supplement Title",
        tc: "hssc",
        transmitteddate: "XXX",
        unchangeddate: "XXX",
        unpublished: true,
        updateddate: "XXX",
        vote_endeddate: "XXX",
        vote_starteddate: "XXX" }

    a_eacute = <<~XML.strip
      <path d="M369.13,332.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81,1.33.89,2.42,2.13,3.26,3.74.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM392.44,344.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15ZM378.53,321.46l7.77-10.43h5.77l-9.77,10.43h-3.77Z" style="fill:#00154c;"/>
    XML

    presxml = IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    docxml, _filename, _dir = csdc.convert_init(presxml, "test", true)
    result = metadata(csdc.info(docxml, nil))
    expect(result[:logo]).to match(/<svg/m)
    expect(result[:logo_mark]).to match(/<svg/m)
    expect(result[:logo_desc]).to match(/<svg/m)
    # á in Hidrográfica
    expect(result[:logo_desc]).not_to include a_eacute
    expect(result[:logo_sign]).to match(/<svg/m)
    expect(result.except(:logo, :logo_mark, :logo_desc, :logo_sign))
      .to be_equivalent_to(output.except(:logo, :logo_mark,
                                         :logo_desc, :logo_sign))

    presxml = IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input.sub("<language>en</language>",
                                 "<language>es</language>"), true)
    docxml, _filename, _dir = csdc.convert_init(presxml, "test", true)
    result = metadata(csdc.info(docxml, nil))
    expect(result[:logo_desc]).to include a_eacute
  end

  it "injects JS into blank html" do
    system "rm -f test.html"
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    output = Canon.format_xml(<<~"OUTPUT")
          #{BLANK_HDR}
      <sections/>
      </iho-standard>
    OUTPUT

    expect(Canon.format_xml(strip_guid(Asciidoctor
      .convert(input, backend: :iho, header_footer: true))))
      .to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
  end

  it "processes unordered lists" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
          <clause type="toc" id="_" displayorder="1"> <fmt-title id="_" depth="1">Table of contents</fmt-title> </clause>
          <foreword displayorder="2" id="fwd"><fmt-title id="_">Foreword</fmt-title>
          <ul id="_61961034-0fb1-436b-b281-828857a59ddb"  keep-with-next="true" keep-lines-together="true">
          <name>Caption</name>
        <li>
          <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a2">Level 1</p>
        </li>
        <li>
          <p id="_60eb765c-1f6c-418a-8016-29efa06bf4f9">deletion of 4.3.</p>
          <ul id="_61961034-0fb1-436b-b281-828857a59ddc"  keep-with-next="true" keep-lines-together="true">
          <li>
          <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a3">Level 2</p>
          <ul id="_61961034-0fb1-436b-b281-828857a59ddc"  keep-with-next="true" keep-lines-together="true">
          <li>
          <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a3">Level 3</p>
          <ul id="_61961034-0fb1-436b-b281-828857a59ddc"  keep-with-next="true" keep-lines-together="true">
          <li>
          <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a3">Level 4</p>
        </li>
        </ul>
        </li>
        </ul>
        </li>
          </ul>
        </li>
      </ul>
      </foreword></preface>
      </iso-standard>
    INPUT
    presxml = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <preface>
            <foreword displayorder="1" id="fwd">
               <title id="_">Foreword</title>
               <fmt-title id="_" depth="1">Foreword</fmt-title>
               <ul id="_" keep-with-next="true" keep-lines-together="true">
                  <name id="_">Caption</name>
                  <fmt-name id="_">
                     <semx element="name" source="_">Caption</semx>
                  </fmt-name>
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">•</semx>
                     </fmt-name>
                     <p id="_">Level 1</p>
                  </li>
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">•</semx>
                     </fmt-name>
                     <p id="_">deletion of 4.3.</p>
                     <ul id="_" keep-with-next="true" keep-lines-together="true">
                        <li id="_">
                           <fmt-name id="_">
                              <semx element="autonum" source="_">—</semx>
                           </fmt-name>
                           <p id="_">Level 2</p>
                           <ul id="_" keep-with-next="true" keep-lines-together="true">
                              <li id="_">
                                 <fmt-name id="_">
                                    <semx element="autonum" source="_">o</semx>
                                 </fmt-name>
                                 <p id="_">Level 3</p>
                                 <ul id="_" keep-with-next="true" keep-lines-together="true">
                                    <li id="_">
                                       <fmt-name id="_">
                                          <semx element="autonum" source="_">•</semx>
                                       </fmt-name>
                                       <p id="_">Level 4</p>
                                    </li>
                                 </ul>
                              </li>
                           </ul>
                        </li>
                     </ul>
                  </li>
               </ul>
            </foreword>
            <clause type="toc" id="_" displayorder="2">
               <fmt-title id="_" depth="1">Table of contents</fmt-title>
            </clause>
         </preface>
      </iso-standard>
    INPUT
    expect(Canon.format_xml(strip_guid(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<i18nyaml>.*</i18nyaml>}m, ""))))
      .to be_equivalent_to Canon.format_xml(presxml)
  end

  it "processes ordered lists" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
          <foreword id="_" displayorder="2">
          <ol id="_ae34a226-aab4-496d-987b-1aa7b6314026" type="alphabet"  keep-with-next="true" keep-lines-together="true">
          <name>Caption</name>
        <li>
          <p id="_0091a277-fb0e-424a-aea8-f0001303fe78">Level 1</p>
          </li>
          </ol>
        <ol id="A">
        <li>
          <p id="_0091a277-fb0e-424a-aea8-f0001303fe78">Level 1</p>
          </li>
        <li>
          <p id="_8a7b6299-db05-4ff8-9de7-ff019b9017b2">Level 1</p>
        <ol>
        <li>
          <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">Level 2</p>
        <ol>
        <li>
          <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">Level 3</p>
        <ol>
        <li>
          <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">Level 4</p>
        </li>
        </ol>
        </li>
        </ol>
        </li>
        </ol>
        </li>
        </ol>
        </li>
      </ol>
      </foreword></preface>
      </iso-standard>
    INPUT
    presxml = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title id="_" depth="1">Contents</fmt-title>
            </clause>
            <foreword id="_" displayorder="2">
               <title id="_">Foreword</title>
               <fmt-title id="_" depth="1">
                  <semx element="title" source="_">Foreword</semx>
               </fmt-title>
               <ol id="_" type="alphabet" keep-with-next="true" keep-lines-together="true" autonum="1">
                  <name id="_">Caption</name>
                  <fmt-name id="_">
                     <semx element="name" source="_">Caption</semx>
                  </fmt-name>
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">a</semx>
                        <span class="fmt-label-delim">)</span>
                     </fmt-name>
                     <p id="_">Level 1</p>
                  </li>
               </ol>
               <ol id="A" type="alphabet">
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">a</semx>
                        <span class="fmt-label-delim">)</span>
                     </fmt-name>
                     <p id="_">Level 1</p>
                  </li>
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">b</semx>
                        <span class="fmt-label-delim">)</span>
                     </fmt-name>
                     <p id="_">Level 1</p>
                     <ol type="arabic">
                        <li id="_">
                           <fmt-name id="_">
                              <semx element="autonum" source="_">1</semx>
                              <span class="fmt-label-delim">)</span>
                           </fmt-name>
                           <p id="_">Level 2</p>
                           <ol type="roman">
                              <li id="_">
                                 <fmt-name id="_">
                                    <semx element="autonum" source="_">i</semx>
                                    <span class="fmt-label-delim">)</span>
                                 </fmt-name>
                                 <p id="_">Level 3</p>
                                 <ol type="alphabet_upper">
                                    <li id="_">
                                       <fmt-name id="_">
                                          <semx element="autonum" source="_">A</semx>
                                          <span class="fmt-label-delim">.</span>
                                       </fmt-name>
                                       <p id="_">Level 4</p>
                                    </li>
                                 </ol>
                              </li>
                           </ol>
                        </li>
                     </ol>
                  </li>
               </ol>
            </foreword>
         </preface>
      </iso-standard>
    INPUT
    expect(Canon.format_xml(strip_guid(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<i18nyaml>.*</i18nyaml>}m, ""))))
      .to be_equivalent_to Canon.format_xml(presxml)
  end
end

require "spec_helper"

logoloc = Pathname.new(File.join(
                         File.expand_path(
                           File.join(File.dirname(__FILE__),
                                     "..", "..", "lib", "metanorma"),
                         ),
                         "..", "..", "lib", "isodoc", "iho", "html"
                       )).cleanpath.to_s

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
          <role type="publisher"/>
          <organization>
            <name>Ribose</name>
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
      <sections/>
      </iho-standard>
    INPUT

    output =
      { accesseddate: "XXX",
        adapteddate: "XXX",
        agency: "Ribose",
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
        implementeddate: "2000-01-01",
        issueddate: "XXX",
        lang: "en",
        logo: "#{File.join(logoloc, 'logo.png')}",
        logo_paths: ["#{File.join(logoloc, 'image001.png')}",
                     "#{File.join(logoloc, 'image002.png')}", "#{File.join(logoloc, 'image003.png')}"],
        maintitle: "Main Title",
        metadata_extensions: { "doctype" => "standard",
                               "editorialgroup" => { "committee_type" => "A", "committee" => "TC" }, "security" => "Client Confidential", "commentperiod" => { "from" => "2010", "to" => "2011" } },
        obsoleteddate: "2001-01-01",
        parttitle: "Part Title",
        publisheddate: "XXX",
        publisher: "Ribose",
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
        tc: "TC",
        transmitteddate: "XXX",
        unchangeddate: "XXX",
        unpublished: true,
        updateddate: "XXX",
        vote_endeddate: "XXX",
        vote_starteddate: "XXX" }

    docxml, _filename, _dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil))
      .to_s.gsub(/, :/, ",\n:"))).to be_equivalent_to output
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

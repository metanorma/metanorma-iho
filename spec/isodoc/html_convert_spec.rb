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
        <title language="en" format="plain">Main Title</title>
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
      {:accesseddate=>"XXX",
      :adapteddate=>"XXX",
      :agency=>"Ribose",
      :announceddate=>"XXX",
      :circulateddate=>"XXX",
      :confirmeddate=>"XXX",
      :copieddate=>"XXX",
      :correcteddate=>"XXX",
      :createddate=>"XXX",
      :docnumber=>"1000(wd)",
      :docnumeric=>"1000",
      :doctitle=>"Main Title",
      :doctype=>"Standard",
      :doctype_display=>"Standard",
      :docyear=>"2001",
      :draft=>"3.4",
      :draftinfo=>" (draft 3.4, 2000-01-01)",
      :edition=>"2",
      :implementeddate=>"2000-01-01",
      :issueddate=>"XXX",
      :lang=>"en",
      :logo=>"#{File.join(logoloc, 'logo.png')}",
      :logo_paths=>["#{File.join(logoloc, 'image001.png')}", "#{File.join(logoloc, 'image002.png')}", "#{File.join(logoloc, 'image003.png')}"],
      :metadata_extensions=>{"doctype"=>"standard", "editorialgroup"=>{"committee_type"=>"A", "committee"=>"TC"}, "security"=>"Client Confidential", "commentperiod"=>{"from"=>"2010", "to"=>"2011"}},
      :obsoleteddate=>"2001-01-01",
      :publisheddate=>"XXX",
      :publisher=>"Ribose",
      :receiveddate=>"XXX",
      :revdate=>"2000-01-01",
      :revdate_monthyear=>"January 2000",
      :script=>"Latn",
      :series=>"Bathymetric",
      :seriesabbr=>"B",
      :stable_untildate=>"XXX",
      :stage=>"Working Draft",
      :stage_display=>"Working Draft",
      :tc=>"TC",
      :transmitteddate=>"XXX",
      :unchangeddate=>"XXX",
      :unpublished=>true,
      :updateddate=>"XXX",
      :vote_endeddate=>"XXX",
      :vote_starteddate=>"XXX"}

    docxml, _filename, _dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil))
      .to_s.gsub(/, :/, ",\n:"))).to be_equivalent_to output
  end

  it "processes section names" do
    input = <<~INPUT
      <iho-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
        <foreword obligation="informative">
           <title>Foreword</title>
           <p id="A">This is a preamble</p>
         </foreword>
          <executivesummary id="A1" obligation="informative"><title>Executive Summary</title>
          </executivesummary>
          <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
           <title>Introduction Subsection</title>
         </clause>
         </introduction></preface><sections>
         <clause id="D" obligation="normative" type="scope">
           <title>Scope</title>
           <p id="E">Text</p>
         </clause>

         <clause id="H" obligation="normative"><title>Terms, definitions, symbols and abbreviated terms</title><terms id="I" obligation="normative">
           <title>Normal Terms</title>
           <term id="J">
           <preferred><expression><name>Term2</name></expression></preferred>
         </term>
         </terms>
         <definitions id="K">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
         <definitions id="L">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
           <title>Introduction</title>
         </clause>
         <clause id="O" inline-header="false" obligation="normative">
           <title>Clause 4.2</title>
         </clause></clause>

         </sections><annex id="P" inline-header="false" obligation="normative">
           <title>Annex</title>
           <clause id="Q" inline-header="false" obligation="normative">
           <title>Annex A.1</title>
           <clause id="Q1" inline-header="false" obligation="normative">
           <title>Annex A.1a</title>
           </clause>
         </clause>
         </annex><bibliography><references id="R" obligation="informative" normative="true">
           <title>Normative References</title>
         </references><clause id="S" obligation="informative">
           <title>Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title>Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </iho-standard>
    INPUT
    output = <<~OUTPUT
       <iho-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
             <foreword obligation="informative" displayorder="2" id="_">
                <title id="_">Foreword</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Foreword</semx>
                </fmt-title>
                <p id="A">This is a preamble</p>
             </foreword>
             <executivesummary id="A1" obligation="informative" displayorder="3">
                <title id="_">Executive Summary</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Executive Summary</semx>
                </fmt-title>
             </executivesummary>
             <introduction id="B" obligation="informative" displayorder="4">
                <title id="_">Introduction</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Introduction</semx>
                </fmt-title>
                <clause id="C" inline-header="false" obligation="informative">
                   <title id="_">Introduction Subsection</title>
                   <fmt-title depth="2">
                      <semx element="title" source="_">Introduction Subsection</semx>
                   </fmt-title>
                </clause>
             </introduction>
          </preface>
          <sections>
             <clause id="D" obligation="normative" type="scope" displayorder="5">
                <title id="_">Scope</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="D">1</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Scope</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Section</span>
                   <semx element="autonum" source="D">1</semx>
                </fmt-xref-label>
                <p id="E">Text</p>
             </clause>
             <clause id="H" obligation="normative" displayorder="7">
                <title id="_">Terms, definitions, symbols and abbreviated terms</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="H">3</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms, definitions, symbols and abbreviated terms</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Section</span>
                   <semx element="autonum" source="H">3</semx>
                </fmt-xref-label>
                <terms id="I" obligation="normative">
                   <title id="_">Normal Terms</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">3</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="I">1</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Normal Terms</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="H">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="I">1</semx>
                   </fmt-xref-label>
                   <term id="J">
                      <preferred id="_"><expression><name>Term2</name></expression></preferred>
               <fmt-preferred>
                  <p>
                     <semx element="preferred" source="_">
                        <strong>Term2</strong>
                     </semx>
                  </p>
               </fmt-preferred>
                   </term>
                </terms>
                <definitions id="K">
                   <title id="_">Symbols</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">3</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="K">2</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Symbols</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="H">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="K">2</semx>
                   </fmt-xref-label>
                   <dl>
                      <dt>Symbol</dt>
                      <dd>Definition</dd>
                   </dl>
                </definitions>
             </clause>
             <definitions id="L" displayorder="8">
                <title id="_">Symbols</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="L">4</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Symbols</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Section</span>
                   <semx element="autonum" source="L">4</semx>
                </fmt-xref-label>
                <dl>
                   <dt>Symbol</dt>
                   <dd>Definition</dd>
                </dl>
             </definitions>
             <clause id="M" inline-header="false" obligation="normative" displayorder="9">
                <title id="_">Clause 4</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="M">5</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Clause 4</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Section</span>
                   <semx element="autonum" source="M">5</semx>
                </fmt-xref-label>
                <clause id="N" inline-header="false" obligation="normative">
                   <title id="_">Introduction</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="M">5</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="N">1</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Introduction</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="M">5</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="N">1</semx>
                   </fmt-xref-label>
                </clause>
                <clause id="O" inline-header="false" obligation="normative">
                   <title id="_">Clause 4.2</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="M">5</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="O">2</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Clause 4.2</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="M">5</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="O">2</semx>
                   </fmt-xref-label>
                </clause>
             </clause>
             <references id="R" obligation="informative" normative="true" displayorder="6">
                <title id="_">Normative References</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="R">2</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Normative References</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Section</span>
                   <semx element="autonum" source="R">2</semx>
                </fmt-xref-label>
             </references>
          </sections>
          <annex id="P" inline-header="false" obligation="normative" autonum="A" displayorder="10">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="P">A</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="P">A</semx>
             </fmt-xref-label>
             <clause id="Q" inline-header="false" obligation="normative">
                <title id="_">Annex A.1</title>
                <fmt-title depth="2">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="P">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="Q">1</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Annex A.1</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Annex</span>
                   <semx element="autonum" source="P">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="Q">1</semx>
                </fmt-xref-label>
                <clause id="Q1" inline-header="false" obligation="normative">
                   <title id="_">Annex A.1a</title>
                   <fmt-title depth="3">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="P">A</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="Q">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="Q1">1</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Annex A.1a</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="P">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="Q">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="Q1">1</semx>
                   </fmt-xref-label>
                </clause>
             </clause>
          </annex>
          <bibliography>
             <clause id="S" obligation="informative" displayorder="11">
                <title id="_">Bibliography</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Bibliography</semx>
                </fmt-title>
                <references id="T" obligation="informative" normative="false">
                   <title id="_">Bibliography Subsection</title>
                   <fmt-title depth="2">
                      <semx element="title" source="_">Bibliography Subsection</semx>
                   </fmt-title>
                </references>
             </clause>
          </bibliography>
       </iho-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<i18nyaml>.*</i18nyaml>}m, ""))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes nested references and terms" do
    input = <<~INPUT
      <iho-standard xmlns="http://riboseinc.com/isoxml">
         <sections>
         <clause id="A"><title>Overview</title>
         <clause id="D" obligation="normative" type="scope">
           <title>Scope</title>
           <p id="E">Text</p>
         </clause>
          <references id="R" obligation="informative" normative="true">
           <title>Normative References</title>
         </references>
         <clause id="H" obligation="normative"><title>Terms, definitions, symbols and abbreviated terms</title><terms id="I" obligation="normative">
           <title>Normal Terms</title>
           <term id="J">
           <preferred><expression><name>Term2</name></expression></preferred>
         </term>
         </terms>
         <definitions id="K">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
         <definitions id="L">
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
           <title>Introduction</title>
         </clause>
         </clause>
         <clause id="O" inline-header="false" obligation="normative">
           <title>Clause 4.2</title>
         </clause></clause>

         </sections><annex id="P" inline-header="false" obligation="normative">
           <title>Annex</title>
           <clause id="Q" inline-header="false" obligation="normative">
           <title>Annex A.1</title>
           <clause id="Q1" inline-header="false" obligation="normative">
           <title>Annex A.1a</title>
           </clause>
         </clause>
         </annex>
         <bibliography>
         <clause id="S" obligation="informative">
           <title>Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title>Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </iho-standard>
    INPUT
    output = <<~OUTPUT
     <iho-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <clause id="A" displayorder="2">
                <title id="_">Overview</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">1</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Overview</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Section</span>
                   <semx element="autonum" source="A">1</semx>
                </fmt-xref-label>
                <clause id="D" obligation="normative" type="scope">
                   <title id="_">Scope</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="D">1</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Scope</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="D">1</semx>
                   </fmt-xref-label>
                   <p id="E">Text</p>
                </clause>
                <references id="R" obligation="informative" normative="true">
                   <title id="_">Normative References</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="R">2</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Normative References</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="R">2</semx>
                   </fmt-xref-label>
                </references>
                <clause id="H" obligation="normative">
                   <title id="_">Terms, definitions, symbols and abbreviated terms</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="H">3</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Terms, definitions, symbols and abbreviated terms</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="H">3</semx>
                   </fmt-xref-label>
                   <terms id="I" obligation="normative">
                      <title id="_">Normal Terms</title>
                      <fmt-title depth="3">
                         <span class="fmt-caption-label">
                            <semx element="autonum" source="A">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="H">3</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="I">1</semx>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                         <semx element="title" source="_">Normal Terms</semx>
                      </fmt-title>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Clause</span>
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="H">3</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="I">1</semx>
                      </fmt-xref-label>
                      <term id="J">
                 <preferred id="_">
                    <expression>
                       <name>Term2</name>
                    </expression>
                 </preferred>
                 <fmt-preferred>
                    <p>
                       <semx element="preferred" source="_">
                          <strong>Term2</strong>
                       </semx>
                    </p>
                 </fmt-preferred>
                      </term>
                   </terms>
                   <definitions id="K">
                      <title id="_">Symbols</title>
                      <fmt-title depth="3">
                         <span class="fmt-caption-label">
                            <semx element="autonum" source="A">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="H">3</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="K">2</semx>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                         <semx element="title" source="_">Symbols</semx>
                      </fmt-title>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Clause</span>
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="H">3</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="K">2</semx>
                      </fmt-xref-label>
                      <dl>
                         <dt>Symbol</dt>
                         <dd>Definition</dd>
                      </dl>
                   </definitions>
                </clause>
                <definitions id="L">
                   <title id="_">Symbols</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="L">4</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Symbols</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="L">4</semx>
                   </fmt-xref-label>
                   <dl>
                      <dt>Symbol</dt>
                      <dd>Definition</dd>
                   </dl>
                </definitions>
                <clause id="M" inline-header="false" obligation="normative">
                   <title id="_">Clause 4</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="M">5</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Clause 4</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="M">5</semx>
                   </fmt-xref-label>
                   <clause id="N" inline-header="false" obligation="normative">
                      <title id="_">Introduction</title>
                      <fmt-title depth="3">
                         <span class="fmt-caption-label">
                            <semx element="autonum" source="A">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="M">5</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="N">1</semx>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                         <semx element="title" source="_">Introduction</semx>
                      </fmt-title>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Clause</span>
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="M">5</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="N">1</semx>
                      </fmt-xref-label>
                   </clause>
                </clause>
                <clause id="O" inline-header="false" obligation="normative">
                   <title id="_">Clause 4.2</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="O">6</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Clause 4.2</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="O">6</semx>
                   </fmt-xref-label>
                </clause>
             </clause>
          </sections>
          <annex id="P" inline-header="false" obligation="normative" autonum="A" displayorder="3">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="P">A</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="P">A</semx>
             </fmt-xref-label>
             <clause id="Q" inline-header="false" obligation="normative">
                <title id="_">Annex A.1</title>
                <fmt-title depth="2">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="P">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="Q">1</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Annex A.1</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Annex</span>
                   <semx element="autonum" source="P">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="Q">1</semx>
                </fmt-xref-label>
                <clause id="Q1" inline-header="false" obligation="normative">
                   <title id="_">Annex A.1a</title>
                   <fmt-title depth="3">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="P">A</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="Q">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="Q1">1</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Annex A.1a</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="P">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="Q">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="Q1">1</semx>
                   </fmt-xref-label>
                </clause>
             </clause>
          </annex>
          <bibliography>
             <clause id="S" obligation="informative" displayorder="4">
                <title id="_">Bibliography</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Bibliography</semx>
                </fmt-title>
                <references id="T" obligation="informative" normative="false">
                   <title id="_">Bibliography Subsection</title>
                   <fmt-title depth="2">
                      <semx element="title" source="_">Bibliography Subsection</semx>
                   </fmt-title>
                </references>
             </clause>
          </bibliography>
       </iho-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Iho::PresentationXMLConvert
          .new(presxml_options)
          .convert("test", input, true)
          .sub(%r{<i18nyaml>.*</i18nyaml>}m, ""))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes annexes and appendixes" do
    input = <<~INPUT
             <iho-standard xmlns="http://riboseinc.com/isoxml">
             <bibdata type="standard">
             <title language="en" format="text/plain" type="main">An ITU Standard</title>
             <docidentifier type="ITU">12345</docidentifier>
             <language>en</language>
             <keyword>A</keyword>
             <keyword>B</keyword>
             <ext>
             </ext>
             </bibdata>
             <preface>
             <abstract>
             <title>Abstract</abstract>
                 <xref target="A1"/>
                 <xref target="B1"/>
             </abstract>
             </preface>
             <annex id="A1" obligation="normative"><title>Annex</title></annex>
      <annex id="A2" obligation="normative"><title>Annex</title></annex>
      <annex id="A3" obligation="normative"><title>Annex</title></annex>
      <annex id="A4" obligation="normative"><title>Annex</title></annex>
      <annex id="A5" obligation="normative"><title>Annex</title></annex>
      <annex id="A6" obligation="normative"><title>Annex</title></annex>
      <annex id="A7" obligation="normative"><title>Annex</title></annex>
      <annex id="A8" obligation="normative"><title>Annex</title></annex>
      <annex id="A9" obligation="normative"><title>Annex</title></annex>
      <annex id="A10" obligation="normative"><title>Annex</title>
      <clause id="A10a"/>
      <appendix id="A10b"><title>App</title>
      </appendix>
      </annex>
      <annex id="B1" obligation="informative"><title>Annex</title></annex>
      <annex id="B2" obligation="informative"><title>Annex</title></annex>
      <annex id="B3" obligation="informative"><title>Annex</title></annex>
      <annex id="B4" obligation="informative"><title>Annex</title></annex>
      <annex id="B5" obligation="informative"><title>Annex</title></annex>
      <annex id="B6" obligation="informative"><title>Annex</title></annex>
      <annex id="B7" obligation="informative"><title>Annex</title></annex>
      <annex id="B8" obligation="informative"><title>Annex</title></annex>
      <annex id="B9" obligation="informative"><title>Annex</title></annex>
      <annex id="B10" obligation="informative"><title>Annex</title>
      <clause id="B10a"/>
      <appendix id="B10b"><title>App</title>
      </appendix>
      </annex>
      </iho-standard)
    INPUT
    presxml = <<~OUTPUT
      <iho-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata type="standard">
             <title language="en" format="text/plain" type="main">An ITU Standard</title>
             <docidentifier type="ITU">12345</docidentifier>
             <language current="true">en</language>
             <keyword>A</keyword>
             <keyword>B</keyword>
             <ext>
              </ext>
          </bibdata>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
             <abstract id="_" displayorder="2">
                <title id="_">Abstract</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Abstract</semx>
                </fmt-title>
                <xref target="A1" id="_"/>
                <semx element="xref" source="_">
                   <fmt-xref target="A1">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A1">A</semx>
                   </fmt-xref>
                </semx>
                <xref target="B1" id="_"/>
                <semx element="xref" source="_">
                   <fmt-xref target="B1">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B1">1</semx>
                   </fmt-xref>
                </semx>
             </abstract>
          </preface>
          <annex id="A1" obligation="normative" autonum="A" displayorder="3">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A1">A</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A1">A</semx>
             </fmt-xref-label>
          </annex>
          <annex id="A2" obligation="normative" autonum="B" displayorder="4">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A2">B</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A2">B</semx>
             </fmt-xref-label>
          </annex>
          <annex id="A3" obligation="normative" autonum="C" displayorder="5">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A3">C</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A3">C</semx>
             </fmt-xref-label>
          </annex>
          <annex id="A4" obligation="normative" autonum="D" displayorder="6">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A4">D</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A4">D</semx>
             </fmt-xref-label>
          </annex>
          <annex id="A5" obligation="normative" autonum="E" displayorder="7">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A5">E</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A5">E</semx>
             </fmt-xref-label>
          </annex>
          <annex id="A6" obligation="normative" autonum="F" displayorder="8">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A6">F</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A6">F</semx>
             </fmt-xref-label>
          </annex>
          <annex id="A7" obligation="normative" autonum="G" displayorder="9">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A7">G</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A7">G</semx>
             </fmt-xref-label>
          </annex>
          <annex id="A8" obligation="normative" autonum="H" displayorder="10">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A8">H</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A8">H</semx>
             </fmt-xref-label>
          </annex>
          <annex id="A9" obligation="normative" autonum="I" displayorder="11">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A9">I</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A9">I</semx>
             </fmt-xref-label>
          </annex>
          <annex id="A10" obligation="normative" autonum="J" displayorder="12">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A10">J</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="A10">J</semx>
             </fmt-xref-label>
             <clause id="A10a">
                <fmt-title depth="2">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A10">J</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="A10a">1</semx>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Annex</span>
                   <semx element="autonum" source="A10">J</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="A10a">1</semx>
                </fmt-xref-label>
             </clause>
             <appendix id="A10b" autonum="1">
                <title id="_">App</title>
                <fmt-title depth="2">
                   <span class="fmt-caption-label">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="A10b">1</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">App</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Appendix</span>
                   <semx element="autonum" source="A10b">1</semx>
                </fmt-xref-label>
                <fmt-xref-label container="A10">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="A10">J</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Appendix</span>
                   <semx element="autonum" source="A10b">1</semx>
                </fmt-xref-label>
             </appendix>
          </annex>
          <annex id="B1" obligation="informative" autonum="1" displayorder="13">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B1">1</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B1">1</semx>
             </fmt-xref-label>
          </annex>
          <annex id="B2" obligation="informative" autonum="2" displayorder="14">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B2">2</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B2">2</semx>
             </fmt-xref-label>
          </annex>
          <annex id="B3" obligation="informative" autonum="3" displayorder="15">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B3">3</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B3">3</semx>
             </fmt-xref-label>
          </annex>
          <annex id="B4" obligation="informative" autonum="4" displayorder="16">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B4">4</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B4">4</semx>
             </fmt-xref-label>
          </annex>
          <annex id="B5" obligation="informative" autonum="5" displayorder="17">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B5">5</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B5">5</semx>
             </fmt-xref-label>
          </annex>
          <annex id="B6" obligation="informative" autonum="6" displayorder="18">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B6">6</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B6">6</semx>
             </fmt-xref-label>
          </annex>
          <annex id="B7" obligation="informative" autonum="7" displayorder="19">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B7">7</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B7">7</semx>
             </fmt-xref-label>
          </annex>
          <annex id="B8" obligation="informative" autonum="8" displayorder="20">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B8">8</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B8">8</semx>
             </fmt-xref-label>
          </annex>
          <annex id="B9" obligation="informative" autonum="9" displayorder="21">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B9">9</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B9">9</semx>
             </fmt-xref-label>
          </annex>
          <annex id="B10" obligation="informative" autonum="10" displayorder="22">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B10">10</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="B10">10</semx>
             </fmt-xref-label>
             <clause id="B10a">
                <fmt-title depth="2">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="B10">10</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="B10a">1</semx>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Appendix</span>
                   <semx element="autonum" source="B10">10</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B10a">1</semx>
                </fmt-xref-label>
             </clause>
             <appendix id="B10b" autonum="1">
                <title id="_">App</title>
                <fmt-title depth="2">
                   <span class="fmt-caption-label">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B10b">1</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">App</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Appendix</span>
                   <semx element="autonum" source="B10b">1</semx>
                </fmt-xref-label>
                <fmt-xref-label container="B10">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="B10">10</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Appendix</span>
                   <semx element="autonum" source="B10b">1</semx>
                </fmt-xref-label>
             </appendix>
          </annex>
       </iho-standard>
    OUTPUT

    html = <<~OUTPUT
                  #{HTML_HDR}
                             <br/>
             <div id="_" class="TOC">
                <h1 class="IntroTitle">Contents</h1>
             </div>
             <br/>
             <div id="_">
                <h1 class="AbstractTitle">Abstract</h1>
                <a href="#A1">Annex A</a>
                <a href="#B1">Appendix 1</a>
             </div>
             <br/>
             <div id="A1" class="Section3">
                <h1 class="Annex">
                   <b>Annex A</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="A2" class="Section3">
                <h1 class="Annex">
                   <b>Annex B</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="A3" class="Section3">
                <h1 class="Annex">
                   <b>Annex C</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="A4" class="Section3">
                <h1 class="Annex">
                   <b>Annex D</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="A5" class="Section3">
                <h1 class="Annex">
                   <b>Annex E</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="A6" class="Section3">
                <h1 class="Annex">
                   <b>Annex F</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="A7" class="Section3">
                <h1 class="Annex">
                   <b>Annex G</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="A8" class="Section3">
                <h1 class="Annex">
                   <b>Annex H</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="A9" class="Section3">
                <h1 class="Annex">
                   <b>Annex I</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="A10" class="Section3">
                <h1 class="Annex">
                   <b>Annex J</b>
                   <br/>
                   <b>Annex</b>
                </h1>
                <div id="A10a">
                   <h2>J.1</h2>
                </div>
                <div id="A10b">
                   <h2>Appendix 1  App</h2>
                </div>
             </div>
             <br/>
             <div id="B1" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 1</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="B2" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 2</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="B3" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 3</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="B4" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 4</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="B5" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 5</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="B6" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 6</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="B7" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 7</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="B8" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 8</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="B9" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 9</b>
                   <br/>
                   <b>Annex</b>
                </h1>
             </div>
             <br/>
             <div id="B10" class="Section3">
                <h1 class="Annex">
                   <b>Appendix 10</b>
                   <br/>
                   <b>Annex</b>
                </h1>
                <div id="B10a">
                   <h2>10.1</h2>
                </div>
                <div id="B10b">
                   <h2>Appendix 1  App</h2>
                </div>
             </div>
          </div>
       </body>
    OUTPUT
    pres_output = IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(IsoDoc::Iho::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))))
      .to be_equivalent_to Xml::C14n.format(html)
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

    output = Xml::C14n.format(<<~"OUTPUT")
          #{BLANK_HDR}
      <sections/>
      </iho-standard>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor
      .convert(input, backend: :iho, header_footer: true))))
      .to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
  end

  it "inserts document history clause" do
    input = <<~INPUT
      <iho-standard xmlns="http://riboseinc.com/isoxml">
         <bibdata type="standard">
         <title language="en" format="text/plain">Document title</title>
         <docidentifier type="IHO">S-</docidentifier>
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
           <from>2024</from>
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
             <amend>
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
               </organization>
             </contributor>
             <edition>2.0.0</edition>
             <amend>
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
               <role type="author"/>
               <person>
                 <name>
                   <completename>Fred Flintstone</completename>
                   <abbreviation>FF</abbreviation>
                 </name>
               </person>
             </contributor>
             <contributor>
               <role type="author"/>
               <person>
                 <name>
                   <completename>Barney Rubble</completename>
                 </name>
               </person>
             </contributor>
             <edition>2.0.0</edition>
             <amend>
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
               <role type="author"/>
               <person>
                 <name><surname>Hering</surname><forename>Milena</forename><forename>S.</forename></name>
               </person>
             </contributor>
             <edition>2.0.0</edition>
             <amend>
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
             <amend>
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
         </ext>
       </bibdata>
       <sections/>
       </iho-standard>
    INPUT
    output = <<~OUTPUT
                 <preface>
        <clause type="toc" id="_" displayorder="1">
           <fmt-title depth="1">Contents</fmt-title>
        </clause>
        <clause id="_" displayorder="2">
      <title id="_">Document History</title>
      <fmt-title depth="1">
         <semx element="title" source="_">Document History</semx>
      </fmt-title>
          <table unnumbered="true">
            <thead>
              <tr>
                <th>Version Number</th>
                <th>Date</th>
                <th>Author</th>
                <th>Description</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1.0.0</td>
                <td>April 2012</td>
                <td>
                  <formattedref/>
                </td>
                <td>
                  <p id="_">Approved edition of S-102</p>
                </td>
              </tr>
              <tr>
                <td>2.0.0</td>
                <td>March 2017</td>
                <td>
                  <formattedref/>
                </td>
                <td>
                  <p id="_">Updated clause 4.0 and 12.0.
       Populated clause 9.0 and Annex B.</p>
                </td>
              </tr>
              <tr>
                <td>2.0.0</td>
                <td>May 2017</td>
                <td>
                  <formattedref>FRED FLINTSTONE</formattedref>
                  ,
                  <formattedref>BARNEY RUBBLE</formattedref>
                </td>
                <td>
                  <p id="_">Modified clause 9.0 based on feedback at S-100WG2 meeting.</p>
                </td>
              </tr>
              <tr>
                <td>2.0.0</td>
                <td>February 2018</td>
                <td>
                  <formattedref>HERING, Milena S.</formattedref>
                </td>
                <td>
                  <p id="_">Modified clause 9.0. Deleted contents of Annex B in preparation for updated S-100 Part 10C guidance. Added Annex F: S-102 Dataset Size and Production, Annex G: Gridding Example, Annex H: Statement added for Multi-Resolution Gridding, Annex I: Statement for future S-102 Tiling.</p>
                </td>
              </tr>
              <tr>
                <td>2.0.0</td>
                <td>June 2018</td>
                <td>
                  <formattedref/>
                </td>
                <td>
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
                </td>
              </tr>
            </tbody>
          </table>
        </clause>
      </preface>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(
      IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true),
    )
      .at("//xmlns:preface").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end

require "spec_helper"

logoloc = Pathname.new(File.join(
                         File.expand_path(
                           File.join(File.dirname(__FILE__),
                                     "..", "..", "lib", "metanorma"),
                         ),
                         "..", "..", "lib", "isodoc", "iho", "html"
                       )).cleanpath.to_s

RSpec.describe IsoDoc::IHO do
  it "processes default metadata" do
    csdc = IsoDoc::IHO::HtmlConvert.new({})
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

    output = <<~"OUTPUT"
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
    OUTPUT

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
           <preferred>Term2</preferred>
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
         <title depth="1">Contents</title>
       </clause>
        <foreword obligation="informative" displayorder="2">
           <title>Foreword</title>
           <p id="A">This is a preamble</p>
         </foreword>
          <executivesummary id="A1" obligation="informative" displayorder="3"><title>Executive Summary</title>
          </executivesummary>
          <introduction id="B" obligation="informative" displayorder="4"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
           <title depth="2">Introduction Subsection</title>
         </clause>
         </introduction></preface><sections>
         <clause id="D" obligation="normative" type="scope" displayorder="5">
           <title depth="1">1.<tab/>Scope</title>
           <p id="E">Text</p>
         </clause>
         <clause id="H" obligation="normative" displayorder="7"><title depth="1">3.<tab/>Terms, definitions, symbols and abbreviated terms</title><terms id="I" obligation="normative">
           <title depth="2">3.1.<tab/>Normal Terms</title>
           <term id="J"><name>3.1.1.</name>
           <preferred>Term2</preferred>
         </term>
         </terms>
         <definitions id="K"><title>3.2.</title>
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
         <definitions id="L" displayorder="8"><title>4.</title>
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         <clause id="M" inline-header="false" obligation="normative" displayorder="9"><title depth="1">5.<tab/>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
           <title depth="2">5.1.<tab/>Introduction</title>
         </clause>
         <clause id="O" inline-header="false" obligation="normative">
           <title depth="2">5.2.<tab/>Clause 4.2</title>
         </clause></clause>
         <references id="R" obligation="informative" normative="true" displayorder="6">
           <title depth="1">2.<tab/>Normative References</title>
         </references>
         </sections><annex id="P" inline-header="false" obligation="normative" displayorder="10">
           <title><strong>Annex A</strong><br/><strong>Annex</strong></title>
           <clause id="Q" inline-header="false" obligation="normative">
           <title depth="2">A.1.<tab/>Annex A.1</title>
           <clause id="Q1" inline-header="false" obligation="normative">
           <title depth="3">A.1.1.<tab/>Annex A.1a</title>
           </clause>
         </clause>
         </annex><bibliography>
         <clause id="S" obligation="informative" displayorder="11">
           <title depth="1">Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title depth="2">Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </iho-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::IHO::PresentationXMLConvert
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
           <preferred>Term2</preferred>
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
            <title depth="1">Contents</title>
          </clause>
        </preface>
        <sections>
          <clause id="A" displayorder="2">
            <title depth="1">
              1.
              <tab/>
              Overview
            </title>
            <clause id="D" obligation="normative" type="scope">
              <title depth="2">
                1.1.
                <tab/>
                Scope
              </title>
              <p id="E">Text</p>
            </clause>
            <references id="R" obligation="informative" normative="true">
              <title depth="2">
                1.2.
                <tab/>
                Normative References
              </title>
            </references>
            <clause id="H" obligation="normative">
              <title depth="2">
                1.3.
                <tab/>
                Terms, definitions, symbols and abbreviated terms
              </title>
              <terms id="I" obligation="normative">
                <title depth="3">
                  1.3.1.
                  <tab/>
                  Normal Terms
                </title>
                <term id="J">
                  <name>1.3.1.1.</name>
                  <preferred>Term2</preferred>
                </term>
              </terms>
              <definitions id="K">
                <title>1.3.2.</title>
                <dl>
                  <dt>Symbol</dt>
                  <dd>Definition</dd>
                </dl>
              </definitions>
            </clause>
            <definitions id="L">
              <title>1.4.</title>
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
            <clause id="M" inline-header="false" obligation="normative">
              <title depth="2">
                1.5.
                <tab/>
                Clause 4
              </title>
              <clause id="N" inline-header="false" obligation="normative">
                <title depth="3">
                  1.5.1.
                  <tab/>
                  Introduction
                </title>
              </clause>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title depth="2">
                1.6.
                <tab/>
                Clause 4.2
              </title>
            </clause>
          </clause>
        </sections>
        <annex id="P" inline-header="false" obligation="normative" displayorder="3">
          <title>
            <strong>Annex A</strong>
            <br/>
            <strong>Annex</strong>
          </title>
          <clause id="Q" inline-header="false" obligation="normative">
            <title depth="2">
              A.1.
              <tab/>
              Annex A.1
            </title>
            <clause id="Q1" inline-header="false" obligation="normative">
              <title depth="3">
                A.1.1.
                <tab/>
                Annex A.1a
              </title>
            </clause>
          </clause>
        </annex>
        <bibliography>
          <clause id="S" obligation="informative" displayorder="4">
            <title depth="1">Bibliography</title>
            <references id="T" obligation="informative" normative="false">
              <title depth="2">Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </iho-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::IHO::PresentationXMLConvert
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
      <annex id="A10" obligation="normative"><title>Annex</title></annex>
      <annex id="B1" obligation="informative"><title>Annex</title></annex>
      <annex id="B2" obligation="informative"><title>Annex</title></annex>
      <annex id="B3" obligation="informative"><title>Annex</title></annex>
      <annex id="B4" obligation="informative"><title>Annex</title></annex>
      <annex id="B5" obligation="informative"><title>Annex</title></annex>
      <annex id="B6" obligation="informative"><title>Annex</title></annex>
      <annex id="B7" obligation="informative"><title>Annex</title></annex>
      <annex id="B8" obligation="informative"><title>Annex</title></annex>
      <annex id="B9" obligation="informative"><title>Annex</title></annex>
      <annex id="B10" obligation="informative"><title>Annex</title></annex>
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
             <title depth="1">Contents</title>
             </clause>
             <abstract displayorder="2">
             <title>Abstract</title>
                 <xref target="A1">Annex A</xref>
                 <xref target="B1">Appendix 1</xref>
             </abstract>
             </preface>
             <annex id="A1" obligation="normative" displayorder="3"><title><strong>Annex A</strong><br/><strong>Annex</strong></title></annex>
      <annex id="A2" obligation="normative" displayorder="4"><title><strong>Annex B</strong><br/><strong>Annex</strong></title></annex>
      <annex id="A3" obligation="normative" displayorder="5"><title><strong>Annex C</strong><br/><strong>Annex</strong></title></annex>
      <annex id="A4" obligation="normative" displayorder="6"><title><strong>Annex D</strong><br/><strong>Annex</strong></title></annex>
      <annex id="A5" obligation="normative" displayorder="7"><title><strong>Annex E</strong><br/><strong>Annex</strong></title></annex>
      <annex id="A6" obligation="normative" displayorder="8"><title><strong>Annex F</strong><br/><strong>Annex</strong></title></annex>
      <annex id="A7" obligation="normative" displayorder="9"><title><strong>Annex G</strong><br/><strong>Annex</strong></title></annex>
      <annex id="A8" obligation="normative" displayorder="10"><title><strong>Annex H</strong><br/><strong>Annex</strong></title></annex>
      <annex id="A9" obligation="normative" displayorder="11"><title><strong>Annex J</strong><br/><strong>Annex</strong></title></annex>
      <annex id="A10" obligation="normative" displayorder="12"><title><strong>Annex K</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B1" obligation="informative" displayorder="13"><title><strong>Appendix 1</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B2" obligation="informative" displayorder="14"><title><strong>Appendix 2</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B3" obligation="informative" displayorder="15"><title><strong>Appendix 3</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B4" obligation="informative" displayorder="16"><title><strong>Appendix 4</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B5" obligation="informative" displayorder="17"><title><strong>Appendix 5</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B6" obligation="informative" displayorder="18"><title><strong>Appendix 6</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B7" obligation="informative" displayorder="19"><title><strong>Appendix 7</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B8" obligation="informative" displayorder="20"><title><strong>Appendix 8</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B9" obligation="informative" displayorder="21"><title><strong>Appendix 9</strong><br/><strong>Annex</strong></title></annex>
      <annex id="B10" obligation="informative" displayorder="22"><title><strong>Appendix 10</strong><br/><strong>Annex</strong></title></annex>
      </iho-standard>
    OUTPUT

    html = <<~OUTPUT
                  #{HTML_HDR}
                      <br/>
          <div id="_" class="TOC">
            <h1 class="IntroTitle">Contents</h1>
          </div>
                  <br/>
                  <div>
                        <h1 class='AbstractTitle'>Abstract</h1>
            <a href='#A1'>Annex A</a>
            <a href='#B1'>Appendix 1</a>
          </div>
          <br/>
          <div id='A1' class='Section3'>
            <h1 class='Annex'>
              <b>Annex A</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='A2' class='Section3'>
            <h1 class='Annex'>
              <b>Annex B</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='A3' class='Section3'>
            <h1 class='Annex'>
              <b>Annex C</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='A4' class='Section3'>
            <h1 class='Annex'>
              <b>Annex D</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='A5' class='Section3'>
            <h1 class='Annex'>
              <b>Annex E</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='A6' class='Section3'>
            <h1 class='Annex'>
              <b>Annex F</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='A7' class='Section3'>
            <h1 class='Annex'>
              <b>Annex G</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='A8' class='Section3'>
            <h1 class='Annex'>
              <b>Annex H</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='A9' class='Section3'>
            <h1 class='Annex'>
              <b>Annex J</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='A10' class='Section3'>
            <h1 class='Annex'>
              <b>Annex K</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B1' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 1</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B2' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 2</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B3' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 3</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B4' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 4</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B5' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 5</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B6' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 6</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B7' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 7</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B8' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 8</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B9' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 9</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
          <br/>
          <div id='B10' class='Section3'>
            <h1 class='Annex'>
              <b>Appendix 10</b>
              <br/>
              <b>Annex</b>
            </h1>
          </div>
        </div>
      </body>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::IHO::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::IHO::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
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
          <title depth="1">Contents</title>
        </clause>
        <clause id="_" displayorder="2">
          <title depth="1">Document History</title>
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
      IsoDoc::IHO::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true),
    )
      .at("//xmlns:preface").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end

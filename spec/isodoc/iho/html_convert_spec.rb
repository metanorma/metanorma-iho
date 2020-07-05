require "spec_helper"

logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "isodoc", "iho", "html"))

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
:agency=>"Ribose",
:authors=>[],
:authors_affiliations=>{},
:circulateddate=>"XXX",
:comment_from=>"2010",
:comment_to=>"2011",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"XXX",
:docnumber=>"1000(wd)",
:docnumeric=>"1000",
:doctitle=>"Main Title",
:doctype=>"Standard",
:docyear=>"2001",
:draft=>"3.4",
:draftinfo=>" (draft 3.4, 2000-01-01)",
:edition=>"2",
:implementeddate=>"2000-01-01",
:issueddate=>"XXX",
:keywords=>[],
:logo=>"#{File.join(logoloc, 'logo.png')}",
:logo_paths=>["#{File.join(logoloc, 'image001.png')}", "#{File.join(logoloc, 'image002.png')}", "#{File.join(logoloc, 'image003.png')}"],
:obsoleteddate=>"2001-01-01",
:publisheddate=>"XXX",
:publisher=>"Ribose",
:receiveddate=>"XXX",
:revdate=>"2000-01-01",
:revdate_monthyear=>"January 2000",
:series=>"Bathymetric",
:seriesabbr=>"B",
:stage=>"Working Draft",
:stageabbr=>nil,
:tc=>"TC",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>true,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s).gsub(/, :/, ",\n:")).to be_equivalent_to output
  end

  it "processes section names" do
      expect(xmlpp(IsoDoc::IHO::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
       <clause id="D" obligation="normative">
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
    <iho-standard xmlns='http://riboseinc.com/isoxml'>
         <preface>
           <foreword obligation='informative'>
             <title>Foreword</title>
             <p id='A'>This is a preamble</p>
           </foreword>
           <executivesummary id='A1' obligation='informative'>
             <title>Executive Summary</title>
           </executivesummary>
           <introduction id='B' obligation='informative'>
             <title>Introduction</title>
             <clause id='C' inline-header='false' obligation='informative'>
               <title depth='2'>Introduction Subsection</title>
             </clause>
           </introduction>
         </preface>
         <sections>
           <clause id='D' obligation='normative'>
             <title depth='1'>
               4.
               <tab/>
               Scope
             </title>
             <p id='E'>Text</p>
           </clause>
           <clause id='H' obligation='normative'>
             <title depth='1'>
               2.
               <tab/>
               Terms, definitions, symbols and abbreviated terms
             </title>
             <terms id='I' obligation='normative'>
               <title depth='2'>
                 2.1.
                 <tab/>
                 Normal Terms
               </title>
               <term id='J'>
                 <name>2.1.1.</name>
                 <preferred>Term2</preferred>
               </term>
             </terms>
             <definitions id='K'>
               <title>2.2.</title>
               <dl>
                 <dt>Symbol</dt>
                 <dd>Definition</dd>
               </dl>
             </definitions>
           </clause>
           <definitions id='L'>
             <title>3.</title>
             <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
             </dl>
           </definitions>
           <clause id='M' inline-header='false' obligation='normative'>
             <title depth='1'>
               5.
               <tab/>
               Clause 4
             </title>
             <clause id='N' inline-header='false' obligation='normative'>
               <title depth='2'>
                 5.1.
                 <tab/>
                 Introduction
               </title>
             </clause>
             <clause id='O' inline-header='false' obligation='normative'>
               <title depth='2'>
                 5.2.
                 <tab/>
                 Clause 4.2
               </title>
             </clause>
           </clause>
         </sections>
         <annex id='P' inline-header='false' obligation='normative'>
           <title>
             <strong>Annex A</strong>
             <br/>
             <strong>Annex</strong>
           </title>
           <clause id='Q' inline-header='false' obligation='normative'>
             <title depth='2'>
               A.1.
               <tab/>
               Annex A.1
             </title>
             <clause id='Q1' inline-header='false' obligation='normative'>
               <title depth='3'>
                 A.1.1.
                 <tab/>
                 Annex A.1a
               </title>
             </clause>
           </clause>
         </annex>
         <bibliography>
           <references id='R' obligation='informative' normative='true'>
             <title depth='1'>
               1.
               <tab/>
               Normative References
             </title>
           </references>
           <clause id='S' obligation='informative'>
             <title depth='1'>Bibliography</title>
             <references id='T' obligation='informative' normative='false'>
               <title depth='2'>Bibliography Subsection</title>
             </references>
           </clause>
         </bibliography>
       </iho-standard>
    OUTPUT

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
                  <xref target="A1">Annex A</xref>
                  <xref target="B1">Appendix 1</xref>
              </abstract>
              </preface>
              <annex id="A1" obligation="normative"><title><strong>Annex A</strong><br/><strong>Annex</strong></title></annex>
       <annex id="A2" obligation="normative"><title><strong>Annex B</strong><br/><strong>Annex</strong></title></annex>
       <annex id="A3" obligation="normative"><title><strong>Annex C</strong><br/><strong>Annex</strong></title></annex>
       <annex id="A4" obligation="normative"><title><strong>Annex D</strong><br/><strong>Annex</strong></title></annex>
       <annex id="A5" obligation="normative"><title><strong>Annex E</strong><br/><strong>Annex</strong></title></annex>
       <annex id="A6" obligation="normative"><title><strong>Annex F</strong><br/><strong>Annex</strong></title></annex>
       <annex id="A7" obligation="normative"><title><strong>Annex G</strong><br/><strong>Annex</strong></title></annex>
       <annex id="A8" obligation="normative"><title><strong>Annex H</strong><br/><strong>Annex</strong></title></annex>
       <annex id="A9" obligation="normative"><title><strong>Annex J</strong><br/><strong>Annex</strong></title></annex>
       <annex id="A10" obligation="normative"><title><strong>Annex K</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B1" obligation="informative"><title><strong>Appendix 1</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B2" obligation="informative"><title><strong>Appendix 2</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B3" obligation="informative"><title><strong>Appendix 3</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B4" obligation="informative"><title><strong>Appendix 4</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B5" obligation="informative"><title><strong>Appendix 5</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B6" obligation="informative"><title><strong>Appendix 6</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B7" obligation="informative"><title><strong>Appendix 7</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B8" obligation="informative"><title><strong>Appendix 8</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B9" obligation="informative"><title><strong>Appendix 9</strong><br/><strong>Annex</strong></title></annex>
       <annex id="B10" obligation="informative"><title><strong>Appendix 10</strong><br/><strong>Annex</strong></title></annex>
       </iho-standard>
OUTPUT

html = <<~OUTPUT
            #{HTML_HDR}
            <br/>
            <div>
                  <h1 class='AbstractTitle'>Abstract</h1>
      <a href='#A1'>Annex A</a>
      <a href='#B1'>Appendix 1</a>
    </div>
    <p class='zzSTDTitle1'>An ITU Standard</p>
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
    expect(xmlpp(IsoDoc::IHO::PresentationXMLConvert.new({}).convert("test", input, true))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::IHO::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
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

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</iho-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :iho, header_footer: true)))).to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
  end

    it "cross-references sections" do
      expect(xmlpp(IsoDoc::IHO::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      <iho-standard xmlns="http://riboseinc.com/isoxml">
      <preface>
      <foreword obligation="informative">
         <title>Foreword</title>
         <p id="A">This is a preamble
         <xref target="C"/>
         <xref target="C1"/>
         <xref target="D"/>
         <xref target="H"/>
         <xref target="I"/>
         <xref target="J"/>
         <xref target="K"/>
         <xref target="L"/>
         <xref target="M"/>
         <xref target="N"/>
         <xref target="O"/>
         <xref target="P"/>
         <xref target="Q"/>
         <xref target="Q1"/>
         <xref target="Q2"/>
         <xref target="PP"/>
         <xref target="QQ"/>
         <xref target="QQ1"/>
         <xref target="QQ2"/>
         <xref target="R"/>
         </p>
       </foreword>
        <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
         <title>Introduction Subsection</title>
       </clause>
       <clause id="C1" inline-header="false" obligation="informative">Text</clause>
       </introduction></preface><sections>
       <clause id="D" obligation="normative" type="scope">
         <title>Scope</title>
         <p id="E">Text</p>
       </clause>

       <terms id="H" obligation="normative"><title>Terms, definitions, symbols and abbreviated terms</title><terms id="I" obligation="normative">
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
       </terms>
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
              <appendix id="Q2" inline-header="false" obligation="normative">
         <title>An Appendix</title>
       </appendix>
       </annex>
<annex id="PP" inline-header="false" obligation="informative">
         <title>Annex</title>
         <clause id="QQ" inline-header="false" obligation="normative">
         <title>Annex A.1</title>
         <clause id="QQ1" inline-header="false" obligation="normative">
         <title>Annex A.1a</title>
         </clause>
       </clause>
              <appendix id="QQ2" inline-header="false" obligation="normative">
         <title>An Appendix</title>
       </appendix>
       </annex>
        <bibliography><references id="R" obligation="informative" normative="true">
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
    <iho-standard xmlns='http://riboseinc.com/isoxml'>
         <preface>
           <foreword obligation='informative'>
             <title>Foreword</title>
             <p id='A'>
               This is a preamble
               <xref target='C'>Introduction Subsection</xref>
               <xref target='C1'>Introduction, 2</xref>
               <xref target='D'>Clause 1</xref>
               <xref target='H'>Clause 3</xref>
               <xref target='I'>Clause 3.1</xref>
               <xref target='J'>Clause 3.1.1</xref>
               <xref target='K'>Clause 3.2</xref>
               <xref target='L'>Clause 4</xref>
               <xref target='M'>Clause 5</xref>
               <xref target='N'>Clause 5.1</xref>
               <xref target='O'>Clause 5.2</xref>
               <xref target='P'>Annex A</xref>
               <xref target='Q'>Annex A.1</xref>
               <xref target='Q1'>Annex A.1.1</xref>
               <xref target='Q2'>Annex A, Appendix 1</xref>
               <xref target='PP'>Appendix 1</xref>
               <xref target='QQ'>Appendix 1.1</xref>
               <xref target='QQ1'>Appendix 1.1.1</xref>
               <xref target='QQ2'>Appendix 1, Appendix 1</xref>
               <xref target='R'>Clause 2</xref>
             </p>
           </foreword>
           <introduction id='B' obligation='informative'>
             <title>Introduction</title>
             <clause id='C' inline-header='false' obligation='informative'>
               <title depth='2'>Introduction Subsection</title>
             </clause>
             <clause id='C1' inline-header='false' obligation='informative'>Text</clause>
           </introduction>
         </preface>
         <sections>
           <clause id='D' obligation='normative' type='scope'>
             <title depth='1'>
               1.
               <tab/>
               Scope
             </title>
             <p id='E'>Text</p>
           </clause>
           <terms id='H' obligation='normative'>
             <title depth='1'>
               3.
               <tab/>
               Terms, definitions, symbols and abbreviated terms
             </title>
             <terms id='I' obligation='normative'>
               <title depth='2'>
                 3.1.
                 <tab/>
                 Normal Terms
               </title>
               <term id='J'>
                 <name>3.1.1.</name>
                 <preferred>Term2</preferred>
               </term>
             </terms>
             <definitions id='K'>
               <title>3.2.</title>
               <dl>
                 <dt>Symbol</dt>
                 <dd>Definition</dd>
               </dl>
             </definitions>
           </terms>
           <definitions id='L'>
             <title>4.</title>
             <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
             </dl>
           </definitions>
           <clause id='M' inline-header='false' obligation='normative'>
             <title depth='1'>
               5.
               <tab/>
               Clause 4
             </title>
             <clause id='N' inline-header='false' obligation='normative'>
               <title depth='2'>
                 5.1.
                 <tab/>
                 Introduction
               </title>
             </clause>
             <clause id='O' inline-header='false' obligation='normative'>
               <title depth='2'>
                 5.2.
                 <tab/>
                 Clause 4.2
               </title>
             </clause>
           </clause>
         </sections>
         <annex id='P' inline-header='false' obligation='normative'>
           <title>
             <strong>Annex A</strong>
             <br/>
             <strong>Annex</strong>
           </title>
           <clause id='Q' inline-header='false' obligation='normative'>
             <title depth='2'>
               A.1.
               <tab/>
               Annex A.1
             </title>
             <clause id='Q1' inline-header='false' obligation='normative'>
               <title depth='3'>
                 A.1.1.
                 <tab/>
                 Annex A.1a
               </title>
             </clause>
           </clause>
           <appendix id='Q2' inline-header='false' obligation='normative'>
             <title>An Appendix</title>
           </appendix>
         </annex>
         <annex id='PP' inline-header='false' obligation='informative'>
           <title>
             <strong>Appendix 1</strong>
             <br/>
             <strong>Annex</strong>
           </title>
           <clause id='QQ' inline-header='false' obligation='normative'>
             <title depth='2'>
               1.1.
               <tab/>
               Annex A.1
             </title>
             <clause id='QQ1' inline-header='false' obligation='normative'>
               <title depth='3'>
                 1.1.1.
                 <tab/>
                 Annex A.1a
               </title>
             </clause>
           </clause>
           <appendix id='QQ2' inline-header='false' obligation='normative'>
             <title>An Appendix</title>
           </appendix>
         </annex>
         <bibliography>
           <references id='R' obligation='informative' normative='true'>
             <title depth='1'>
               2.
               <tab/>
               Normative References
             </title>
           </references>
           <clause id='S' obligation='informative'>
             <title depth='1'>Bibliography</title>
             <references id='T' obligation='informative' normative='false'>
               <title depth='2'>Bibliography Subsection</title>
             </references>
           </clause>
         </bibliography>
       </iho-standard>
    OUTPUT
  end


end

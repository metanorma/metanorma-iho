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
   {:accesseddate=>"XXX", :agency=>"Ribose", :authors=>[], :authors_affiliations=>{}, :circulateddate=>"XXX", :comment_from=>"2010", :comment_to=>"2011", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"XXX", :docnumber=>"1000(wd)", :docnumeric=>"1000", :doctitle=>"Main Title", :doctype=>"Standard", :docyear=>"2001", :draft=>"3.4", :draftinfo=>" (draft 3.4, 2000-01-01)", :edition=>"2", :implementeddate=>"2000-01-01", :issueddate=>"XXX", :logo=>"#{File.join(logoloc, 'logo.png')}", :logo_paths=>["#{File.join(logoloc, 'image001.png')}", "#{File.join(logoloc, 'image002.png')}", "#{File.join(logoloc, 'image003.png')}"], :obsoleteddate=>"2001-01-01", :publisheddate=>"XXX", :publisher=>"Ribose", :receiveddate=>"XXX", :revdate=>"2000-01-01", :revdate_monthyear=>"January 2000", :series=>"Bathymetric", :seriesabbr=>"B", :stage=>"Working Draft", :stageabbr=>nil, :tc=>"TC", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>true, :updateddate=>"XXX", :vote_endeddate=>"XXX", :vote_starteddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s)).to be_equivalent_to output
  end

  it "processes section names" do
    input = <<~"INPUT"
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

    output = xmlpp(<<~"OUTPUT")
        #{HTML_HDR}
             <br/>
             <div>
               <h1 class="ForewordTitle">Foreword</h1>
               <p id="A">This is a preamble</p>
             </div>
             <br/>
             <div class="Section3" id="B">
               <h1 class="IntroTitle">Introduction</h1>
               <div id="C">
          <h2>Introduction Subsection</h2>
        </div>
             </div>
             <p class="zzSTDTitle1"/>
             <div id="D">
               <h1>1.&#160; Scope</h1>
               <p id="E">Text</p>
             </div>
             <div>
               <h1>2.&#160; Normative references</h1>
             </div>
             <div id="H"><h1>3.&#160; Terms, definitions, symbols and abbreviated terms</h1>
       <div id="I">
          <h2>3.1.&#160; Normal Terms</h2>
          <p class="TermNum" id="J">3.1.1.</p>
          <p class="Terms" style="text-align:left;">Term2</p>

        </div><div id="K"><h2>3.2.&#160; Symbols and abbreviated terms</h2>
          <dl><dt><p>Symbol</p></dt><dd>Definition</dd></dl>
        </div></div>
             <div id="L" class="Symbols">
               <h1>4.&#160; Symbols and abbreviated terms</h1>
               <dl>
                 <dt>
                   <p>Symbol</p>
                 </dt>
                 <dd>Definition</dd>
               </dl>
             </div>
             <div id="M">
               <h1>5.&#160; Clause 4</h1>
               <div id="N">
          <h2>5.1.&#160; Introduction</h2>
        </div>
               <div id="O">
          <h2>5.2.&#160; Clause 4.2</h2>
        </div>
             </div>
             <br/>
             <div id="P" class="Section3">
               <h1 class="Annex"><b>Annex A</b><br/><b>Annex</b></h1>
               <div id="Q">
          <h2>A.1.&#160; Annex A.1</h2>
          <div id="Q1">
          <h3>A.1.1.&#160; Annex A.1a</h3>
          </div>
        </div>
             </div>
             <br/>
             <div>
               <h1 class="Section3">Bibliography</h1>
               <div>
                 <h2 class="Section3">Bibliography Subsection</h2>
               </div>
             </div>
           </div>
         </body>
    OUTPUT

    expect(xmlpp(
      IsoDoc::IHO::HtmlConvert.new({}).convert("test", input, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
    )).to be_equivalent_to output
  end

         it "processes annexes and appendixes" do
    expect(xmlpp(IsoDoc::IHO::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
      expect(xmlpp(IsoDoc::IHO::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
       <clause id="D" obligation="normative">
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
            #{HTML_HDR}
      <br/>
      <div>
        <h1 class='ForewordTitle'>Foreword</h1>
        <p id='A'>
          This is a preamble
          <a href='#C'>Introduction Subsection</a>
          <a href='#C1'>Introduction, 2</a>
          <a href='#D'>Clause 1</a>
          <a href='#H'>Clause 3</a>
          <a href='#I'>Clause 3.1</a>
          <a href='#J'>Clause 3.1.1</a>
          <a href='#K'>Clause 3.2</a>
          <a href='#L'>Clause 4</a>
          <a href='#M'>Clause 5</a>
          <a href='#N'>Clause 5.1</a>
          <a href='#O'>Clause 5.2</a>
          <a href='#P'>Annex A</a>
          <a href='#Q'>Annex A.1</a>
          <a href='#Q1'>Annex A.1.1</a>
          <a href='#Q2'>Annex A, Appendix 1</a>
          <a href='#PP'>Appendix 1</a>
<a href='#QQ'>Appendix 1.1</a>
<a href='#QQ1'>Appendix 1.1.1</a>
<a href='#QQ2'>Appendix 1, Appendix 1</a>
          <a href='#R'>Clause 2</a>
        </p>
      </div>
      <br/>
      <div class='Section3' id='B'>
        <h1 class='IntroTitle'>Introduction</h1>
        <div id='C'>
          <h2>Introduction Subsection</h2>
        </div>
        <div id='C1'>
          <h2/>
          Text
        </div>
      </div>
      <p class='zzSTDTitle1'/>
      <div id='D'>
        <h1>1.&#160; Scope</h1>
        <p id='E'>Text</p>
      </div>
      <div>
        <h1>2.&#160; Normative references</h1>
      </div>
      <div id='H'>
        <h1>3.&#160; Terms, definitions, symbols and abbreviated terms</h1>
        <div id='I'>
          <h2>3.1.&#160; Normal Terms</h2>
          <p class='TermNum' id='J'>3.1.1.</p>
          <p class='Terms' style='text-align:left;'>Term2</p>
        </div>
        <div id='K'>
          <h2>3.2.&#160; Symbols and abbreviated terms</h2>
          <dl>
            <dt>
              <p>Symbol</p>
            </dt>
            <dd>Definition</dd>
          </dl>
        </div>
      </div>
      <div id='L' class='Symbols'>
        <h1>4.&#160; Symbols and abbreviated terms</h1>
        <dl>
          <dt>
            <p>Symbol</p>
          </dt>
          <dd>Definition</dd>
        </dl>
      </div>
      <div id='M'>
        <h1>5.&#160; Clause 4</h1>
        <div id='N'>
          <h2>5.1.&#160; Introduction</h2>
        </div>
        <div id='O'>
          <h2>5.2.&#160; Clause 4.2</h2>
        </div>
      </div>
      <br/>
      <div id='P' class='Section3'>
        <h1 class='Annex'>
          <b>Annex A</b>
          <br/>
          <b>Annex</b>
        </h1>
        <div id='Q'>
          <h2>A.1.&#160; Annex A.1</h2>
          <div id='Q1'>
            <h3>A.1.1.&#160; Annex A.1a</h3>
          </div>
        </div>
        <div id='Q2'>
  <h2>Appendix 1.&#160; An Appendix</h2>
</div>
      </div>
      <br/>
       <div id='PP' class='Section3'>
   <h1 class='Annex'>
     <b>Appendix 1</b>
     <br/>
     <b>Annex</b>
   </h1>
   <div id='QQ'>
     <h2>1.1.&#160; Annex A.1</h2>
     <div id='QQ1'>
       <h3>1.1.1.&#160; Annex A.1a</h3>
     </div>
   </div>
   <div id='QQ2'>
     <h2>Appendix 1.&#160; An Appendix</h2>
   </div>
 </div>
<br/>
      <div>
        <h1 class='Section3'>Bibliography</h1>
        <div>
          <h2 class='Section3'>Bibliography Subsection</h2>
        </div>
      </div>
    </div>
  </body>
    OUTPUT
  end


end

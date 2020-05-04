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
  <ext>
  <doctype>standard</doctype>
  <editorialgroup>
    <committee type="A">TC</committee>
  </editorialgroup>
  <security>Client Confidential</security>
  </ext>
</bibdata>
<sections/>
</iho-standard>
    INPUT

    output = <<~"OUTPUT"
   {:accesseddate=>"XXX", :agency=>"Ribose", :authors=>[], :authors_affiliations=>{}, :circulateddate=>"XXX", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"XXX", :docnumber=>"1000(wd)", :docnumeric=>"1000", :doctitle=>"Main Title", :doctype=>"Standard", :docyear=>"2001", :draft=>"3.4", :draftinfo=>" (draft 3.4, 2000-01-01)", :edition=>"2", :implementeddate=>"XXX", :issueddate=>"XXX", :logo=>"#{File.join(logoloc, "logo.png")}", :obsoleteddate=>"XXX", :publisheddate=>"XXX", :publisher=>"Ribose", :receiveddate=>"XXX", :revdate=>"2000-01-01", :revdate_MMMddyyyy=>"January 01, 2000", :revdate_monthyear=>"January 2000", :security=>"Client Confidential", :stage=>"Working Draft", :stageabbr=>"wd", :tc=>"TC", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>true, :updateddate=>"XXX", :vote_endeddate=>"XXX", :vote_starteddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s)).to be_equivalent_to output
  end

  it "processes pre" do
    input = <<~"INPUT"
<iho-standard xmlns="https://open.ribose.com/standards/iho">
<preface><foreword>
<pre>ABC</pre>
</foreword></preface>
</iho-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{HTML_HDR}
             <br/>
             <div>
               <h1 class="ForewordTitle">Foreword</h1>
               <pre>ABC</pre>
             </div>
             <p class="zzSTDTitle1"/>
           </div>
         </body>
    OUTPUT

    expect(xmlpp(
      IsoDoc::IHO::HtmlConvert.new({}).
      convert("test", input, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
    )).to be_equivalent_to output
  end

  it "processes keyword" do
    input = <<~"INPUT"
<iho-standard xmlns="https://open.ribose.com/standards/iho">
<preface><foreword>
<keyword>ABC</keyword>
</foreword></preface>
</iho-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
        #{HTML_HDR}
             <br/>
             <div>
               <h1 class="ForewordTitle">Foreword</h1>
               <span class="keyword">ABC</span>
             </div>
             <p class="zzSTDTitle1"/>
           </div>
         </body>
    OUTPUT

    expect(xmlpp(
      IsoDoc::IHO::HtmlConvert.new({}).
      convert("test", input, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
    )).to be_equivalent_to output
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
       </annex><bibliography><references id="R" obligation="informative">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative">
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
<div class='Section3' id='A1'>
  <h1 class='IntroTitle'>Executive Summary</h1>
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
               <h1>1&#160; Scope</h1>
               <p id="E">Text</p>
             </div>
             <div>
               <h1>2&#160; Normative references</h1>
             </div>
             <div id="H"><h1>3&#160; Terms, definitions, symbols and abbreviated terms</h1>
       <div id="I">
          <h2>3.1&#160; Normal Terms</h2>
          <p class="TermNum" id="J">3.1.1</p>
          <p class="Terms" style="text-align:left;">Term2</p>

        </div><div id="K"><h2>3.2&#160; Symbols and abbreviated terms</h2>
          <dl><dt><p>Symbol</p></dt><dd>Definition</dd></dl>
        </div></div>
             <div id="L" class="Symbols">
               <h1>4&#160; Symbols and abbreviated terms</h1>
               <dl>
                 <dt>
                   <p>Symbol</p>
                 </dt>
                 <dd>Definition</dd>
               </dl>
             </div>
             <div id="M">
               <h1>5&#160; Clause 4</h1>
               <div id="N">
          <h2>5.1&#160; Introduction</h2>
        </div>
               <div id="O">
          <h2>5.2&#160; Clause 4.2</h2>
        </div>
             </div>
             <br/>
             <div id="P" class="Section3">
               <h1 class="Annex">Annex A<br/>(normative) <br/><br/>Annex</h1>
               <div id="Q">
          <h2>A.1&#160; Annex A.1</h2>
          <div id="Q1">
          <h3>A.1.1&#160; Annex A.1a</h3>
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
    expect(html).to match(%r{Source Sans Pro})
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
       </annex><bibliography><references id="R" obligation="informative">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative">
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
          <a href='#I'>3.1</a>
          <a href='#J'>3.1.1</a>
          <a href='#K'>3.2</a>
          <a href='#L'>Clause 4</a>
          <a href='#M'>Clause 5</a>
          <a href='#N'>5.1</a>
          <a href='#O'>5.2</a>
          <a href='#P'>Annex A</a>
          <a href='#Q'>Annex A.1</a>
          <a href='#Q1'>Annex A.1.1</a>
          <a href='#Q2'>[Q2]</a>
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
        <h1>1&#160; Scope</h1>
        <p id='E'>Text</p>
      </div>
      <div>
        <h1>2&#160; Normative references</h1>
      </div>
      <div id='H'>
        <h1>3&#160; Terms, definitions, symbols and abbreviated terms</h1>
        <div id='I'>
          <h2>3.1&#160; Normal Terms</h2>
          <p class='TermNum' id='J'>3.1.1</p>
          <p class='Terms' style='text-align:left;'>Term2</p>
        </div>
        <div id='K'>
          <h2>3.2&#160; Symbols and abbreviated terms</h2>
          <dl>
            <dt>
              <p>Symbol</p>
            </dt>
            <dd>Definition</dd>
          </dl>
        </div>
      </div>
      <div id='L' class='Symbols'>
        <h1>4&#160; Symbols and abbreviated terms</h1>
        <dl>
          <dt>
            <p>Symbol</p>
          </dt>
          <dd>Definition</dd>
        </dl>
      </div>
      <div id='M'>
        <h1>5&#160; Clause 4</h1>
        <div id='N'>
          <h2>5.1&#160; Introduction</h2>
        </div>
        <div id='O'>
          <h2>5.2&#160; Clause 4.2</h2>
        </div>
      </div>
      <br/>
      <div id='P' class='Section3'>
        <h1 class='Annex'>
          Annex A
          <br/>
          (normative)
          <br/>
          <br/>
          Annex
        </h1>
        <div id='Q'>
          <h2>A.1&#160; Annex A.1</h2>
          <div id='Q1'>
            <h3>A.1.1&#160; Annex A.1a</h3>
          </div>
        </div>
        <para>
          <b role='strong'>
            &lt;appendix id="Q2" inline-header="false"
            obligation="normative"&gt; &lt;title&gt;An Appendix&lt;/title&gt;
            &lt;/appendix&gt;
          </b>
        </para>
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

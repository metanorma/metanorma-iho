require "spec_helper"

RSpec.describe IsoDoc do
    it "processes IsoXML terms" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
          <p>For the purposes of this document, the following terms and definitions apply.</p>
      <term id="paddy1"><preferred><expression><name>paddy</name></expression>
      <field-of-application>in agriculture</field-of-application>
      <usage-info>dated</usage-info>
            <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
      </preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f892"  keep-with-next="true" keep-lines-together="true">
        <p id="_65c9a509-9a89-4b54-a890-274126aeb55c">Foreign seeds, husks, bran, sand, dust.</p>
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f894">
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termsource status='identical'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
          <modification>
            <p id='_'>comment</p>
          </modification>
        </termsource>
        <termsource status='modified'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'/>
          </origin>
          <modification>
            <p id='_'>with adjustments</p>
          </modification>
        </termsource>
      </term>
      <term id="paddy"><preferred><expression><name>paddy</name></expression></preferred>
      <admitted><letter-symbol><name>paddy rice</name></letter-symbol>
      <field-of-application>in agriculture</field-of-application>
      </admitted>
      <admitted><expression><name>rough rice</name></expression></admitted>
      <deprecates><expression><name>cargo rice</name></expression></deprecates>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f893">
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74e"  keep-with-next="true" keep-lines-together="true">
        <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
      </termnote>
      <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74f">
      <ul><li>A</li></ul>
        <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
      </termnote>
      <termsource status="identical">
        <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
        <origin bibitemid="ISO7301" type="inline" case="lowercase" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
      </termsource></term>
      </terms>
      </sections>
      </iso-standard>
    INPUT
    presxml = <<~PRESXML
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
        <preface>
          <clause type="toc" id="_" displayorder="1">
            <title depth="1">Contents</title>
          </clause>
        </preface>
                  <sections>
             <terms id="_" obligation="normative" displayorder="2">
                <title depth="1">
                   1
                   <tab/>
                   Terms and Definitions
                </title>
                <p>For the purposes of this document, the following terms and definitions apply.</p>
                <term id="paddy1">
                   <preferred>
                      <strong>paddy</strong>
                      , &lt;in agriculture, dated&gt;
                   </preferred>
                   <domain hidden="true">rice</domain>
                   <definition>
                      <p id="_">
                         &lt;
                         <domain>rice</domain>
                         &gt; rice retaining its husk after threshing [
                         <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                            <locality type="clause">
                               <referenceFrom>3.1</referenceFrom>
                            </locality>
                            ISO 7301:2011, Clause 3.1
                         </origin>
                         , modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here] [
                         <origin citeas="">
                            <termref base="IEV" target="xyz">t1</termref>
                         </origin>
                         — comment ;
                         <origin citeas="">
                            <termref base="IEV" target="xyz"/>
                         </origin>
                         , modified — with adjustments]
                      </p>
                   </definition>
                   <termexample id="_" keep-with-next="true" keep-lines-together="true">
                      <name>EXAMPLE  1</name>
                      <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                      <ul>
                         <li>A</li>
                      </ul>
                   </termexample>
                   <termexample id="_">
                      <name>EXAMPLE  2</name>
                      <ul>
                         <li>A</li>
                      </ul>
                   </termexample>
                </term>
                <term id="paddy">
                   <preferred>
                      <strong>paddy</strong>
                   </preferred>
                   <admitted>paddy rice, &lt;in agriculture&gt;</admitted>
                   <admitted>rough rice</admitted>
                   <deprecates>DEPRECATED: cargo rice</deprecates>
                   <definition>
                      <p id="_">
                         rice retaining its husk after threshing [
                         <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011">
                            <locality type="clause">
                               <referenceFrom>3.1</referenceFrom>
                            </locality>
                            ISO 7301:2011, 3.1
                         </origin>
                         <origin bibitemid="ISO7301" type="inline" case="lowercase" citeas="ISO 7301:2011">
                            <locality type="clause">
                               <referenceFrom>3.1</referenceFrom>
                            </locality>
                            ISO 7301:2011, clause 3.1
                         </origin>
                         ]
                      </p>
                   </definition>
                   <termexample id="_">
                      <name>EXAMPLE</name>
                      <ul>
                         <li>A</li>
                      </ul>
                   </termexample>
                   <termnote id="_" keep-with-next="true" keep-lines-together="true">
                      <name>Note 1 to entry:</name>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                   <termnote id="_">
                      <name>Note 2 to entry:</name>
                      <ul>
                         <li>A</li>
                      </ul>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                </term>
             </terms>
          </sections>
       </iso-standard>
    PRESXML
    html = <<~"OUTPUT"
      #{HTML_HDR}
                      <div id="_">
                   <h1>
                    1
                     
                    Terms and Definitions
                 </h1>
                   <p>For the purposes of this document, the following terms and definitions apply.</p>
                   <p class="TermNum" id="paddy1"/>
                   <p class="Terms" style="text-align:left;">
                      <b>paddy</b>
                      , &lt;in agriculture, dated&gt;
                   </p>
                   <p id="_">
                          &lt;
                          rice
                          &gt; rice retaining its husk after threshing [


                             ISO 7301:2011, Clause 3.1

                          , modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here] [
                          t1
                          — comment ;
                          Termbase IEV, term ID xyz
                          , modified — with adjustments]
                       </p>
                   <div id="_" class="example" style="page-break-after: avoid;page-break-inside: avoid;">
                      <p class="example-title">EXAMPLE  1</p>
                      <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                      <div class="ul_wrap">
                         <ul>
                            <li>A</li>
                         </ul>
                      </div>
                   </div>
                   <div id="_" class="example">
                      <p class="example-title">EXAMPLE  2</p>
                      <div class="ul_wrap">
                         <ul>
                            <li>A</li>
                         </ul>
                      </div>
                   </div>
                   <p class="TermNum" id="paddy"/>
                   <p class="Terms" style="text-align:left;">
                      <b>paddy</b>
                   </p>
                   <p class="AltTerms" style="text-align:left;">paddy rice, &lt;in agriculture&gt;</p>
                   <p class="AltTerms" style="text-align:left;">rough rice</p>
                   <p class="DeprecatedTerms" style="text-align:left;">DEPRECATED: cargo rice</p>
                   <p id="_">
                          rice retaining its husk after threshing [


                             ISO 7301:2011, 3.1



                             ISO 7301:2011, clause 3.1

                          ]
                       </p>
                   <div id="_" class="example">
                      <p class="example-title">EXAMPLE</p>
                      <div class="ul_wrap">
                         <ul>
                            <li>A</li>
                         </ul>
                      </div>
                   </div>
                   <div id="_" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
                      <p>Note 1 to entry: The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </div>
                   <div id="_" class="Note">
                      <p>
                         Note 2 to entry:
                         <div class="ul_wrap">
                            <ul>
                               <li>A</li>
                            </ul>
                         </div>
                         <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                      </p>
                   </div>
                </div>
             </div>
          </body>
       </html>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::Iho::HtmlConvert.new({})
      .convert("test", presxml, true)))
      .to be_equivalent_to Xml::C14n.format(html)
    end
end
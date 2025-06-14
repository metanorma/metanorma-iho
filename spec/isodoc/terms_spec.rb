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
            <source status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </source>
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
      <source status='identical'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
          <modification>
            <p id='_'>comment</p>
          </modification>
        </source>
        <source status='modified'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'/>
          </origin>
          <modification>
            <p id='_'>with adjustments</p>
          </modification>
        </source>
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
      <source status="identical">
        <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
        <origin bibitemid="ISO7301" type="inline" case="lowercase" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
      </source></term>
      </terms>
      </sections>
      </iso-standard>
    INPUT
    presxml = <<~PRESXML
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1" id="_">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <terms id="_" obligation="normative" displayorder="2">
                <title id="_">Terms and Definitions</title>
                <fmt-title depth="1" id="_">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms and Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Section</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <p>For the purposes of this document, the following terms and definitions apply.</p>
                <term id="paddy1">
                   <preferred id="_">
                      <expression>
                         <name>paddy</name>
                      </expression>
                      <field-of-application id="_">in agriculture</field-of-application>
                      <usage-info id="_">dated</usage-info>
                      <source status="modified" id="_">
                         <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                            <locality type="clause">
                               <referenceFrom>3.1</referenceFrom>
                            </locality>
                         </origin>
                         <modification id="_">
                            <p id="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
                         </modification>
                      </source>
                   </preferred>
                   <fmt-preferred>
                      <p>
                         <semx element="preferred" source="_">
                            <strong>paddy</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="field-of-application" source="_">in agriculture</semx>
                               ,
                               <semx element="usage-info" source="_">dated</semx>
                               &gt;
                            </span>
                         </semx>
                         [
                         <semx element="source" source="_">
                            <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                                  <locality type="clause">
                                     <referenceFrom>3.1</referenceFrom>
                                  </locality>
                                  ISO 7301:2011, Clause 3.1
                               </fmt-origin>
                            </semx>
                            , modified —
                            <semx element="modification" source="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</semx>
                         </semx>
                         ]
                      </p>
                   </fmt-preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p original-id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <semx element="definition" source="_">
                         <p id="_">
                            &lt;
                            <semx element="domain" source="_">rice</semx>
                            &gt; rice retaining its husk after threshing
                         </p>
                         [
                         <semx element="source" source="_">
                            <origin citeas="" id="_">
                               <termref base="IEV" target="xyz">t1</termref>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin citeas="">
                                  <termref base="IEV" target="xyz">t1</termref>
                               </fmt-origin>
                            </semx>
                            —
                            <semx element="modification" source="_">comment</semx>
                         </semx>
                         ;
                         <semx element="source" source="_">
                            <origin citeas="" id="_">
                               <termref base="IEV" target="xyz"/>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin citeas="">
                                  <termref base="IEV" target="xyz"/>
                               </fmt-origin>
                            </semx>
                            , modified —
                            <semx element="modification" source="_">with adjustments</semx>
                         </semx>
                         ]
                      </semx>
                   </fmt-definition>
                   <termexample id="_" keep-with-next="true" keep-lines-together="true" autonum="1">
                      <fmt-name id="_">
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">EXAMPLE</span>
                            <semx element="autonum" source="_">1</semx>
                         </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">•</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <termexample id="_" autonum="2">
                      <fmt-name id="_">
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">EXAMPLE</span>
                            <semx element="autonum" source="_">2</semx>
                         </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">•</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <source status="identical" id="_">
                      <origin citeas="">
                         <termref base="IEV" target="xyz">t1</termref>
                      </origin>
                      <modification id="_">
                         <p id="_">comment</p>
                      </modification>
                   </source>
                   <source status="modified" id="_">
                      <origin citeas="">
                         <termref base="IEV" target="xyz"/>
                      </origin>
                      <modification id="_">
                         <p original-id="_">with adjustments</p>
                      </modification>
                   </source>
                </term>
                <term id="paddy">
                   <preferred id="_">
                      <expression>
                         <name>paddy</name>
                      </expression>
                   </preferred>
                   <fmt-preferred>
                      <p>
                         <semx element="preferred" source="_">
                            <strong>paddy</strong>
                         </semx>
                      </p>
                   </fmt-preferred>
                   <admitted id="_">
                      <letter-symbol>
                         <name>paddy rice</name>
                      </letter-symbol>
                      <field-of-application id="_">in agriculture</field-of-application>
                   </admitted>
                   <admitted id="_">
                      <expression>
                         <name>rough rice</name>
                      </expression>
                   </admitted>
                   <fmt-admitted>
                      <p>
                         <semx element="admitted" source="_">
                            paddy rice
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="field-of-application" source="_">in agriculture</semx>
                               &gt;
                            </span>
                         </semx>
                      </p>
                      <p>
                         <semx element="admitted" source="_">rough rice</semx>
                      </p>
                   </fmt-admitted>
                   <deprecates id="_">
                      <expression>
                         <name>cargo rice</name>
                      </expression>
                   </deprecates>
                   <fmt-deprecates>
                      <p>
                         DEPRECATED:
                         <semx element="deprecates" source="_">cargo rice</semx>
                      </p>
                   </fmt-deprecates>
                   <definition id="_">
                      <verbal-definition>
                         <p original-id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <semx element="definition" source="_">
                         <p id="_">rice retaining its husk after threshing</p>
                         [
                         <semx element="source" source="_">
                            <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011" id="_">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011">
                                  <locality type="clause">
                                     <referenceFrom>3.1</referenceFrom>
                                  </locality>
                                  ISO 7301:2011, 3.1
                               </fmt-origin>
                            </semx>
                            <origin bibitemid="ISO7301" type="inline" case="lowercase" citeas="ISO 7301:2011" id="_">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin bibitemid="ISO7301" type="inline" case="lowercase" citeas="ISO 7301:2011">
                                  <locality type="clause">
                                     <referenceFrom>3.1</referenceFrom>
                                  </locality>
                                  ISO 7301:2011, clause 3.1
                               </fmt-origin>
                            </semx>
                         </semx>
                         ]
                      </semx>
                   </fmt-definition>
                   <termexample id="_" autonum="">
                      <fmt-name id="_">
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">EXAMPLE</span>
                         </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                      </fmt-xref-label>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">•</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <termnote id="_" keep-with-next="true" keep-lines-together="true" autonum="1">
                      <fmt-name id="_">
                         <span class="fmt-caption-label">
                            Note
                            <semx element="autonum" source="_">1</semx>
                            to entry
                         </span>
                         <span class="fmt-label-delim">: </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                   <termnote id="_" autonum="2">
                      <fmt-name id="_">
                         <span class="fmt-caption-label">
                            Note
                            <semx element="autonum" source="_">2</semx>
                            to entry
                         </span>
                         <span class="fmt-label-delim">: </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">•</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                   <source status="identical" id="_">
                      <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011">
                         <locality type="clause">
                            <referenceFrom>3.1</referenceFrom>
                         </locality>
                      </origin>
                      <origin bibitemid="ISO7301" type="inline" case="lowercase" citeas="ISO 7301:2011">
                         <locality type="clause">
                            <referenceFrom>3.1</referenceFrom>
                         </locality>
                      </origin>
                   </source>
                </term>
             </terms>
          </sections>
       </iso-standard>
    PRESXML
    html = <<~"OUTPUT"
      #{HTML_HDR}
            <br/>
             <div id="_" class="TOC">
                <h1 class="IntroTitle">Contents</h1>
             </div>
             <div id="_">
                <h1>1  Terms and Definitions</h1>
                <p>For the purposes of this document, the following terms and definitions apply.</p>
                <p class="TermNum" id="paddy1"/>
                <p class="Terms" style="text-align:left;">
                   <b>paddy</b>
                   , &lt;in agriculture, dated&gt; [ISO 7301:2011, Clause 3.1, modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here]
                </p>
                <p id="_">&lt;rice&gt;  rice retaining its husk after threshing</p>
                [t1 — comment; Termbase IEV, term ID xyz, modified — with adjustments]
                <div id="_" class="example" style="page-break-after: avoid;page-break-inside: avoid;">
                   <p class="example-title">EXAMPLE 1</p>
                   <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                </div>
                <div id="_" class="example">
                   <p class="example-title">EXAMPLE 2</p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
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
                <p id="_">rice retaining its husk after threshing</p>
                [ISO 7301:2011, 3.1ISO 7301:2011, clause 3.1]
                <div id="_" class="example">
                   <p class="example-title">EXAMPLE</p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                </div>
                <div id="_" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
                   <p>
                      <span class="termnote_label">Note 1 to entry: </span>
                      The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.
                   </p>
                </div>
                <div id="_" class="Note">
                   <p>
                      <span class="termnote_label">Note 2 to entry: </span>
                   </p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                   <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                </div>
             </div>
          </div>
       </body>
    OUTPUT
    pres_output = IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(IsoDoc::Iho::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))))
      .to be_equivalent_to Xml::C14n.format(html)
    end
end

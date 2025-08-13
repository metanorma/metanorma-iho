require "spec_helper"

RSpec.describe IsoDoc do
  it "cross-references notes" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          <xref target="AAN"/>
          <xref target="AAnote1"/>
          <xref target="AAnote2"/>
          <xref target="Anote3"/>
          </p>
          </foreword>
          <introduction id="intro">
          <note id="N1">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83e">These results are based on a study carried out on three different types of kernel.</p>
      </note>
      <clause id="xyz"><title>Preparatory</title>
          <note id="N2">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83d">These results are based on a study carried out on three different types of kernel.</p>
      </note>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <note id="N">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </note>
      <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <note id="note1">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          <note id="note2">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </note>
      <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
          <note id="AN">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          </clause>
          <clause id="annex1b">
          <note id="Anote1">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          <note id="Anote2">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
          <note id="AAN">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          </clause>
          <clause id="annex11b">
          <note id="AAnote1">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          <note id="AAnote2">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <note id="Anote3">
            <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
          </note>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
       <foreword id="_" displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-xref-container">
                      <semx element="introduction" source="intro">Introduction</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-xref-container">
                      <semx element="clause" source="xyz">Preparatory</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                </fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="scope">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="widgets">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="widgets1">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                   <semx element="autonum" source="note1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="widgets">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="widgets1">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                   <semx element="autonum" source="note2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="annex1">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex1a">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="annex1">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex1b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                   <semx element="autonum" source="Anote1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="annex1">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex1b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                   <semx element="autonum" source="Anote2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="AAN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAN">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="annex11">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex11a">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                </fmt-xref>
             </semx>
             <xref target="AAnote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote1">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="annex11">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex11b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                   <semx element="autonum" source="AAnote1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote2">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="annex11">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex11b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                   <semx element="autonum" source="AAnote2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote3">
                   <span class="fmt-xref-container">
                      <semx element="references" source="biblio">Bibliographical Section</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Note</span>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references box admonitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata><language>en</language></bibdata>
          <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N3"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          <xref target="AAN"/>
          <xref target="AAnote1"/>
          <xref target="AAnote2"/>
          <xref target="Anote3"/>
          </p>
          </foreword>
          <introduction id="intro">
          <admonition type="box" id="N1">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83e">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
      <clause id="xyz"><title>Preparatory</title>
          <admonition type="box" id="N2">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83d">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
      <admonition type="tip" id="N3">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83d">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <admonition type="box" id="N">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
      <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <admonition type="box" id="note1">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
          <admonition type="box" id="note2">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
      <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
          <admonition type="box" id="AN">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
          </clause>
          <clause id="annex1b">
          <admonition type="box" id="Anote1">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
          <admonition type="box" id="Anote2">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
          <admonition type="box" id="AAN">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
          </clause>
          <clause id="annex11b">
          <admonition type="box" id="AAnote1">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
          <admonition type="box" id="AAnote2">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </admonition>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <admonition type="box" id="Anote3">
            <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
          </admonition>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword id="_" displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-xref-container">
                      <semx element="introduction" source="intro">Introduction</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-xref-container">
                      <semx element="clause" source="xyz">Preparatory</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                </fmt-xref>
             </semx>
             <xref target="N3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N3">[N3]</fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="scope">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="widgets">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="widgets1">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                   <semx element="autonum" source="note1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="widgets">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="widgets1">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                   <semx element="autonum" source="note2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="annex1">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex1a">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="annex1">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex1b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                   <semx element="autonum" source="Anote1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="annex1">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex1b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                   <semx element="autonum" source="Anote2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="AAN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAN">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="annex11">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex11a">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                </fmt-xref>
             </semx>
             <xref target="AAnote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote1">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="annex11">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex11b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                   <semx element="autonum" source="AAnote1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote2">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="annex11">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex11b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                   <semx element="autonum" source="AAnote2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote3">
                   <span class="fmt-xref-container">
                      <semx element="references" source="biblio">Bibliographical Section</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Box</span>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
       .convert("test", input, true))
       .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references figures" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
              <preface>
          <foreword id="fwd">
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note3"/>
          <xref target="note4"/>
          <xref target="note2"/>
          <xref target="note51"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          <xref target="Anote3"/>
          <xref target="AAN"/>
          <xref target="AAnote1"/>
          <xref target="AAnote2"/>
          <xref target="AAnote3"/>
          <xref target="Anote4"/>
          </p>
          </foreword>
              <introduction id="intro">
              <figure id="N1">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <clause id="xyz"><title>Preparatory</title>
              <figure id="N2" unnumbered="true">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
              <figure id="N">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
      <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
              <figure id="note1">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <figure id="note3" class="pseudocode">
        <p>pseudocode</p>
        </figure>
        <sourcecode id="note4"><name>Source! Code!</name>
        A B C
        </sourcecode>
        <example id="note5">
        <sourcecode id="note51">
        A B C
        </sourcecode>
        </example>
          <figure id="note2">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
              <figure id="AN">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          </clause>
          <clause id="annex1b">
              <figure id="Anote1" unnumbered="true">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          <figure id="Anote2">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <sourcecode id="Anote3"><name>Source! Code!</name>
        A B C
        </sourcecode>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
              <figure id="AAN">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          </clause>
          <clause id="annex11b">
              <figure id="AAnote1" unnumbered="true">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          <figure id="AAnote2">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <sourcecode id="AAnote3"><name>Source! Code!</name>
        A B C
        </sourcecode>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <figure id="Anote4">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword id="fwd" displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-xref-container">
                      <semx element="introduction" source="intro">Introduction</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="N1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-xref-container">
                      <semx element="clause" source="xyz">Preparatory</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="N2">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="scope">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="N">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note3">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note3">2</semx>
                </fmt-xref>
             </semx>
             <xref target="note4" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note4">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note4">3</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note2">4</semx>
                </fmt-xref>
             </semx>
             <xref target="note51" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note51">[note51]</fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex1">Appendix 1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="Anote1">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex1">Appendix 1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="Anote2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote3">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex1">Appendix 1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="Anote3">3</semx>
                </fmt-xref>
             </semx>
             <xref target="AAN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAN">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex11">A</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote1">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="AAnote1">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote2">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex11">A</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAnote2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote3">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex11">A</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAnote3">3</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote4" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote4">
                   <span class="fmt-xref-container">
                      <semx element="references" source="biblio">Bibliographical Section</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="Anote4">1</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references figure classes" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
              <preface>
          <foreword id="fwd">
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note3"/>
          <xref target="note4"/>
          <xref target="note2"/>
          <xref target="note5"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          <xref target="Anote3"/>
          <xref target="AAN"/>
          <xref target="AAnote1"/>
          <xref target="AAnote2"/>
          <xref target="AAnote3"/>
          <xref target="Anote4"/>
          </p>
          </foreword>
              <introduction id="intro">
              <figure id="N1">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <clause id="xyz"><title>Preparatory</title>
              <figure id="N2" unnumbered="true">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
              <figure id="N" class="diagram">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
      <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
              <figure id="note1" class="plate">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <figure id="note3" class="pseudocode">
        <p>pseudocode</p>
        </figure>
        <sourcecode id="note4" class="diagram"><name>Source! Code!</name>
        A B C
        </sourcecode>
        <figure id="note5">
        <sourcecode id="note51">
        A B C
        </sourcecode>
        </figure>
          <figure id="note2" class="diagram">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
              <figure id="AN" class="diagram">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          </clause>
          <clause id="annex1b">
              <figure id="Anote1" unnumbered="true" class="plate">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          <figure id="Anote2">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <sourcecode id="Anote3"><name>Source! Code!</name>
        A B C
        </sourcecode>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
              <figure id="AAN" class="diagram">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          </clause>
          <clause id="annex11b">
              <figure id="AAnote1" unnumbered="true" class="plate">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          <figure id="AAnote2">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <sourcecode id="AAnote3"><name>Source! Code!</name>
        A B C
        </sourcecode>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <figure id="Anote4">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
       <foreword id="fwd" displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-xref-container">
                      <semx element="introduction" source="intro">Introduction</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="N1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-xref-container">
                      <semx element="clause" source="xyz">Preparatory</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="N2">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-element-name">Diagram</span>
                   <semx element="autonum" source="scope">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="N">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-element-name">Plate</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note3">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note3">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note4" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note4">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note4">2</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-element-name">Diagram</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note2">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note5" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note5">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note5">3</semx>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-element-name">Diagram</span>
                   <semx element="autonum" source="annex1">Appendix 1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-element-name">Plate</span>
                   <semx element="autonum" source="Anote1">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex1">Appendix 1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="Anote2">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote3">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex1">Appendix 1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="Anote3">2</semx>
                </fmt-xref>
             </semx>
             <xref target="AAN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAN">
                   <span class="fmt-element-name">Diagram</span>
                   <semx element="autonum" source="annex11">A</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote1">
                   <span class="fmt-element-name">Plate</span>
                   <semx element="autonum" source="AAnote1">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote2">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex11">A</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAnote2">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote3">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex11">A</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAnote3">2</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote4" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote4">
                   <span class="fmt-xref-container">
                      <semx element="references" source="biblio">Bibliographical Section</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="Anote4">1</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references subfigures" do
    input = <<~INPUT
            <iso-standard xmlns="http://riboseinc.com/isoxml">
            <preface>
        <foreword id="fwd">
        <p>
        <xref target="N"/>
        <xref target="note1"/>
        <xref target="note2"/>
        <xref target="AN"/>
        <xref target="Anote1"/>
        <xref target="Anote2"/>
        <xref target="AAN"/>
        <xref target="AAnote1"/>
        <xref target="AAnote2"/>
        <xref target="AN1"/>
        <xref target="Anote11"/>
        <xref target="Anote21"/>
        </p>
        </foreword>
        </preface>
        <sections>
        <clause id="scope" type="scope"><title>Scope</title>
        </clause>
        <terms id="terms"/>
        <clause id="widgets"><title>Widgets</title>
        <clause id="widgets1">
        <figure id="N">
            <figure id="note1">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
        <figure id="note2">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
      </figure>
      <p>    <xref target="note1"/> <xref target="note2"/> </p>
        </clause>
        </clause>
        </sections>
        <annex obligation='informative' id="annex1">
        <clause id="annex1a">
        </clause>
        <clause id="annex1b">
        <figure id="AN">
            <figure id="Anote1">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
        <figure id="Anote2">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
      </figure>
        </clause>
        </annex>
        <annex obligation='normative' id="annex11">
        <clause id="annex11a">
        </clause>
        <clause id="annex11b">
        <figure id="AAN">
            <figure id="AAnote1">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
        <figure id="AAnote2">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
      </figure>
        </clause>
        </annex>
                  <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
                  <figure id="AN1">
            <figure id="Anote11">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
        <figure id="Anote21">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
      </figure>
          </references></bibliography>
        </iso-standard>
    INPUT
    output = <<~OUTPUT
       <foreword id="fwd" displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="N">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="N">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="N">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="note2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex1">Appendix 1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex1">Appendix 1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AN">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="Anote1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex1">Appendix 1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AN">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="Anote2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="AAN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAN">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex11">A</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote1">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex11">A</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAN">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAnote1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AAnote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AAnote2">
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="annex11">A</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAN">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AAnote2">2</semx>
                </fmt-xref>
             </semx>
             <xref target="AN1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN1">
                   <span class="fmt-xref-container">
                      <semx element="references" source="biblio">Bibliographical Section</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="AN1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote11" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote11">
                   <span class="fmt-xref-container">
                      <semx element="references" source="biblio">Bibliographical Section</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="AN1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="Anote11">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote21" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote21">
                   <span class="fmt-xref-container">
                      <semx element="references" source="biblio">Bibliographical Section</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">Figure</span>
                   <semx element="autonum" source="AN1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="Anote21">2</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references examples" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
              <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          <xref target="AAN"/>
          <xref target="AAnote1"/>
          <xref target="AAnote2"/>
          <xref target="Anote3"/>
          </p>
          </foreword>
              <introduction id="intro">
              <example id="N1">
        <p>Hello</p>
      </example>
      <clause id="xyz"><title>Preparatory</title>
              <example id="N2" unnumbered="true">
        <p>Hello</p>
      </example>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
              <example id="N">
        <p>Hello</p>
      </example>
      <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
              <example id="note1">
        <p>Hello</p>
      </example>
              <example id="note2" unnumbered="true">
        <p>Hello <xref target="note1"/></p>
      </example>
      <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
              <example id="AN">
        <p>Hello</p>
      </example>
          </clause>
          <clause id="annex1b">
              <example id="Anote1" unnumbered="true">
        <p>Hello</p>
      </example>
              <example id="Anote2">
        <p>Hello</p>
      </example>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
              <example id="AAN">
        <p>Hello</p>
      </example>
          </clause>
          <clause id="annex11b">
              <example id="AAnote1" unnumbered="true">
        <p>Hello</p>
      </example>
              <example id="AAnote2">
        <p>Hello</p>
      </example>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <example id="Anote3">
        <p>Hello</p>
      </example>
          </references></bibliography>
          </iso-standard>
    INPUT

    output = <<~OUTPUT
        <foreword id="_" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title id="_" depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-xref-container">
                       <semx element="introduction" source="intro">Introduction</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-xref-container">
                       <semx element="clause" source="xyz">Preparatory</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                    <semx element="autonum" source="N2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Section</span>
                       <semx element="autonum" source="scope">1</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Clause</span>
                       <semx element="autonum" source="widgets">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="widgets1">1</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                    <semx element="autonum" source="note1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Clause</span>
                       <semx element="autonum" source="widgets">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="widgets1">1</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                    <semx element="autonum" source="note2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Appendix</span>
                       <semx element="autonum" source="annex1">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex1a">1</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Appendix</span>
                       <semx element="autonum" source="annex1">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex1b">2</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Appendix</span>
                       <semx element="autonum" source="annex1">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex1b">2</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                    <semx element="autonum" source="Anote2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAN">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="annex11">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex11a">1</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                 </fmt-xref>
              </semx>
              <xref target="AAnote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote1">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="annex11">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex11b">2</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                    <semx element="autonum" source="AAnote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAnote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote2">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="annex11">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex11b">2</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                    <semx element="autonum" source="AAnote2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote3">
                    <span class="fmt-xref-container">
                       <semx element="references" source="biblio">Bibliographical Section</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Example</span>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)

    output = <<~OUTPUT
       <clause id="widgets1">
          <fmt-title id="_" depth="2">
             <span class="fmt-caption-label">
                <semx element="autonum" source="widgets">3</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="widgets1">1</semx>
             </span>
          </fmt-title>
          <fmt-xref-label>
             <span class="fmt-element-name">Clause</span>
             <semx element="autonum" source="widgets">3</semx>
             <span class="fmt-autonum-delim">.</span>
             <semx element="autonum" source="widgets1">1</semx>
          </fmt-xref-label>
          <example id="note1" autonum="1">
             <fmt-name id="_">
                <span class="fmt-caption-label">
                   <span class="fmt-element-name">EXAMPLE</span>
                   <semx element="autonum" source="note1">1</semx>
                </span>
             </fmt-name>
             <fmt-xref-label>
                <span class="fmt-element-name">Example</span>
                <semx element="autonum" source="note1">1</semx>
             </fmt-xref-label>
             <fmt-xref-label container="widgets1">
                <span class="fmt-xref-container">
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="widgets">3</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="widgets1">1</semx>
                </span>
                <span class="fmt-comma">,</span>
                <span class="fmt-element-name">Example</span>
                <semx element="autonum" source="note1">1</semx>
             </fmt-xref-label>
             <p>Hello</p>
          </example>
          <example id="note2" unnumbered="true">
             <p>
                Hello
                <xref target="note1" id="_"/>
                <semx element="xref" source="_">
                   <fmt-xref target="note1">
                      <span class="fmt-element-name">Example</span>
                      <semx element="autonum" source="note1">1</semx>
                   </fmt-xref>
                </semx>
             </p>
          </example>
          <p>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-element-name">Example</span>
                   <semx element="autonum" source="note1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-element-name">Example</span>
                   <semx element="autonum" source="note2">(??)</semx>
                </fmt-xref>
             </semx>
          </p>
       </clause>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:clause[@id='widgets1']").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references formulae" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          <xref target="AAN"/>
          <xref target="AAnote1"/>
          <xref target="AAnote2"/>
          <xref target="Anote3"/>
          </p>
          </foreword>
          <introduction id="intro">
          <formula id="N1">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
        <clause id="xyz"><title>Preparatory</title>
          <formula id="N2" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <formula id="N">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <formula id="note1">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          <formula id="note2">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
          <formula id="AN">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          </clause>
          <clause id="annex1b">
          <formula id="Anote1" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          <formula id="Anote2">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
          <formula id="AAN">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          </clause>
          <clause id="annex11b">
          <formula id="AAnote1" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          <formula id="AAnote2">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <formula id="Anote3">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
        <foreword id="_" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title id="_" depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-xref-container">
                       <semx element="introduction" source="intro">Introduction</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-xref-container">
                       <semx element="clause" source="xyz">Preparatory</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="N2">(??)</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="scope">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N">1</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note1">1</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note2">2</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN">1</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Anote2">2</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="AAN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAN">
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="annex11">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN">1</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="AAnote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote1">
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="AAnote1">(??)</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="AAnote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote2">
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="annex11">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAnote2">2</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="Anote3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote3">
                    <span class="fmt-xref-container">
                       <semx element="references" source="biblio">Bibliographical Section</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Formula</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="Anote3">1</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references tables" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
              <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          <xref target="AAN"/>
          <xref target="AAnote1"/>
          <xref target="AAnote2"/>
          <xref target="Anote3"/>
          </p>
          </foreword>
          <introduction id="intro">
          <table id="N1">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
        <clause id="xyz"><title>Preparatory</title>
          <table id="N2" unnumbered="true">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
              <table id="N">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
          <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
              <table id="note1">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
              <table id="note2">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
          <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
              <table id="AN">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
          </clause>
          <clause id="annex1b">
              <table id="Anote1" unnumbered="true">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
              <table id="Anote2">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
              <table id="AAN">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
          </clause>
          <clause id="annex11b">
              <table id="AAnote1" unnumbered="true">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
              <table id="AAnote2">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
          </clause>
          </annex>
                    <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <table id="Anote3">
          <name>Repeatability and reproducibility of husked rice yield</name>
          <tbody>
          <tr>
            <td align="left">Number of laboratories retained after eliminating outliers</td>
            <td align="center">13</td>
            <td align="center">11</td>
          </tr>
          </tbody>
          </table>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
        <foreword id="_" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title id="_" depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-xref-container">
                       <semx element="introduction" source="intro">Introduction</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="N1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-xref-container">
                       <semx element="clause" source="xyz">Preparatory</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="N2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="scope">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Anote2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAN">
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="annex11">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAnote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote1">
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="AAnote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAnote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote2">
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="annex11">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAnote2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote3">
                    <span class="fmt-xref-container">
                       <semx element="references" source="biblio">Bibliographical Section</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Table</span>
                    <semx element="autonum" source="Anote3">1</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references sections" do
    input = <<~INPUT
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
               <xref target="PPP"/>
               <xref target="PPP1"/>
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
             <clause id="M" inline-header="false" obligation="normative"><title>Klause 4</title><clause id="N" inline-header="false" obligation="normative">
               <title>Introduction</title>
             </clause>
             <clause id="O" inline-header="false" obligation="normative">
               <title>Klause 4.2</title>
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
             <annex id="PPP" inline-header="false" obligation="normative">
               <title>Annex X</title>
               <terms id="PPP1"><title>Annex X Terms</title></terms>
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
    output = <<~OUTPUT
        <foreword obligation="informative" id="_" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title id="_" depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p id="A">
              This is a preamble
              <xref target="C" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="C">
                    <semx element="clause" source="C">Introduction Subsection</semx>
                 </fmt-xref>
              </semx>
              <xref target="C1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="C1">
                    <semx element="introduction" source="B">Introduction</semx>
                    <span class="fmt-comma">,</span>
                    <semx element="autonum" source="C1">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="D" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="D">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="D">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="H" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="H">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="H">3</semx>
                 </fmt-xref>
              </semx>
              <xref target="I" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="I">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="H">3</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="I">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="J" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="J">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="H">3</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="I">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="J">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="K" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="K">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="H">3</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="K">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="L" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="L">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="L">4</semx>
                 </fmt-xref>
              </semx>
              <xref target="M" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="M">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="M">5</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="M">5</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="O" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="O">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="M">5</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="O">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="P" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="P">
                    <span class="fmt-element-name">Annex</span>
                    <semx element="autonum" source="P">A</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q">
                    <span class="fmt-element-name">Annex</span>
                    <semx element="autonum" source="P">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q1">
                    <span class="fmt-element-name">Annex</span>
                    <semx element="autonum" source="P">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q2">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="P">A</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="Q2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="PP" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="PP">
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="PP">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="QQ" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="QQ">
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="PP">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="QQ">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="QQ1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="QQ1">
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="PP">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="QQ">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="QQ1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="QQ2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="QQ2">
                    <span class="fmt-xref-container">
                       <span class="fmt-element-name">Appendix</span>
                       <semx element="autonum" source="PP">1</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="QQ2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="PPP" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="PPP">
                    <span class="fmt-element-name">Annex</span>
                    <semx element="autonum" source="PPP">B</semx>
                 </fmt-xref>
              </semx>
              <xref target="PPP1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="PPP1">
                    <span class="fmt-element-name">Annex</span>
                    <semx element="autonum" source="PPP1">B</semx>
                 </fmt-xref>
              </semx>
              <xref target="R" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="R">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="R">2</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri::XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end
end

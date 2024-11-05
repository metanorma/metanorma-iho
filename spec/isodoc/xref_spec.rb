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
      <foreword displayorder="2"><title>Foreword</title>
         <p>
            <xref target="N1">Introduction, Note</xref>
            <xref target="N2">Preparatory, Note</xref>
            <xref target="N">Section 1, Note</xref>
            <xref target="note1">Clause 3.1, Note  1</xref>
            <xref target="note2">Clause 3.1, Note  2</xref>
            <xref target="AN">Appendix 1.1, Note</xref>
            <xref target="Anote1">Appendix 1.2, Note  1</xref>
            <xref target="Anote2">Appendix 1.2, Note  2</xref>
            <xref target="AAN">Annex A.1, Note</xref>
            <xref target="AAnote1">Annex A.2, Note  1</xref>
            <xref target="AAnote2">Annex A.2, Note  2</xref>
            <xref target="Anote3">Bibliographical Section, Note</xref>
         </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <foreword displayorder="2"><title>Foreword</title>
         <p>
            <xref target="N1">Introduction, Box</xref>
            <xref target="N2">Preparatory, Box</xref>
            <xref target="N3">[N3]</xref>
            <xref target="N">Section 1, Box</xref>
            <xref target="note1">Clause 3.1, Box  1</xref>
            <xref target="note2">Clause 3.1, Box  2</xref>
            <xref target="AN">Appendix 1.1, Box</xref>
            <xref target="Anote1">Appendix 1.2, Box  1</xref>
            <xref target="Anote2">Appendix 1.2, Box  2</xref>
            <xref target="AAN">Annex A.1, Box</xref>
            <xref target="AAnote1">Annex A.2, Box  1</xref>
            <xref target="AAnote2">Annex A.2, Box  2</xref>
            <xref target="Anote3">Bibliographical Section, Box</xref>
         </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
       .convert("test", input, true))
       .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <foreword id="fwd" displayorder="2"><title>Foreword</title>
         <p>
            <xref target="N1">Introduction, Figure 1</xref>
            <xref target="N2">Preparatory, Figure (??)</xref>
            <xref target="N">Figure 1-1</xref>
            <xref target="note1">Figure 3-1</xref>
            <xref target="note3">Figure 3-2</xref>
            <xref target="note4">Figure 3-3</xref>
            <xref target="note2">Figure 3-4</xref>
            <xref target="note51">[note51]</xref>
            <xref target="AN">Figure Appendix 1-1</xref>
            <xref target="Anote1">Figure Appendix (??)</xref>
            <xref target="Anote2">Figure Appendix 1-2</xref>
            <xref target="Anote3">Figure Appendix 1-3</xref>
            <xref target="AAN">Figure Annex A-1</xref>
            <xref target="AAnote1">Figure Annex (??)</xref>
            <xref target="AAnote2">Figure Annex A-2</xref>
            <xref target="AAnote3">Figure Annex A-3</xref>
            <xref target="Anote4">Bibliographical Section, Figure 1</xref>
         </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <foreword id="fwd" displayorder="2"><title>Foreword</title>
         <p>
            <xref target="N1">Introduction, Figure 1</xref>
            <xref target="N2">Preparatory, Figure (??)</xref>
            <xref target="N">Diagram 1-1</xref>
            <xref target="note1">Plate 3-1</xref>
            <xref target="note3">Figure 3-1</xref>
            <xref target="note4">Figure 3-2</xref>
            <xref target="note2">Diagram 3-1</xref>
            <xref target="note5">Figure 3-3</xref>
            <xref target="AN">Diagram Appendix 1-1</xref>
            <xref target="Anote1">Plate Appendix (??)</xref>
            <xref target="Anote2">Figure Appendix 1-1</xref>
            <xref target="Anote3">Figure Appendix 1-2</xref>
            <xref target="AAN">Diagram Annex A-1</xref>
            <xref target="AAnote1">Plate Annex (??)</xref>
            <xref target="AAnote2">Figure Annex A-1</xref>
            <xref target="AAnote3">Figure Annex A-2</xref>
            <xref target="Anote4">Bibliographical Section, Figure 1</xref>
         </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <foreword id="fwd" displayorder="2"><title>Foreword</title>
         <p>
            <xref target="N">Figure 3-1</xref>
            <xref target="note1">Figure 3-1-1</xref>
            <xref target="note2">Figure 3-1-2</xref>
            <xref target="AN">Figure Appendix 1-1</xref>
            <xref target="Anote1">Figure Appendix 1-1-1</xref>
            <xref target="Anote2">Figure Appendix 1-1-2</xref>
            <xref target="AAN">Figure Annex A-1</xref>
            <xref target="AAnote1">Figure Annex A-1-1</xref>
            <xref target="AAnote2">Figure Annex A-1-2</xref>
            <xref target="AN1">Bibliographical Section, Figure 1</xref>
            <xref target="Anote11">Bibliographical Section, Figure 1-1</xref>
            <xref target="Anote21">Bibliographical Section, Figure 1-2</xref>
         </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <foreword displayorder="2"><title>Foreword</title>
         <p>
            <xref target="N1">Introduction, Example</xref>
            <xref target="N2">Preparatory, Example (??)</xref>
            <xref target="N">Section 1, Example</xref>
            <xref target="note1">Clause 3.1, Example  1</xref>
            <xref target="note2">Clause 3.1, Example (??)</xref>
            <xref target="AN">Appendix 1.1, Example</xref>
            <xref target="Anote1">Appendix 1.2, Example (??)</xref>
            <xref target="Anote2">Appendix 1.2, Example  1</xref>
            <xref target="AAN">Annex A.1, Example</xref>
            <xref target="AAnote1">Annex A.2, Example (??)</xref>
            <xref target="AAnote2">Annex A.2, Example  1</xref>
            <xref target="Anote3">Bibliographical Section, Example</xref>
         </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)

    output = <<~OUTPUT
      <clause id='widgets1'>
         <title>3.1</title>
         <example id='note1'>
           <name>EXAMPLE 1</name>
           <p>Hello</p>
         </example>
         <example id='note2' unnumbered='true'>
           <name>EXAMPLE</name>
           <p>
             Hello
             <xref target='note1'>Example 1</xref>
           </p>
         </example>
         <p>
           <xref target='note1'>Example 1</xref>
           <xref target='note2'>Example (??)</xref>
         </p>
       </clause>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:clause[@id='widgets1']").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <foreword displayorder="2"><title>Foreword</title>
          <p>
             <xref target="N1">Introduction, Formula (1)</xref>
             <xref target="N2">Preparatory, Formula ((??))</xref>
             <xref target="N">Formula (1-1)</xref>
             <xref target="note1">Formula (3-1)</xref>
             <xref target="note2">Formula (3-2)</xref>
             <xref target="AN">Formula (Appendix 1-1)</xref>
             <xref target="Anote1">Formula (Appendix (??))</xref>
             <xref target="Anote2">Formula (Appendix 1-2)</xref>
             <xref target="AAN">Formula (Annex A-1)</xref>
             <xref target="AAnote1">Formula (Annex (??))</xref>
             <xref target="AAnote2">Formula (Annex A-2)</xref>
             <xref target="Anote3">Bibliographical Section, Formula (1)</xref>
          </p>
       </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references requirements" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="N3"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="note3"/>
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
          <requirement id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <clause id="xyz"><title>Preparatory</title>
          <requirement id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <requirement id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="N3" model="default" class="provision">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <requirement id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="note3" model="default" class="provision">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
          <requirement id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          <clause id="annex1b">
          <requirement id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
          <requirement id="AAN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          <clause id="annex11b">
          <requirement id="AAnote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="AAnote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <requirement id="Anote3" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="2"><title>Foreword</title>
         <p>
            <xref target="N1">Introduction, Requirement 1</xref>
            <xref target="N2">Preparatory, Requirement (??)</xref>
            <xref target="N">Requirement 1-1</xref>
            <xref target="N3">provision 1-1</xref>
            <xref target="note1">Requirement 3-1</xref>
            <xref target="note2">Requirement 3-2</xref>
            <xref target="note3">provision 3-1</xref>
            <xref target="AN">Requirement Appendix 1-1</xref>
            <xref target="Anote1">Requirement Appendix (??)</xref>
            <xref target="Anote2">Requirement Appendix 1-2</xref>
            <xref target="AAN">Requirement Annex A-1</xref>
            <xref target="AAnote1">Requirement Annex (??)</xref>
            <xref target="AAnote2">Requirement Annex A-2</xref>
            <xref target="Anote3">Bibliographical Section, Requirement 1</xref>
         </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references recommendations" do
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
          <recommendation id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <clause id="xyz"><title>Preparatory</title>
          <recommendation id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <recommendation id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <recommendation id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
          <recommendation id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          <clause id="annex1b">
          <recommendation id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
          <recommendation id="AAN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          <clause id="annex11b">
          <recommendation id="AAnote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="AAnote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <recommendation id="Anote3" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="2"><title>Foreword</title>
          <p>
             <xref target="N1">Introduction, Recommendation 1</xref>
             <xref target="N2">Preparatory, Recommendation (??)</xref>
             <xref target="N">Recommendation 1-1</xref>
             <xref target="note1">Recommendation 3-1</xref>
             <xref target="note2">Recommendation 3-2</xref>
             <xref target="AN">Recommendation Appendix 1-1</xref>
             <xref target="Anote1">Recommendation Appendix (??)</xref>
             <xref target="Anote2">Recommendation Appendix 1-2</xref>
             <xref target="AAN">Recommendation Annex A-1</xref>
             <xref target="AAnote1">Recommendation Annex (??)</xref>
             <xref target="AAnote2">Recommendation Annex A-2</xref>
             <xref target="Anote3">Bibliographical Section, Recommendation 1</xref>
          </p>
       </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references permissions" do
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
          <permission id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <clause id="xyz"><title>Preparatory</title>
          <permission id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <permission id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <permission id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex obligation='informative' id="annex1">
          <clause id="annex1a">
          <permission id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          <clause id="annex1b">
          <permission id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          </annex>
          <annex obligation='normative' id="annex11">
          <clause id="annex11a">
          <permission id="AAN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          <clause id="annex11b">
          <permission id="AAnote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="AAnote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <permission id="Anote3" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="2"><title>Foreword</title>
         <p>
            <xref target="N1">Introduction, Permission 1</xref>
            <xref target="N2">Preparatory, Permission (??)</xref>
            <xref target="N">Permission 1-1</xref>
            <xref target="note1">Permission 3-1</xref>
            <xref target="note2">Permission 3-2</xref>
            <xref target="AN">Permission Appendix 1-1</xref>
            <xref target="Anote1">Permission Appendix (??)</xref>
            <xref target="Anote2">Permission Appendix 1-2</xref>
            <xref target="AAN">Permission Annex A-1</xref>
            <xref target="AAnote1">Permission Annex (??)</xref>
            <xref target="AAnote2">Permission Annex A-2</xref>
            <xref target="Anote3">Bibliographical Section, Permission 1</xref>
         </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "labels and cross-references nested requirements" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
              <preface>
      <foreword>
      <p>
      <xref target="N1"/>
      <xref target="N2"/>
      <xref target="N"/>
      <xref target="Q1"/>
      <xref target="R1"/>
      <xref target="AN1"/>
      <xref target="AN2"/>
      <xref target="AN"/>
      <xref target="AQ1"/>
      <xref target="AR1"/>
      <xref target="AAN1"/>
      <xref target="AAN2"/>
      <xref target="AAN"/>
      <xref target="AAQ1"/>
      <xref target="AAR1"/>
      <xref target="BN1"/>
      <xref target="BN2"/>
      <xref target="BN"/>
      <xref target="BQ1"/>
      <xref target="BR1"/>
      </p>
      </foreword>
      </preface>
      <sections>
      <clause id="xyz"><title>Preparatory</title>
      <permission id="N1" model="default">
      <permission id="N2" model="default">
      <permission id="N" model="default">
      </permission>
      </permission>
      <requirement id="Q1" model="default">
      </requirement>
      <recommendation id="R1" model="default">
      </recommendation>
      </permission>
      </clause>
      </sections>
      <annex obligation='informative' id="Axyz"><title>Preparatory</title>
      <permission id="AN1" model="default">
      <permission id="AN2" model="default">
      <permission id="AN" model="default">
      </permission>
      </permission>
      <requirement id="AQ1" model="default">
      </requirement>
      <recommendation id="AR1" model="default">
      </recommendation>
      </permission>
      </annex>
      <annex obligation='normative' id="Axyz"><title>Preparatory</title>
      <permission id="AAN1" model="default">
      <permission id="AAN2" model="default">
      <permission id="AAN" model="default">
      </permission>
      </permission>
      <requirement id="AAQ1" model="default">
      </requirement>
      <recommendation id="AAR1" model="default">
      </recommendation>
      </permission>
      </annex>
                <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
                <permission id="BN1" model="default">
      <permission id="BN2" model="default">
      <permission id="BN" model="default">
      </permission>
      </permission>
      <requirement id="BQ1" model="default">
      </requirement>
      <recommendation id="BR1" model="default">
      </recommendation>
      </permission>
          </references></bibliography>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="2"><title>Foreword</title>
         <p>
            <xref target="N1">Permission 1-1</xref>
            <xref target="N2">Permission 1-1-1</xref>
            <xref target="N">Permission 1-1-1-1</xref>
            <xref target="Q1">Requirement 1-1-1</xref>
            <xref target="R1">Recommendation 1-1-1</xref>
            <xref target="AN1">Permission Appendix 1-1</xref>
            <xref target="AN2">Permission Appendix 1-1-1</xref>
            <xref target="AN">Permission Appendix 1-1-1-1</xref>
            <xref target="AQ1">Requirement Appendix 1-1-1</xref>
            <xref target="AR1">Recommendation Appendix 1-1-1</xref>
            <xref target="AAN1">Permission Annex A-1</xref>
            <xref target="AAN2">Permission Annex A-1-1</xref>
            <xref target="AAN">Permission Annex A-1-1-1</xref>
            <xref target="AAQ1">Requirement Annex A-1-1</xref>
            <xref target="AAR1">Recommendation Annex A-1-1</xref>
            <xref target="BN1">Bibliographical Section, Permission 1</xref>
            <xref target="BN2">Bibliographical Section, Permission 1-1</xref>
            <xref target="BN">Bibliographical Section, Permission 1-1-1</xref>
            <xref target="BQ1">Bibliographical Section, Requirement 1-1</xref>
            <xref target="BR1">Bibliographical Section, Recommendation 1-1</xref>
         </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <foreword displayorder="2"><title>Foreword</title>
           <p>
              <xref target="N1">Introduction, Table 1</xref>
              <xref target="N2">Preparatory, Table (??)</xref>
              <xref target="N">Table 1-1</xref>
              <xref target="note1">Table 3-1</xref>
              <xref target="note2">Table 3-2</xref>
              <xref target="AN">Table Appendix 1-1</xref>
              <xref target="Anote1">Table Appendix (??)</xref>
              <xref target="Anote2">Table Appendix 1-2</xref>
              <xref target="AAN">Table Annex A-1</xref>
              <xref target="AAnote1">Table Annex (??)</xref>
              <xref target="AAnote2">Table Annex A-2</xref>
              <xref target="Anote3">Bibliographical Section, Table 1</xref>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <iho-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
            <preface>
                <clause type="toc" id="_" displayorder="1">
             <title depth="1">Contents</title>
                   </clause>
            <foreword obligation="informative" displayorder="2"><title>Foreword</title>
               <p id="A">This is a preamble
               <xref target="C">Introduction Subsection</xref>
               <xref target="C1">Introduction, 2</xref>
               <xref target="D">Section 1</xref>
               <xref target="H">Section 3</xref>
               <xref target="I">Clause 3.1</xref>
               <xref target="J">Clause 3.1.1</xref>
               <xref target="K">Clause 3.2</xref>
               <xref target="L">Section 4</xref>
               <xref target="M">Section 5</xref>
               <xref target="N">Clause 5.1</xref>
               <xref target="O">Clause 5.2</xref>
               <xref target="P">Annex A</xref>
               <xref target="Q">Annex A.1</xref>
               <xref target="Q1">Annex A.1.1</xref>
               <xref target="Q2">Annex A, Appendix 1</xref>
               <xref target="PP">Appendix 1</xref>
               <xref target="QQ">Appendix 1.1</xref>
               <xref target="QQ1">Appendix 1.1.1</xref>
               <xref target="QQ2">Appendix 1, Appendix 1</xref>
               <xref target="R">Section 2</xref>
               </p>
             </foreword>
              <introduction id="B" obligation="informative" displayorder="3"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
               <title depth="2">Introduction Subsection</title>
             </clause>
             <clause id="C1" inline-header="false" obligation="informative">Text</clause>
             </introduction></preface><sections>
             <clause id="D" obligation="normative" type="scope" displayorder="4">
               <title depth="1">1<tab/>Scope</title>
               <p id="E">Text</p>
             </clause>
             <terms id="H" obligation="normative" displayorder="6"><title depth="1">3<tab/>Terms, definitions, symbols and abbreviated terms</title><terms id="I" obligation="normative">
               <title depth="2">3.1<tab/>Normal Terms</title>
               <term id="J"><name>3.1.1</name>
               <preferred>Term2</preferred>
             </term>
             </terms>
             <definitions id="K">
            <title depth="2">
               3.2
               <tab/>
               Symbols
            </title>
               <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
               </dl>
             </definitions>
             </terms>
             <definitions id="L" displayorder="7">
         <title depth="1">
            4
            <tab/>
            Symbols
         </title>
               <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
               </dl>
             </definitions>
             <clause id="M" inline-header="false" obligation="normative" displayorder="8"><title depth="1">5<tab/>Klause 4</title><clause id="N" inline-header="false" obligation="normative">
              <title depth="2">5.1<tab/>Introduction</title>
             </clause>
             <clause id="O" inline-header="false" obligation="normative">
               <title depth="2">5.2<tab/>Klause 4.2</title>
             </clause></clause>
             <references id="R" obligation="informative" normative="true" displayorder="5">
               <title depth="1">2<tab/>Normative References</title>
             </references>
            </sections><annex id="P" inline-header="false" obligation="normative" displayorder="9">
               <title><strong>Annex A</strong><br/><strong>Annex</strong></title>
               <clause id="Q" inline-header="false" obligation="normative">
               <title depth="2">A.1<tab/>Annex A.1</title>
               <clause id="Q1" inline-header="false" obligation="normative">
               <title depth="3">A.1.1<tab/>Annex A.1a</title>
               </clause>
             </clause>
                    <appendix id="Q2" inline-header="false" obligation="normative">
               <title>An Appendix</title>
             </appendix>
             </annex>
      <annex id="PP" inline-header="false" obligation="informative" displayorder="10">
               <title><strong>Appendix 1</strong><br/><strong>Annex</strong></title>
               <clause id="QQ" inline-header="false" obligation="normative">
               <title depth="2">1.1<tab/>Annex A.1</title>
               <clause id="QQ1" inline-header="false" obligation="normative">
               <title depth="3">1.1.1<tab/>Annex A.1a</title>
               </clause>
             </clause>
                    <appendix id="QQ2" inline-header="false" obligation="normative">
               <title>An Appendix</title>
             </appendix>
             </annex>
              <bibliography>
             <clause id="S" obligation="informative" displayorder="11">
               <title depth="1">Bibliography</title>
               <references id="T" obligation="informative" normative="false">
               <title depth="2">Bibliography Subsection</title>
             </references>
             </clause>
             </bibliography>
             </iho-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Iho::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end

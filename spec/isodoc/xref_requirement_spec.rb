require "spec_helper"

RSpec.describe IsoDoc do
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
                    <span class="fmt-element-name">Requirement</span>
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
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="N2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="scope">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N3">
                    <span class="fmt-element-name">provision</span>
                    <semx element="autonum" source="scope">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N3">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="note3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note3">
                    <span class="fmt-element-name">provision</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note3">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Anote2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAN">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="annex11">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAnote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="AAnote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAnote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote2">
                    <span class="fmt-element-name">Requirement</span>
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
                    <span class="fmt-element-name">Requirement</span>
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
                    <span class="fmt-element-name">Recommendation</span>
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
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="N2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="scope">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Anote2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAN">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="annex11">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAnote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="AAnote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAnote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote2">
                    <span class="fmt-element-name">Recommendation</span>
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
                    <span class="fmt-element-name">Recommendation</span>
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
                    <span class="fmt-element-name">Permission</span>
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
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="N2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="scope">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="annex1">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Anote2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAN">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="annex11">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAnote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="AAnote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAnote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAnote2">
                    <span class="fmt-element-name">Permission</span>
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
                    <span class="fmt-element-name">Permission</span>
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
        <foreword id="_" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title id="_" depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="xyz">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="xyz">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="xyz">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N2">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="xyz">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Q1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="R1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="R1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="xyz">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="R1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Axyz">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Axyz">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Axyz">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN2">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AQ1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AQ1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="Axyz">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AQ1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AR1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AR1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="Axyz">Appendix 1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AR1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAN1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAN1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAN2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAN2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAN">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN2">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAQ1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAQ1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAQ1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AAR1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AAR1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AAR1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="BN1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="BN1">
                    <span class="fmt-xref-container">
                       <semx element="references" source="biblio">Bibliographical Section</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="BN1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="BN2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="BN2">
                    <span class="fmt-xref-container">
                       <semx element="references" source="biblio">Bibliographical Section</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="BN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="BN2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="BN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="BN">
                    <span class="fmt-xref-container">
                       <semx element="references" source="biblio">Bibliographical Section</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="BN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="BN2">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="BN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="BQ1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="BQ1">
                    <span class="fmt-xref-container">
                       <semx element="references" source="biblio">Bibliographical Section</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="BN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="BQ1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="BR1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="BR1">
                    <span class="fmt-xref-container">
                       <semx element="references" source="biblio">Bibliographical Section</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="BN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="BR1">1</semx>
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
end

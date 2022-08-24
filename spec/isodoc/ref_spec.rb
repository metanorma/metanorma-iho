require "spec_helper"

RSpec.describe IsoDoc do
  it "processes IsoXML bibliographies" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          </bibdata>
          <preface><foreword>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
        <eref bibitemid="ref1"/>
        <eref bibitemid="ref2"/>
        <eref bibitemid="ref3"/>
        <eref bibitemid="ref4"/>
        <eref bibitemid="ref4"/>
        <eref bibitemid="ref6"/>
        <eref bibitemid="ref7"/>
        <eref bibitemid="ref8"/>
        <eref bibitemid="ref9"/>
        <eref bibitemid="ISO712"/>
        <eref bibitemid="ISBN"/>
        <eref bibitemid="ISSN"/>
        <eref bibitemid="ISO16634"/>
        <eref bibitemid="ref11"/>
        <eref bibitemid="ref10"/>
        <eref bibitemid="ref12"/>
        </p>
          </foreword></preface>
          <bibliography><references id="_normative_references" obligation="informative" normative="true"><title>Normative References</title>
          <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
              <bibitem id="ref1" type="standard">  <fetched>2020-06-01</fetched>  <title type="main" format="text/plain" language="en">IHO Transfer Standard for Digital Hydrographic Data</title>  <title type="main" format="text/plain" language="fr">Normes de l’OHI pour le transfert de données hydrographiques numériques</title>  <uri type="pdf">https://iho.int/uploads/user/pubs/standards/s-57/31Main.pdf</uri>  <docidentifier type="IHO">S-57</docidentifier>  <docnumber>57</docnumber>  <date type="published">    <from>2000</from>  </date>  <contributor>    <role type="publisher"/>    <organization>      <name>International Hydrographic Organization</name>      <abbreviation>IHO</abbreviation>      <uri>www.iho.int</uri>    </organization>  </contributor>  <edition>3.1.0</edition>  <version>    <revision-date>2000-11-01</revision-date>  </version>  <language>en</language>  <language>fr</language>  <script>Latn</script>  <status>    <stage>in-force</stage>  </status>  <copyright>    <from>2000</from>    <owner>      <organization>        <name>International Hydrographic Organization</name>        <abbreviation>IHO</abbreviation>        <uri>www.iho.int</uri>      </organization>    </owner>  </copyright>  <series type="main">    <title type="original" format="text/plain">      <variant language="en" script="Latn">Standards and Specifications</variant>      <variant language="fr" script="Latn">Normes et Spécifications</variant>    </title>    <place>Monaco</place>    <organization>International Hydrographic Organization</organization>    <number>S</number>  </series>  <place>Monaco</place>  <validity>    <validityBegins>2000-11-01 00:00</validityBegins>  </validity></bibitem><bibitem id="ref2" type="standard">  <fetched>2020-09-07</fetched>  <title format="text/plain" language="en" script="Latn">Digital Signature Standard (DSS)</title>  <uri type="uri">https://csrc.nist.gov/publications/detail/fips/186/archive/1996-12-30</uri>  <docidentifier type="NIST">FIPS 186</docidentifier>  <date type="published">    <on>1996-12</on>  </date>  <date type="obsoleted">    <on>1998-12</on>  </date>  <date type="issued">    <on>1994-05</on>  </date>  <contributor>    <role type="author"/>    <organization>      <name>National Institute of Standards and Technology</name>    </organization>  </contributor>  <edition>Revision 1</edition>  <language>en</language>  <script>Latn</script>  <status>    <stage>final</stage>    <substage>withdrawn</substage>  </status>  <copyright>    <from>1996</from>    <owner>      <organization>        <name>National Institute of Standards and Technology</name>        <abbreviation>NIST</abbreviation>        <uri>www.nist.gov</uri>      </organization>    </owner>  </copyright>  <relation type="supersedes">    <bibitem>      <formattedref format="text/plain" language="en" script="Latn">FIPS 186</formattedref>      <uri type="src">https://csrc.nist.gov/publications/detail/fips/186/archive/1994-05-19</uri>    </bibitem>  </relation>  <relation type="updates">    <bibitem>      <formattedref format="text/plain" language="en" script="Latn">FIPS 186-1</formattedref>      <uri type="src">https://csrc.nist.gov/publications/detail/fips/186/1/archive/1998-12-15</uri>    </bibitem>  </relation>  <place>Gaithersburg, MD</place>  <keyword>ADP security</keyword>  <keyword>computer security</keyword>  <keyword>digital signatures</keyword>  <keyword>public-key cryptography</keyword>  <keyword>Federal Information Processing Standard</keyword></bibitem><bibitem id="ref3" type="standard">  <fetched>2020-09-07</fetched>  <title format="text/plain" language="en" script="Latn">Secure Hash Standard</title>  <uri type="uri">https://csrc.nist.gov/publications/detail/fips/180/1/archive/1995-04-17</uri>  <uri type="doi">https://doi.org/10.6028/NIST.FIPS.180-1</uri>  <docidentifier type="NIST">FIPS 180-1</docidentifier>  <date type="published">    <on>1995-04</on>  </date>  <date type="obsoleted">    <on>2002-08</on>  </date>  <date type="issued">    <on>1995-04</on>  </date>  <contributor>    <role type="author"/>    <organization>      <name>National Institute of Standards and Technology</name>    </organization>  </contributor>  <language>en</language>  <script>Latn</script>  <status>    <stage>final</stage>    <substage>withdrawn</substage>  </status>  <copyright>    <from>1995</from>    <owner>      <organization>        <name>National Institute of Standards and Technology</name>        <abbreviation>NIST</abbreviation>        <uri>www.nist.gov</uri>      </organization>    </owner>  </copyright>  <relation type="supersedes">    <bibitem>      <formattedref format="text/plain" language="en" script="Latn">FIPS 180</formattedref>      <uri type="src">https://csrc.nist.gov/publications/detail/fips/180/archive/1993-05-11</uri>    </bibitem>  </relation>  <relation type="updates">    <bibitem>      <formattedref format="text/plain" language="en" script="Latn">FIPS 180-2</formattedref>      <uri type="src">https://csrc.nist.gov/publications/detail/fips/180/2/archive/2002-08-01</uri>    </bibitem>  </relation>  <place>Gaithersburg, MD</place>  <keyword>computer security</keyword>  <keyword>digital signatures</keyword>  <keyword>Federal Information Processing Standard</keyword>  <keyword>hash algorithm</keyword></bibitem><bibitem id="ref4" type="standard">  <fetched>2020-09-07</fetched>  <title type="title-main" format="text/plain" language="en" script="Latn">Information technology – Open Systems Interconnection – The Directory: Public-key and attribute certificate frameworks</title>  <title type="main" format="text/plain" language="en" script="Latn">Information technology – Open Systems Interconnection – The Directory: Public-key and attribute certificate frameworks</title>  <uri type="src">https://www.itu.int/ITU-T/recommendations/rec.aspx?rec=14033&amp;lang=en</uri>  <docidentifier type="ITU">ITU-T X.509</docidentifier>  <docidentifier type="ISO">ISO/IEC 9594-8</docidentifier>  <contributor>    <role type="publisher"/>    <organization>      <name>International Telecommunication Union</name>      <abbreviation>ITU</abbreviation>      <uri>www.itu.int</uri>    </organization>  </contributor>  <edition>9</edition>  <language>en</language>  <script>Latn</script>  <status>    <stage>Published</stage>  </status>  <copyright>    <from>2019</from>    <owner>      <organization>        <name>International Telecommunication Union</name>        <abbreviation>ITU</abbreviation>        <uri>www.itu.int</uri>      </organization>    </owner>  </copyright>  <relation type="complements">    <bibitem type="standard">      <formattedref format="text/plain" language="en" script="Latn">X Suppl. 34 (01/2019)</formattedref>    </bibitem>  </relation>  <relation type="instance">    <bibitem type="standard">      <fetched>2020-09-07</fetched>      <title type="title-main" format="text/plain" language="en" script="Latn">Information technology – Open Systems Interconnection – The Directory: Public-key and attribute certificate frameworks</title>      <title type="main" format="text/plain" language="en" script="Latn">Information technology – Open Systems Interconnection – The Directory: Public-key and attribute certificate frameworks</title>      <uri type="src">https://www.itu.int/ITU-T/recommendations/rec.aspx?rec=14033&amp;lang=en</uri>      <docidentifier type="ITU">ITU-T X.509</docidentifier>      <docidentifier type="ISO">ISO/IEC 9594-8</docidentifier>      <date type="published">        <on>2019</on>      </date>      <contributor>        <role type="publisher"/>        <organization>          <name>International Telecommunication Union</name>          <abbreviation>ITU</abbreviation>          <uri>www.itu.int</uri>        </organization>      </contributor>      <edition>9</edition>      <language>en</language>      <script>Latn</script>            <status>        <stage>Published</stage>      </status>      <copyright>        <from>2019</from>        <owner>          <organization>            <name>International Telecommunication Union</name>            <abbreviation>ITU</abbreviation>            <uri>www.itu.int</uri>          </organization>        </owner>      </copyright>      <relation type="complements">        <bibitem type="standard">          <formattedref format="text/plain" language="en" script="Latn">X Suppl. 34 (01/2019)</formattedref>        </bibitem>      </relation>      <place>Geneva</place>    </bibitem>  </relation>  <place>Geneva</place></bibitem><bibitem id="ref5">
        <formattedref format="application/x-isodoc+xml">ZIP File Format Specification, PKWare Inc.</formattedref>
        <docidentifier type="metanorma">[5]</docidentifier>
      </bibitem><bibitem id="ref6" type="standard">  <fetched>2020-09-07</fetched>  <title format="text/plain" language="en" script="Latn">DES Modes of Operation</title>  <uri type="uri">https://csrc.nist.gov/publications/detail/fips/81/archive/1980-12-02</uri>  <uri type="doi">https://doi.org/10.6028/NBS.FIPS.81</uri>  <docidentifier type="NIST">FIPS 81</docidentifier>  <date type="published">    <on>1980-12</on>  </date>  <date type="obsoleted">    <on>2005-05</on>  </date>  <date type="issued">    <on>1980-12</on>  </date>  <contributor>    <role type="author"/>    <organization>      <name>National Bureau of Standards</name>    </organization>  </contributor>  <language>en</language>  <script>Latn</script>  <status>    <stage>final</stage>    <substage>withdrawn</substage>  </status>  <copyright>    <from>1980</from>    <owner>      <organization>        <name>National Institute of Standards and Technology</name>        <abbreviation>NIST</abbreviation>        <uri>www.nist.gov</uri>      </organization>    </owner>  </copyright>  <place>Gaithersburg, MD</place>  <keyword>cryptography</keyword>  <keyword>data security</keyword>  <keyword>DES</keyword>  <keyword>encryption</keyword>  <keyword>Federal Information Processing Standards</keyword>  <keyword>computer security</keyword>  <keyword>modes of operation</keyword></bibitem><bibitem id="ref7" type="standard">  <fetched>2020-09-07</fetched>  <title format="text/plain" language="en" script="Latn">Privacy Enhancement for Internet Electronic Mail: Part III: Algorithms, Modes, and Identifiers</title>  <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.1423.xml</uri>  <uri type="src">https://www.rfc-editor.org/info/rfc1423</uri>  <docidentifier type="IETF">RFC 1423</docidentifier>  <docidentifier type="IETF" scope="anchor">RFC1423</docidentifier>  <docidentifier type="DOI">10.17487/RFC1423</docidentifier>  <date type="published">    <on>1993-02</on>  </date>  <contributor>    <role type="author"/>    <person>      <name>        <completename language="en">D. Balenson</completename>      </name>      <affiliation>        <organization>          <name>Internet Engineering Task Force</name>          <abbreviation>IETF</abbreviation>        </organization>      </affiliation>    </person>  </contributor>  <contributor>    <role type="publisher"/>    <organization>      <name>Internet Engineering Task Force</name>      <abbreviation>IETF</abbreviation>    </organization>  </contributor>  <language>en</language>  <script>Latn</script>    <series type="main">    <title format="text/plain" language="en" script="Latn">RFC</title>    <number>1423</number>  </series>  <place>Fremont, CA</place></bibitem><bibitem id="ref8">
        <formattedref format="application/x-isodoc+xml">Blowfish encryption algorithm, B. Schneier, Fast Software Encryption, Cambridge Security Workshop Proceedings (December 1993), Springer-Verlag, 1994, pp. 191-204 (<link target="http://www.counterpane.com"/>)</formattedref>
        <docidentifier type="metanorma">[8]</docidentifier>
      </bibitem><bibitem id="ref9" type="standard">  <fetched>2020-09-07</fetched>  <title type="title-intro" format="text/plain" language="en" script="Latn">Information technology</title>  <title type="title-main" format="text/plain" language="en" script="Latn">Telecommunications and information exchange between systems</title>  <title type="title-part" format="text/plain" language="en" script="Latn">High-level data link control (HDLC) procedures</title>  <title type="main" format="text/plain" language="en" script="Latn">Information technology — Telecommunications and information exchange between systems — High-level data link control (HDLC) procedures</title>  <title type="title-intro" format="text/plain" language="fr" script="Latn">Technologies de l’information</title>  <title type="title-main" format="text/plain" language="fr" script="Latn">Télécommunications et échange d’information entre systèmes</title>  <title type="title-part" format="text/plain" language="fr" script="Latn">Procédures de commande de liaison de données à haut niveau (HDLC)</title>  <title type="main" format="text/plain" language="fr" script="Latn">Technologies de l’information — Télécommunications et échange d’information entre systèmes — Procédures de commande de liaison de données à haut niveau (HDLC)</title>  <uri type="src">https://www.iso.org/standard/37010.html</uri>  <uri type="obp">https://www.iso.org/obp/ui/#!iso:std:37010:en</uri>  <uri type="rss">https://www.iso.org/contents/data/standard/03/70/37010.detail.rss</uri>  <docidentifier type="ISO">ISO/IEC 13239:2002</docidentifier>  <docnumber>13239</docnumber>  <date type="published">    <on>2002</on>  </date>  <contributor>    <role type="publisher"/>    <organization>      <name>International Organization for Standardization</name>      <abbreviation>ISO</abbreviation>      <uri>www.iso.org</uri>    </organization>  </contributor>  <contributor>    <role type="publisher"/>    <organization>      <name>International Electrotechnical Commission</name>      <abbreviation>IEC</abbreviation>      <uri>www.iec.ch</uri>    </organization>  </contributor>  <edition>3</edition>  <language>en</language>  <language>fr</language>  <script>Latn</script>      <status>    <stage>90</stage>    <substage>93</substage>  </status>  <copyright>    <from>2002</from>    <owner>      <organization>        <name>ISO/IEC</name>      </organization>    </owner>  </copyright>  <relation type="obsoletes">    <bibitem type="standard">      <formattedref format="text/plain">ISO/IEC 3309:1993</formattedref>    </bibitem>  </relation>  <relation type="obsoletes">    <bibitem type="standard">      <formattedref format="text/plain">ISO/IEC 4335:1993</formattedref>    </bibitem>  </relation>  <relation type="obsoletes">    <bibitem type="standard">      <formattedref format="text/plain">ISO/IEC 7809:1993</formattedref>    </bibitem>  </relation>  <relation type="obsoletes">    <bibitem type="standard">      <formattedref format="text/plain">ISO/IEC 8885:1993</formattedref>    </bibitem>  </relation>  <relation type="obsoletes">    <bibitem type="standard">      <formattedref format="text/plain">ISO/IEC 13239:2000</formattedref>    </bibitem>  </relation>  <place>Geneva</place></bibitem>
      <bibitem id="ISO712" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <title type="main" format="text/plain">Cereals and cereal products</title>
        <docidentifier type="ISO">ISO 712</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
          </organization>
        </contributor>
      </bibitem>
      <bibitem id="ISO16634" type="standard">
        <title language="x" format="text/plain">Cereals, pulses, milled cereal products, xxxx, oilseeds and animal feeding stuffs</title>
        <title language="en" format="text/plain">Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</title>
        <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
        <date type="published"><on>--</on></date>
        <contributor>
          <role type="publisher"/>
          <organization>
            <abbreviation>ISO</abbreviation>
          </organization>
        </contributor>
        <note format="text/plain" reference="1" type="ISO DATE">Under preparation. (Stage at the time of publication ISO/DIS 16634)</note>
        <extent type="part">
        <referenceFrom>all</referenceFrom>
        </extent>

      </bibitem>
      <bibitem id="ISO20483" type="standard">
        <title format="text/plain">Cereals and pulses</title>
        <docidentifier type="ISO">ISO 20483:2013-2014</docidentifier>
        <date type="published"><from>2013</from><to>2014</to></date>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
          </organization>
        </contributor>
      </bibitem>
      <bibitem id="ref11">
        <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
        <docidentifier type="ICC">167</docidentifier>
      </bibitem>
      <note><p>This is an annotation of ISO 20483:2013-2014</p></note>

      </references><references id="_bibliography" obligation="informative" normative="false">
        <title>Bibliography</title>
      <bibitem id="ISBN" type="book">
        <title format="text/plain">Chemicals for analytical laboratory use</title>
        <docidentifier type="ISBN">ISBN</docidentifier>
        <docidentifier type="metanorma">[1]</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <abbreviation>ISBN</abbreviation>
          </organization>
        </contributor>
      </bibitem>
      <bibitem id="ISSN" type="journal">
        <title format="text/plain">Instruments for analytical laboratory use</title>
        <docidentifier type="ISSN">ISSN</docidentifier>
        <docidentifier type="metanorma">[2]</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <abbreviation>ISSN</abbreviation>
          </organization>
        </contributor>
      </bibitem>
      <note><p>This is an annotation of document ISSN.</p></note>
      <note><p>This is another annotation of document ISSN.</p></note>
      <bibitem id="ISO3696" type="standard">
        <title format="text/plain">Water for analytical laboratory use</title>
        <docidentifier type="ISO">ISO 3696</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <abbreviation>ISO</abbreviation>
          </organization>
        </contributor>
      </bibitem>
      <bibitem id="ref10">
        <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
        <docidentifier type="metanorma">[10]</docidentifier>
      </bibitem>
      <bibitem id="ref11">
        <title>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</title>
        <docidentifier type="IETF">RFC 10</docidentifier>
      </bibitem>
      <bibitem id="ref12">
        <formattedref format="application/x-isodoc+xml">CitationWorks. 2019. <em>How to cite a reference</em>.</formattedref>
        <docidentifier type="metanorma">[Citn]</docidentifier>
        <docidentifier type="IETF">RFC 20</docidentifier>
      </bibitem>


      </references>
      </bibliography>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
            <?xml version='1.0'?>
            <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
                   <bibdata>
                   <language current="true">en</language>
                   </bibdata>
                   <preface><foreword displayorder="1">
                 <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
                 <eref bibitemid="ref1">S-57</eref>
                 <eref bibitemid="ref2">NIST FIPS 186</eref>
                 <eref bibitemid="ref3">NIST FIPS 180-1</eref>
                 <eref bibitemid="ref4">ITU-T X.509</eref>
                 <eref bibitemid="ref4">ITU-T X.509</eref>
                 <eref bibitemid="ref6">NIST FIPS 81</eref>
                 <eref bibitemid="ref7">IETF RFC 1423</eref>
                 <eref bibitemid="ref8">[8]</eref>
                 <eref bibitemid="ref9">ISO/IEC 13239:2002</eref>
                 <eref bibitemid="ISO712">ISO 712</eref>
                 <eref bibitemid="ISBN">[1]</eref>
                 <eref bibitemid="ISSN">[2]</eref>
                 <eref bibitemid="ISO16634">ISO 16634:-- (all parts)</eref>
                 <eref bibitemid="ref11">IETF RFC 10</eref>
                 <eref bibitemid="ref10">[10]</eref>
                 <eref bibitemid="ref12">Citn</eref>
                 </p>
                   </foreword></preface>
                   <bibliography><references id="_normative_references" obligation="informative" normative="true" displayorder="2"><title depth="1">1.<tab/>Normative References</title>
                   <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
                       <bibitem id="ref1" type="standard">
                         <formattedref>S-57 edition 3.1.0: IHO Transfer Standard for Digital Hydrographic Data, International Hydrographic Organization (<link target='https://iho.int/uploads/user/pubs/standards/s-57/31Main.pdf'>https://iho.int/uploads/user/pubs/standards/s-57/31Main.pdf</link>).</formattedref>
      <uri type="pdf">https://iho.int/uploads/user/pubs/standards/s-57/31Main.pdf</uri>  <docidentifier type="IHO">S-57</docidentifier>
      </bibitem>
            <bibitem id="ref2" type="standard">
              <formattedref>NIST FIPS 186: Digital Signature Standard (DSS), National Institute of Standards and Technology (<link target='https://csrc.nist.gov/publications/detail/fips/186/archive/1996-12-30'>https://csrc.nist.gov/publications/detail/fips/186/archive/1996-12-30</link>).</formattedref>
      <uri type="uri">https://csrc.nist.gov/publications/detail/fips/186/archive/1996-12-30</uri>  <docidentifier type="NIST">NIST FIPS 186</docidentifier>
      </bibitem>
      <bibitem id="ref3" type="standard">
              <formattedref>NIST FIPS 180-1: Secure Hash Standard, National Institute of Standards and Technology (<link target='https://csrc.nist.gov/publications/detail/fips/180/1/archive/1995-04-17'>https://csrc.nist.gov/publications/detail/fips/180/1/archive/1995-04-17</link>).</formattedref>
      <uri type="uri">https://csrc.nist.gov/publications/detail/fips/180/1/archive/1995-04-17</uri>  <uri type="doi">https://doi.org/10.6028/NIST.FIPS.180-1</uri>  <docidentifier type="NIST">NIST FIPS 180-1</docidentifier>
      </bibitem>
      <bibitem id="ref4" type="standard">
             <formattedref>ITU-T X.509: Information technology &#x2013; Open Systems Interconnection &#x2013; The Directory: Public-key and attribute certificate frameworks, International Telecommunication Union (<link target='https://www.itu.int/ITU-T/recommendations/rec.aspx?rec=14033&amp;lang=en'>https://www.itu.int/ITU-T/recommendations/rec.aspx?rec=14033&amp;lang=en</link>).</formattedref>
      <uri type="src">https://www.itu.int/ITU-T/recommendations/rec.aspx?rec=14033&amp;lang=en</uri>  <docidentifier type="ITU">ITU-T X.509</docidentifier>  <docidentifier type="ISO">ISO/IEC 9594-8</docidentifier>
      </bibitem>
      <bibitem id="ref5">
                 <formattedref format="application/x-isodoc+xml">ZIP File Format Specification, PKWare Inc.</formattedref>
                 <docidentifier type="metanorma">[5]</docidentifier>
               </bibitem>
      <bibitem id="ref6" type="standard">
              <formattedref>NIST FIPS 81: DES Modes of Operation, National Bureau of Standards (<link target='https://csrc.nist.gov/publications/detail/fips/81/archive/1980-12-02'>https://csrc.nist.gov/publications/detail/fips/81/archive/1980-12-02</link>).</formattedref>
      <uri type="uri">https://csrc.nist.gov/publications/detail/fips/81/archive/1980-12-02</uri>  <uri type="doi">https://doi.org/10.6028/NBS.FIPS.81</uri>  <docidentifier type="NIST">NIST FIPS 81</docidentifier>
      </bibitem>
      <bibitem id="ref7" type="standard">
              <formattedref>IETF RFC 1423: Privacy Enhancement for Internet Electronic Mail: Part III: Algorithms, Modes, and Identifiers, D. Balenson (<link target='https://www.rfc-editor.org/info/rfc1423'>https://www.rfc-editor.org/info/rfc1423</link>).</formattedref>
      <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.1423.xml</uri>  <uri type="src">https://www.rfc-editor.org/info/rfc1423</uri>  <docidentifier type="IETF">IETF RFC 1423</docidentifier>  <docidentifier type="IETF" scope="anchor">IETF RFC1423</docidentifier>  <docidentifier type="DOI">DOI 10.17487/RFC1423</docidentifier>
      </bibitem>
      <bibitem id="ref8">
                 <formattedref format="application/x-isodoc+xml">Blowfish encryption algorithm, B. Schneier, Fast Software Encryption, Cambridge Security Workshop Proceedings (December 1993), Springer-Verlag, 1994, pp. 191-204 (<link target="http://www.counterpane.com"/>)</formattedref>
                 <docidentifier type="metanorma">[8]</docidentifier>
               </bibitem>
      <bibitem id="ref9" type="standard">
              <formattedref>
                ISO/IEC 13239:2002: Information
                technology&#x2009;&#x2014;&#x2009;Telecommunications and information
                exchange between systems&#x2009;&#x2014;&#x2009;High-level data link
                control (HDLC) procedures, International Organization for
                Standardization and International Electrotechnical Commission
                (<link target='https://www.iso.org/standard/37010.html'>https://www.iso.org/standard/37010.html</link>).</formattedref>
            <uri type="src">https://www.iso.org/standard/37010.html</uri>  <uri type="obp">https://www.iso.org/obp/ui/#!iso:std:37010:en</uri>  <uri type="rss">https://www.iso.org/contents/data/standard/03/70/37010.detail.rss</uri>  <docidentifier type="ISO">ISO/IEC 13239:2002</docidentifier>
      </bibitem>
               <bibitem id="ISO712" type="standard">
                 <formattedref>ISO 712: Cereals and cereal products, International Organization for Standardization.</formattedref>
                 <docidentifier type="ISO">ISO 712</docidentifier>
               </bibitem>
               <bibitem id="ISO16634" type="standard">
                         <formattedref>ISO 16634:-- (all parts): Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs.</formattedref>
                 <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
                 <note format="text/plain" reference="1" type="ISO DATE">Under preparation. (Stage at the time of publication ISO/DIS 16634)</note>
               </bibitem>
               <bibitem id="ISO20483" type="standard">
                 <formattedref>ISO 20483:2013-2014: Cereals and pulses, International Organization for Standardization.</formattedref>
                 <docidentifier type="ISO">ISO 20483:2013-2014</docidentifier>
               </bibitem>
               <bibitem id="ref11">
                 <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>) [ICC 167]</formattedref>
                 <docidentifier type="ICC">ICC 167</docidentifier>
               </bibitem>
               <note><name>NOTE</name><p>This is an annotation of ISO 20483:2013-2014</p></note>

               </references><references id="_bibliography" obligation="informative" normative="false" displayorder="3">
                 <title depth="1">Bibliography</title>
               <bibitem id="ISBN" type="book">
                 <formattedref><em>Chemicals for analytical laboratory use</em>. n.p.: n.d. ISBN.</formattedref>
                 <docidentifier type="ISBN">ISBN</docidentifier>
                 <docidentifier type="metanorma">[1]</docidentifier>
               </bibitem>
               <bibitem id="ISSN" type="journal">
                 <formattedref><em>Instruments for analytical laboratory use</em>. n.d. ISSN.</formattedref>
                 <docidentifier type="ISSN">ISSN</docidentifier>
                 <docidentifier type="metanorma">[2]</docidentifier>
               </bibitem>
               <note><name>NOTE</name><p>This is an annotation of document ISSN.</p></note>
               <note><name>NOTE</name><p>This is another annotation of document ISSN.</p></note>
               <bibitem id="ISO3696" type="standard">
                 <formattedref>ISO 3696: Water for analytical laboratory use.</formattedref>
                 <docidentifier type='metanorma-ordinal'>[3]</docidentifier>
                 <docidentifier type="ISO">ISO 3696</docidentifier>
               </bibitem>
               <bibitem id="ref10">
                 <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
                 <docidentifier type="metanorma">[10]</docidentifier>
               </bibitem>
               <bibitem id="ref11">
                 <formattedref>IETF RFC 10: Internet Calendaring and Scheduling Core Object Specification (iCalendar).</formattedref>
                 <docidentifier type='metanorma-ordinal'>[4]</docidentifier>
                 <docidentifier type="IETF">IETF RFC 10</docidentifier>
               </bibitem>
               <bibitem id="ref12">
                 <formattedref format="application/x-isodoc+xml">CitationWorks. 2019. <em>How to cite a reference</em>. [IETF RFC 20]</formattedref>
                 <docidentifier type="metanorma">[Citn]</docidentifier>
                 <docidentifier type="IETF">IETF RFC 20</docidentifier>
               </bibitem>
               </references>
               </bibliography>
                   </iso-standard>
    OUTPUT

    html = <<~OUTPUT
      #{HTML_HDR}
                 <br/>
           <div>
             <h1 class='ForewordTitle'>Foreword</h1>
             <p id='_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f'>
               <a href='#ref1'>S-57</a>
               <a href='#ref2'>NIST FIPS 186</a>
               <a href='#ref3'>NIST FIPS 180-1</a>
               <a href='#ref4'>ITU-T X.509</a>
               <a href='#ref4'>ITU-T X.509</a>
               <a href='#ref6'>NIST FIPS 81</a>
               <a href='#ref7'>IETF RFC 1423</a>
               <a href='#ref8'>[8]</a>
               <a href='#ref9'>ISO/IEC 13239:2002</a>
               <a href='#ISO712'>ISO 712</a>
               <a href='#ISBN'>[1]</a>
               <a href='#ISSN'>[2]</a>
               <a href='#ISO16634'>ISO 16634:-- (all parts)</a>
               <a href='#ref11'>IETF RFC 10</a>
               <a href='#ref10'>[10]</a>
               <a href='#ref12'>Citn</a>
             </p>
           </div>
           <p class='zzSTDTitle1'/>
           <div>
             <h1>1.&#160; Normative References</h1>
             <p>
               The following documents are referred to in the text in such a way that
               some or all of their content constitutes requirements of this document.
               For dated references, only the edition cited applies. For undated
               references, the latest edition of the referenced document (including any
               amendments) applies.
             </p>
             <p id='ref1' class='NormRef'>
               [1]&#160; S-57 edition 3.1.0: IHO Transfer Standard for Digital
               Hydrographic Data, International Hydrographic Organization (
               <a href='https://iho.int/uploads/user/pubs/standards/s-57/31Main.pdf'>https://iho.int/uploads/user/pubs/standards/s-57/31Main.pdf</a>
               ).
             </p>
             <p id='ref2' class='NormRef'>
               [2]&#160; NIST FIPS 186: Digital Signature Standard (DSS), National
               Institute of Standards and Technology (
               <a href='https://csrc.nist.gov/publications/detail/fips/186/archive/1996-12-30'>https://csrc.nist.gov/publications/detail/fips/186/archive/1996-12-30</a>
               ).
             </p>
             <p id='ref3' class='NormRef'>
               [3]&#160; NIST FIPS 180-1: Secure Hash Standard, National Institute of
               Standards and Technology (
               <a href='https://csrc.nist.gov/publications/detail/fips/180/1/archive/1995-04-17'>https://csrc.nist.gov/publications/detail/fips/180/1/archive/1995-04-17</a>
               ).
             </p>
             <p id='ref4' class='NormRef'>
               [4]&#160; ITU-T X.509: Information technology &#8211; Open Systems
               Interconnection &#8211; The Directory: Public-key and attribute
               certificate frameworks, International Telecommunication Union (
               <a href='https://www.itu.int/ITU-T/recommendations/rec.aspx?rec=14033&amp;lang=en'>https://www.itu.int/ITU-T/recommendations/rec.aspx?rec=14033lang=en</a>
               ).
             </p>
             <p id='ref5' class='NormRef'>[5] ZIP File Format Specification, PKWare Inc.</p>
             <p id='ref6' class='NormRef'>
               [6]&#160; NIST FIPS 81: DES Modes of Operation, National Bureau of
               Standards (
               <a href='https://csrc.nist.gov/publications/detail/fips/81/archive/1980-12-02'>https://csrc.nist.gov/publications/detail/fips/81/archive/1980-12-02</a>
               ).
             </p>
             <p id='ref7' class='NormRef'>
               [7]&#160; IETF RFC 1423: Privacy Enhancement for Internet Electronic
               Mail: Part III: Algorithms, Modes, and Identifiers, D. Balenson (
               <a href='https://www.rfc-editor.org/info/rfc1423'>https://www.rfc-editor.org/info/rfc1423</a>
               ).
             </p>
             <p id='ref8' class='NormRef'>
               [8] Blowfish encryption algorithm, B. Schneier, Fast Software
               Encryption, Cambridge Security Workshop Proceedings (December 1993),
               Springer-Verlag, 1994, pp. 191-204 (
               <a href='http://www.counterpane.com'>http://www.counterpane.com</a>
               )
             </p>
             <p id='ref9' class='NormRef'>
               [9]&#160; ISO/IEC 13239:2002: Information
               technology&#8201;&#8212;&#8201;Telecommunications and information
               exchange between systems&#8201;&#8212;&#8201;High-level data link
               control (HDLC) procedures, International Organization for
               Standardization and International Electrotechnical Commission (
               <a href='https://www.iso.org/standard/37010.html'>https://www.iso.org/standard/37010.html</a>
               ).
             </p>
             <p id='ISO712' class='NormRef'>
               [10]&#160; ISO 712: Cereals and cereal products, International
               Organization for Standardization.
             </p>
             <p id='ISO16634' class='NormRef'>
               [11]&#160; ISO 16634:-- (all parts): Cereals, pulses, milled cereal
               products, oilseeds and animal feeding stuffs.
             </p>
             <p id='ISO20483' class='NormRef'>
               [12]&#160; ISO 20483:2013-2014: Cereals and pulses, International
               Organization for Standardization.
             </p>
             <p id='ref11' class='NormRef'>
               [13]&#160;
               <span style='font-variant:small-caps;'>Standard No I.C.C 167</span>
               .
               <i>
                 Determination of the protein content in cereal and cereal products for
                 food and animal feeding stuffs according to the Dumas combustion
                 method
               </i>
                (see
               <a href='http://www.icc.or.at'>http://www.icc.or.at</a>
               ) [ICC 167]
             </p>
             <div class='Note'>
               <p>
                 <span class='note_label'>NOTE</span>
                 &#160; This is an annotation of ISO 20483:2013-2014
               </p>
             </div>
           </div>
           <br/>
           <div>
             <h1 class='Section3'>Bibliography</h1>
             <p id='ISBN' class='Biblio'>
               [1]&#160;
               <i>Chemicals for analytical laboratory use</i>
               . n.p.: n.d. ISBN.
             </p>
             <p id='ISSN' class='Biblio'>
               [2]&#160;
               <i>Instruments for analytical laboratory use</i>
               . n.d. ISSN.
             </p>
             <div class='Note'>
               <p>
                 <span class='note_label'>NOTE</span>
                 &#160; This is an annotation of document ISSN.
               </p>
             </div>
             <div class='Note'>
               <p>
                 <span class='note_label'>NOTE</span>
                 &#160; This is another annotation of document ISSN.
               </p>
             </div>
             <p id='ISO3696' class='Biblio'>[3]&#160; ISO 3696: Water for analytical laboratory use.</p>
             <p id='ref10' class='Biblio'>
               [10]&#160;
               <span style='font-variant:small-caps;'>Standard No I.C.C 167</span>
               .
               <i>
                 Determination of the protein content in cereal and cereal products for
                 food and animal feeding stuffs according to the Dumas combustion
                 method
               </i>
                (see
               <a href='http://www.icc.or.at'>http://www.icc.or.at</a>
               )
             </p>
             <p id='ref11' class='Biblio'>
               [5]&#160; IETF RFC 10: Internet Calendaring and Scheduling Core Object
               Specification (iCalendar).
             </p>
             <p id='ref12' class='Biblio'>
               [6]&#160; CitationWorks. 2019.
               <i>How to cite a reference</i>
               . [IETF RFC 20]
             </p>
           </div>
         </div>
       </body>
    OUTPUT
    expect(xmlpp(IsoDoc::IHO::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::IHO::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
  end
end

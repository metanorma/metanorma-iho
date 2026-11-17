require "spec_helper"

# metanorma-iho#566: S-4 is published in English, French and Spanish
# editions with identical numbering; the flavour selects its strings and
# boilerplate by document language.
RSpec.describe "IHO French and Spanish i18n" do
  def labels(lang)
    conv = IsoDoc::Iho::PresentationXMLConvert.new({})
    conv.i18n_init(lang, "Latn", nil)
    conv.i18n.get
  end

  def boilerplate(lang)
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :language: #{lang}
    INPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input, backend: :iho,
                                                   header_footer: true))
    xml.remove_namespaces!
    xml.at("//boilerplate")
  end

  it "selects the flavour strings by document language" do
    en = labels("en")
    expect(en["clause"]).to eq "Section"
    expect(en["table_of_contents"]).to eq "Contents"
    expect(en["org_name"]).to eq "International Hydrographic Organization"

    fr = labels("fr")
    expect(fr["clause"]).to eq "Section"
    expect(fr["table_of_contents"]).to eq "Table des matières"
    expect(fr["org_name"]).to eq "Organisation Hydrographique Internationale"
    expect(fr["org_abbrev"]).to eq "OHI"

    es = labels("es")
    expect(es["clause"]).to eq "Sección"
    expect(es["table_of_contents"]).to eq "Índice"
    expect(es["org_name"]).to eq "Organización Hidrográfica Internacional"
    expect(es["org_abbrev"]).to eq "OHI"
  end

  it "keeps the English flavour strings for other languages" do
    de = labels("de")
    expect(de["clause"]).to eq "Section"
    expect(de["org_name"]).to eq "International Hydrographic Organization"
  end

  it "selects the boilerplate by document language" do
    expect(boilerplate("en").at("//copyright-statement").text)
      .to include "© Copyright International Hydrographic Organization"
    expect(boilerplate("fr").at("//copyright-statement").text)
      .to include "Organisation Hydrographique Internationale"
    expect(boilerplate("es").at("//copyright-statement").text)
      .to include "Organización Hidrográfica Internacional"
    expect(boilerplate("es").at("//feedback-statement").text)
      .to include "Principado de Mónaco"
  end

  it "keeps the English boilerplate for other languages" do
    expect(boilerplate("de").at("//copyright-statement").text)
      .to include "© Copyright International Hydrographic Organization"
  end

  it "localizes the HTML cover page" do
    input = <<~INPUT
      <iho-standard xmlns="http://riboseinc.com/isoxml">
        <bibdata type="standard">
          <title language="es" type="main">Reglamento de la OHI para Cartas Internacionales</title>
          <docidentifier type="IHO">S-4</docidentifier>
          <docnumber>4</docnumber>
          <edition>4.9.0</edition>
          <language>es</language>
          <script>Latn</script>
          <status><stage>in-force</stage></status>
          <copyright><from>2022</from></copyright>
          <ext><doctype>standard</doctype></ext>
        </bibdata>
        <sections/>
      </iho-standard>
    INPUT
    FileUtils.rm_f "test.html"
    presxml = IsoDoc::Iho::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    IsoDoc::Iho::HtmlConvert.new({}).convert("test", presxml, false)
    html = File.read("test.html", encoding: "utf-8")
    cover = html[%r{<div class="coverpage">.*?</header>}m]
    expect(cover).to include "Edición 4.9.0"
    expect(cover).to include "Organización Hidrográfica Internacional. 2022"
    expect(cover).not_to include "Edition 4.9.0"
  end
end

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "asciidoctor"
require "metanorma-iho"
require "metanorma/iho"
require "isodoc/iho/html_convert"
require "isodoc/iho/word_convert"
require "metanorma/standoc/converter"
require "rspec/matchers"
require "equivalent-xml"
require "htmlentities"
require "metanorma"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def metadata(xml)
  xml.sort.to_h.delete_if do |_k, v|
    v.nil? || (v.respond_to?(:empty?) && v.empty?)
  end
end

def strip_guid(xml)
  xml.gsub(%r{ id="_[^"]+"}, ' id="_"')
    .gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def htmlencode(xml)
  HTMLEntities.new.encode(xml, :hexadecimal)
    .gsub(/&#x3e;/, ">").gsub(/&#xa;/, "\n")
    .gsub(/&#x22;/, '"').gsub(/&#x3c;/, "<")
    .gsub(/&#x26;/, "&").gsub(/&#x27;/, "'")
    .gsub(/\\u(....)/) do |_s|
    "&#x#{$1.downcase};"
  end
end

def xmlpp(xml)
  xsl = <<~XSL
  <!--
    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:template match="/">
        <xsl:copy-of select="."/>
      </xsl:template>
    </xsl:stylesheet>
  -->
  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="ISO-8859-1"/>
  <xsl:param name="indent-increment" select="'  '"/>

  <xsl:template name="newline">
    <xsl:text disable-output-escaping="yes">
</xsl:text>
  </xsl:template>

  <xsl:template match="comment() | processing-instruction()">
    <xsl:param name="indent" select="''"/>
    <xsl:call-template name="newline"/>
    <xsl:value-of select="$indent"/>
    <xsl:copy />
  </xsl:template>

  <xsl:template match="text()">
    <xsl:param name="indent" select="''"/>
    <xsl:call-template name="newline"/>
    <xsl:value-of select="$indent"/>
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <xsl:template match="text()[normalize-space(.)='']"/>

  <xsl:template match="*">
    <xsl:param name="indent" select="''"/>
    <xsl:call-template name="newline"/>
    <xsl:value-of select="$indent"/>
      <xsl:choose>
       <xsl:when test="count(child::*) > 0">
        <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="*|text()">
           <xsl:with-param name="indent" select="concat ($indent, $indent-increment)"/>
         </xsl:apply-templates>
         <xsl:call-template name="newline"/>
         <xsl:value-of select="$indent"/>
        </xsl:copy>
       </xsl:when>
       <xsl:otherwise>
        <xsl:copy-of select="."/>
       </xsl:otherwise>
     </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
  XSL
  Nokogiri::XSLT(xsl).transform(Nokogiri::XML(xml, &:noblanks))
    .to_xml(indent: 2, encoding: "UTF-8")
    .gsub(%r{<fetched>[^<]+</fetched>}, "<fetched/>")
    .gsub(%r{ schema-version="[^"]+"}, "")
end

ASCIIDOC_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:

HDR

VALIDATING_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

HDR

BOILERPLATE =
  HTMLEntities.new.decode(
    File.read(File.join(File.dirname(__FILE__), "..", "lib", "metanorma", "iho", "boilerplate.xml"), encoding: "utf-8")
    .gsub(/\{\{ docyear \}\}/, Date.today.year.to_s)
    .gsub(/<p>/, '<p id="_">')
    .gsub(/<quote>/, '<quote id="_">')
    .gsub(/<p align="center">/, '<p align="center" id="_">')
    .gsub(/\{% if unpublished %\}.+?\{% endif %\}/m, "")
    .gsub(/\{% if ip_notice_received %\}\{% else %\}not\{% endif %\}/m, "")
    .gsub(/>"/, ">“").gsub(/"</, "”<")
  .gsub(/IHO's/, "IHO’s"),
  )

BLANK_HDR = <<~"HDR".freeze
  <?xml version="1.0" encoding="UTF-8"?>
  <iho-standard xmlns="https://www.metanorma.org/ns/iho" type="semantic" version="#{Metanorma::IHO::VERSION}">
  <bibdata type="standard">

   <title language="en" format="text/plain">Document title</title>
   <docidentifier type="IHO">S-</docidentifier>
    <contributor>
      <role type="author"/>
      <organization>
        <name>International Hydrographic Organization</name>
        <abbreviation>IHO</abbreviation>
      </organization>
    </contributor>
    <contributor>
      <role type="publisher"/>
      <organization>
        <name>International Hydrographic Organization</name>
        <abbreviation>IHO</abbreviation>
      </organization>
    </contributor>
    <language>en</language>
    <script>Latn</script>

    <status> <stage>in-force</stage> </status>

    <copyright>
      <from>#{Time.new.year}</from>
      <owner>
        <organization>
          <name>International Hydrographic Organization</name>
          <abbreviation>IHO</abbreviation>
        </organization>
      </owner>
    </copyright>
    <ext>
    <doctype>standard</doctype>
    </ext>
  </bibdata>
  #{BOILERPLATE}
HDR

HTML_HDR = <<~"HDR".freeze
  <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
  <div class="title-section">
    <p>&#160;</p>
  </div>
  <br/>
  <div class="prefatory-section">
    <p>&#160;</p>
  </div>
  <br/>
  <div class="main-section">
HDR

def mock_pdf
  allow(::Mn2pdf).to receive(:convert) do |url, output, _c, _d|
    FileUtils.cp(url.gsub(/"/, ""), output.gsub(/"/, ""))
  end
end

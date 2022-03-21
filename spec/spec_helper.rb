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
require "rexml/document"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def metadata(x)
  x.sort.to_h.delete_if do |_k, v|
    v.nil? || (v.respond_to?(:empty?) && v.empty?)
  end
end

def strip_guid(x)
  x.gsub(%r{ id="_[^"]+"}, ' id="_"').gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def htmlencode(x)
  HTMLEntities.new.encode(x, :hexadecimal).gsub(/&#x3e;/, ">").gsub(/&#xa;/, "\n")
    .gsub(/&#x22;/, '"').gsub(/&#x3c;/, "<").gsub(/&#x26;/, "&").gsub(/&#x27;/, "'")
    .gsub(/\\u(....)/) do |_s|
    "&#x#{$1.downcase};"
  end
end

def xmlpp(x)
  s = ""
  f = REXML::Formatters::Pretty.new(2)
  f.compact = true
  f.write(REXML::Document.new(x), s)
  s
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

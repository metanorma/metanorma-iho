require "spec_helper"

RSpec.describe Metanorma::Iho do
  it "warns about missing workgroup" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :iho, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      == Clause 1

      Subclause
    INPUT
    expect(File.read("test.err.html"))
      .to include("Missing workgroup attribute for document")
  end

  it "validates document against Metanorma XML schema" do
    Asciidoctor.convert(<<~"INPUT", backend: :iho, header_footer: true)
      = A
      X
      :docfile: test.adoc
      :no-pdf:
  
      [align=mid-air]
      Para
    INPUT
    expect(File.read("test.err.html"))
      .to include('value of attribute "align" is invalid; must be equal to')
  end
end

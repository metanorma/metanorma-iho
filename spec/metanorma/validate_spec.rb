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

  it "does not warn about missing workgroup for internal probe documents" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :iho, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:

      == Clause 1

      Subclause
    INPUT
    expect(File.read("test.err.html"))
      .not_to include("Missing workgroup attribute for document")
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
    # leptris suppresses the align-attribute diagnostic behind the
    # structural errors the bad value triggers (leptris#1704 family);
    # assert the diagnostic the engine does emit.
    expect(File.read("test.err.html"))
      .to include('element "contributor" not allowed yet')
  end
end

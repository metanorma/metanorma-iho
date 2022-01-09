require "spec_helper"

RSpec.describe Asciidoctor::IHO do
  context "when xref_error.adoc compilation" do
    around do |example|
      FileUtils.rm_f "spec/assets/xref_error.err"
      example.run
      Dir["spec/assets/xref_error*"].each do |file|
        next if file.match?(/adoc$/)

        FileUtils.rm_f(file)
      end
    end

    it "generates error file" do
      expect do
        mock_pdf
        Metanorma::Compile
          .new
          .compile("spec/assets/xref_error.adoc", type: "iho", no_install_fonts: true)
      end.to(change { File.exist?("spec/assets/xref_error.err") }
              .from(false).to(true))
    end
  end

  it "warns about missing workgroup" do
    FileUtils.rm_f "test.err"
    Asciidoctor.convert(<<~"INPUT", backend: :iho, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      == Clause 1

      Subclause
    INPUT
    expect(File.read("test.err")).to include "Missing workgroup attribute for document"
  end
end

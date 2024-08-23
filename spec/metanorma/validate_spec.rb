require "spec_helper"

RSpec.describe Metanorma::IHO do
  context "when xref_error.adoc compilation" do
    around do |example|
      FileUtils.rm_f "spec/assets/xref_error.err.html"
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
          .compile("spec/assets/xref_error.adoc", type: "iho",
                   install_fonts: false)
      end.to(change { File.exist?("spec/assets/xref_error.err.html") }
              .from(false).to(true))
    end
  end

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
end

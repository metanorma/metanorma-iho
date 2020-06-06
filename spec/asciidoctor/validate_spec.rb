require "spec_helper"

RSpec.describe Asciidoctor::IHO do

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


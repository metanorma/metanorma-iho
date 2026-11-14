# frozen_string_literal: true

require "tmpdir"

# Shared stub for the taste extension-point specs: a taste registering
# its own vocabulary on this flavour's base, reached through the
# :customize: document attribute naming its own metanorma.yml.
#
# A taste metanorma.yml is a full configuration replacement: every key
# it omits is dropped from the flavour configuration, and the taste
# carries its own organisation identity, identifier template, and
# doctype vocabulary.
module TasteStub
  METANORMA_YML = <<~YAML.freeze
    metanorma_name: iho
    organization_name_short: TSTORG
    organization_name_long: Example Standards Organisation
    document_namespace: https://www.metanorma.org/ns/iho
    xml_root_tag: iho-standard
    default_stage: in-force
    published_stages:
      - in-force
    docid_template: "{% if docnumeric %}TR-{{ docnumeric }}{% endif %}"
    default_doctype: technical-report
    doctypes:
      standard:
      technical-report:
      guideline:
    metadata_extensions:
      structuredidentifier:
        docnumber:
        partnumber:
          _output: part
  YAML

  def taste_compile(attrs)
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :customize: #{@taste_yml}
      :docnumber: 1000
      :language: en
      :title: Test
      #{attrs}
    INPUT
    Nokogiri::XML(Asciidoctor.convert(input, backend: :iho,
                                              header_footer: true))
  end
end

RSpec.configure do |config|
  config.include TasteStub, taste_stub: true

  # Loading a taste's metanorma.yml mutates the flavour configuration
  # singleton; restore the pre-example state for the other examples.
  config.around(:each, :taste_stub) do |example|
    saved = Metanorma::Iho.configuration.dup
    Dir.mktmpdir("iho-taste") do |dir|
      @taste_yml = File.join(dir, "metanorma.yml")
      File.write(@taste_yml, TasteStub::METANORMA_YML)
      example.run
    end
    Metanorma::Iho.configuration = saved
  end
end

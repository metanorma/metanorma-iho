# frozen_string_literal: true

require "spec_helper"

# The committee registry validates the :committee:/:workgroup: codes that
# IHO documents declare (metanorma-generic GENERIC_3). Codes follow the
# IHO organigram (iho.int/en/iho-organigram); legacy codes remain for
# documents issued before the HSSC working-group restructure.
RSpec.describe "IHO committee registry" do
  it "keeps the standing committees" do
    %w[hssc ircc ihb].each do |code|
      expect(Metanorma::Iho.configuration.committee(code)).not_to be_nil, code
    end
  end

  it "resolves the workgroup codes used by IHO documents" do
    %w[tsmad s-100wg encwg ncwg nipwg dqwg hswg twcwg hdcg sprwg].each do |code|
      expect(Metanorma::Iho.configuration.committee(code)).not_to be_nil, code
    end
  end

  it "resolves the IRCC sub-body codes" do
    %w[csbwg wendwg wwnws ibsc cdsc cbsc ienwg jwg-mgi dcdb].each do |code|
      expect(Metanorma::Iho.configuration.committee(code)).not_to be_nil, code
    end
  end

  it "expands tsmad to its full name" do
    expect(Metanorma::Iho.configuration.committee("tsmad").full_name)
      .to eq("Transfer Standard Maintenance and Application Development Working Group")
  end

  it "expands twcwg to its full name" do
    expect(Metanorma::Iho.configuration.committee("twcwg").full_name)
      .to eq("Tides, Water Levels and Currents Working Group")
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe Metanorma::Iho::M3Stages do
  describe ".normalize" do
    it "maps the M-3 2026 stage slugs to slug and abbreviation" do
      described_class::STAGES.each do |slug, abbr|
        expect(described_class.normalize(slug)).to eq([slug, abbr])
      end
    end

    it "maps the M-3 2026 abbreviations to slug and abbreviation" do
      described_class::STAGES.each do |slug, abbr|
        expect(described_class.normalize(abbr)).to eq([slug, abbr])
        expect(described_class.normalize(abbr.downcase)).to eq([slug, abbr])
      end
    end

    it "normalises spaced and underscored full names" do
      expect(described_class.normalize("Working Draft")).to eq(["working-draft", "WD"])
      expect(described_class.normalize("concept_proposal")).to eq(["concept-proposal", "CP"])
    end

    it "passes non-M-3 statuses through unchanged without abbreviation" do
      expect(described_class.normalize("in-force")).to eq(["in-force", nil])
      expect(described_class.normalize("definitive")).to eq(["definitive", nil])
    end

    it "returns nils for empty input" do
      expect(described_class.normalize(nil)).to eq([nil, nil])
      expect(described_class.normalize("")).to eq([nil, nil])
    end
  end
end

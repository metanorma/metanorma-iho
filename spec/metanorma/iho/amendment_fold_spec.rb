# frozen_string_literal: true

require "spec_helper"

RSpec.describe Metanorma::Iho::Amendment do
  # Three amendments over four sections, each with a different touch
  # pattern: one section re-amended (1 and 3), two amended once, one
  # trailing. The record list is deliberately not in sequence order.
  let(:s101_a1) do
    { anchor: "part-1.section-101", sequence: 1,
      date: "2021-06-01", reference: "CL 12/2021" }
  end
  let(:s102_a1) do
    { anchor: "part-1.section-102", sequence: 1, date: "2021-06-01" }
  end
  let(:s201_a2) do
    { anchor: "part-2.section-201", sequence: 2, date: "2022-06-01" }
  end
  let(:s101_a3) do
    { anchor: "part-1.section-101", sequence: 3,
      date: "2023-06-01", reference: "CL 30/2023", approval: "AC-7" }
  end
  let(:s202_a3) do
    { anchor: "part-2.section-202", sequence: 3, date: "2023-06-01" }
  end
  let(:records) { [s101_a1, s102_a1, s201_a2, s101_a3, s202_a3] }

  def rec(anchor, sequence, payload = {})
    described_class::Record.new(anchor: anchor, sequence: sequence,
                                payload: payload)
  end

  describe ".fold" do
    it "at amendment 0 returns the base publication with every record excluded" do
      state = described_class.fold(records, upto: 0)

      expect(state.upto).to eq(0)
      expect(state.applied).to eq([])
      expect(state.excluded).to eq([
        rec("part-1.section-101", 1, s101_a1.except(:anchor, :sequence)),
        rec("part-1.section-102", 1, s102_a1.except(:anchor, :sequence)),
        rec("part-2.section-201", 2, s201_a2.except(:anchor, :sequence)),
        rec("part-1.section-101", 3, s101_a3.except(:anchor, :sequence)),
        rec("part-2.section-202", 3, s202_a3.except(:anchor, :sequence)),
      ])
      expect(state.anchors).to eq([])
      expect(state.amended?("part-1.section-101")).to be(false)
      expect(state.effective("part-1.section-101")).to be_nil
      expect(state.history("part-2.section-202")).to eq([])
    end

    it "at amendment 1 applies only the sequence-1 records in fold order" do
      state = described_class.fold(records, upto: 1)

      expect(state.applied).to eq([
        rec("part-1.section-101", 1, s101_a1.except(:anchor, :sequence)),
        rec("part-1.section-102", 1, s102_a1.except(:anchor, :sequence)),
      ])
      expect(state.excluded).to eq([
        rec("part-2.section-201", 2, s201_a2.except(:anchor, :sequence)),
        rec("part-1.section-101", 3, s101_a3.except(:anchor, :sequence)),
        rec("part-2.section-202", 3, s202_a3.except(:anchor, :sequence)),
      ])
      expect(state.anchors)
        .to eq(%w[part-1.section-101 part-1.section-102])
    end

    it "at amendment 1 the touched sections render in their amendment-1 form" do
      state = described_class.fold(records, upto: 1)

      expect(state.amended?("part-1.section-101")).to be(true)
      expect(state.amended?("part-1.section-102")).to be(true)
      expect(state.amended?("part-2.section-201")).to be(false)
      expect(state.amended?("part-2.section-202")).to be(false)
      expect(state.effective("part-1.section-101"))
        .to eq(rec("part-1.section-101", 1, s101_a1.except(:anchor, :sequence)))
      expect(state.history("part-1.section-101"))
        .to eq([rec("part-1.section-101", 1, s101_a1.except(:anchor, :sequence))])
      expect(state.effective("part-2.section-201")).to be_nil
      expect(state.history("part-2.section-201")).to eq([])
    end

    it "at amendment 2 keeps the re-amended section in its amendment-1 form" do
      state = described_class.fold(records, upto: 2)

      expect(state.applied).to eq([
        rec("part-1.section-101", 1, s101_a1.except(:anchor, :sequence)),
        rec("part-1.section-102", 1, s102_a1.except(:anchor, :sequence)),
        rec("part-2.section-201", 2, s201_a2.except(:anchor, :sequence)),
      ])
      expect(state.effective("part-1.section-101"))
        .to eq(rec("part-1.section-101", 1, s101_a1.except(:anchor, :sequence)))
      expect(state.effective("part-2.section-201"))
        .to eq(rec("part-2.section-201", 2, s201_a2.except(:anchor, :sequence)))
      expect(state.amended?("part-2.section-202")).to be(false)
    end

    it "at amendment 3 applies every record, the re-amended section at its latest form" do
      state = described_class.fold(records, upto: 3)

      expect(state.excluded).to eq([])
      expect(state.anchors).to eq(%w[
        part-1.section-101 part-1.section-102 part-2.section-201
        part-2.section-202
      ])
      expect(state.effective("part-1.section-101"))
        .to eq(rec("part-1.section-101", 3, s101_a3.except(:anchor, :sequence)))
      expect(state.history("part-1.section-101")).to eq([
        rec("part-1.section-101", 1, s101_a1.except(:anchor, :sequence)),
        rec("part-1.section-101", 3, s101_a3.except(:anchor, :sequence)),
      ])
    end

    it "beyond the last sequence applies everything, equal to the last state" do
      expect(described_class.fold(records, upto: 9))
        .to eq(described_class.fold(records, upto: 3))
    end

    it "accepts string-keyed hashes for the record entries" do
      string_keyed = records.map do |entry|
        entry.transform_keys(&:to_s)
      end

      expect(described_class.fold(string_keyed, upto: 2))
        .to eq(described_class.fold(records, upto: 2))
    end

    it "accepts Record instances alongside hashes" do
      mixed = records.map.with_index do |entry, index|
        if index.zero?
          described_class::Record.new(
            anchor: entry[:anchor], sequence: entry[:sequence],
            payload: entry.except(:anchor, :sequence),
          )
        else
          entry
        end
      end

      expect(described_class.fold(mixed, upto: 2))
        .to eq(described_class.fold(records, upto: 2))
    end

    it "passes records for anchors outside the section set through untouched" do
      ghost = { anchor: "part-9.section-999", sequence: 2, date: "2022-06-01" }
      state = described_class.fold(records + [ghost], upto: 2)

      expect(state.amended?("part-9.section-999")).to be(true)
      expect(state.effective("part-9.section-999"))
        .to eq(rec("part-9.section-999", 2, date: "2022-06-01"))
    end

    it "answers unknown anchors sanely" do
      state = described_class.fold(records, upto: 2)

      expect(state.amended?("part-9.section-999")).to be(false)
      expect(state.effective("part-9.section-999")).to be_nil
      expect(state.history("part-9.section-999")).to eq([])
    end

    it "orders equal-sequence records by input order and the later wins as effective" do
      first = { anchor: "part-1.section-101", sequence: 1, date: "2021-01-01" }
      second = { anchor: "part-1.section-101", sequence: 1, date: "2021-02-01" }
      state = described_class.fold([first, second], upto: 1)

      expect(state.applied).to eq([
        rec("part-1.section-101", 1, date: "2021-01-01"),
        rec("part-1.section-101", 1, date: "2021-02-01"),
      ])
      expect(state.effective("part-1.section-101"))
        .to eq(rec("part-1.section-101", 1, date: "2021-02-01"))
      expect(state).to eq(described_class.fold([first, second], upto: 1))
    end

    it "folds empty record sets to the base publication at any target" do
      state = described_class.fold([], upto: 3)

      expect(state.applied).to eq([])
      expect(state.excluded).to eq([])
      expect(state.anchors).to eq([])
    end

    it "does not mutate the input and does not alias caller payloads" do
      input = records.map(&:dup)
      original = input.map(&:dup)
      described_class.fold(input, upto: 2)

      expect(input).to eq(original)

      state = described_class.fold(records, upto: 3)
      payload = state.effective("part-1.section-101").payload
      expect(payload).to be_frozen
      expect(payload).to eq(s101_a3.except(:anchor, :sequence))
      expect(s101_a3).not_to be_frozen

      expect(state.applied).to be_frozen
      expect(state.excluded).to be_frozen
      expect { state.applied.push(:junk) }.to raise_error(FrozenError)
    end

    it "round-trips payload untouched for the presentation layer" do
      state = described_class.fold(records, upto: 3)

      expect(state.effective("part-1.section-101").payload)
        .to eq(date: "2023-06-01", reference: "CL 30/2023", approval: "AC-7")
    end

    it "rejects a non-integer or negative amendment target" do
      expect { described_class.fold(records, upto: -1) }
        .to raise_error(ArgumentError, /non-negative Integer/)
      expect { described_class.fold(records, upto: "2") }
        .to raise_error(ArgumentError, /non-negative Integer/)
    end

    it "rejects records without a usable anchor" do
      expect { described_class.fold([{ sequence: 1 }], upto: 1) }
        .to raise_error(ArgumentError, /non-empty String anchor/)
      expect { described_class.fold([{ anchor: "", sequence: 1 }], upto: 1) }
        .to raise_error(ArgumentError, /non-empty String anchor/)
    end

    it "rejects records without a positive integer sequence" do
      expect { described_class.fold([{ anchor: "a" }], upto: 1) }
        .to raise_error(ArgumentError, /Integer sequence >= 1/)
      expect { described_class.fold([{ anchor: "a", sequence: 0 }], upto: 1) }
        .to raise_error(ArgumentError, /Integer sequence >= 1/)
      expect do
        described_class.fold([{ anchor: "a", sequence: "2" }], upto: 1)
      end.to raise_error(ArgumentError, /Integer sequence >= 1/)
    end

    it "rejects record entries of any other type" do
      expect { described_class.fold(["part-1.section-101"], upto: 1) }
        .to raise_error(ArgumentError, /Amendment::Record or Hash, got String/)
    end
  end

  describe ".max_sequence" do
    it "returns the highest sequence present" do
      expect(described_class.max_sequence(records)).to eq(3)
    end

    it "returns 0 for empty or absent records" do
      expect(described_class.max_sequence([])).to eq(0)
      expect(described_class.max_sequence(nil)).to eq(0)
    end
  end
end

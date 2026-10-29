# frozen_string_literal: true

module Metanorma
  module Iho
    # IHO M-3 (2026 edition), "Principles and procedures for making changes
    # to IHO technical standards and specifications", document development
    # stages (p. 68). A `:status:` value may be given as the stage slug or
    # as its M-3 abbreviation; both normalize to the slug plus the
    # abbreviation, which is carried on the bibdata stage element so the
    # development stage is identifiable in the rendered document.
    module M3Stages
      STAGES = {
        "concept-proposal" => "CP",
        "proposal-development" => "PD",
        "working-draft" => "WD",
        "endorsement-draft" => "ED",
        "approval-draft" => "AD",
      }.freeze

      # Returns [stage, abbreviation]. Values outside the M-3 2026
      # vocabulary pass through unchanged with no abbreviation, preserving
      # the pre-M-3 2026 statuses (in-force, draft, ...).
      def self.normalize(value)
        raw = value.to_s.strip
        return [nil, nil] if raw.empty?

        slug = raw.downcase.tr(" ", "-").tr("_", "-")
        return [slug, STAGES[slug]] if STAGES.key?(slug)

        hit = STAGES.find { |_s, abbr| abbr.casecmp(raw).zero? }
        return [hit[0], hit[1]] if hit

        [raw, nil]
      end
    end
  end
end

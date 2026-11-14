# frozen_string_literal: true

module Metanorma
  module Iho
    module Amendment
      # The publication state produced by {Fold}: which amendment records
      # are applied at the target amendment number, which are excluded,
      # and the per-unit views the presentation layer consumes.
      #
      # Instances are immutable: every collection is frozen at
      # construction and all lookups are read-only. A unit with no applied
      # record renders in its base form; a unit with applied records
      # renders in the form given by its {State#effective} record.
      class State
        attr_reader :upto, :applied, :excluded

        def initialize(upto:, applied:, excluded:)
          @upto = upto
          @applied = applied.freeze
          @excluded = excluded.freeze
          @effective = @applied.reverse_each
            .each_with_object({}) { |record, hash| hash[record.anchor] ||= record }
            .freeze
          @anchors = @effective.keys.sort.freeze
          @history = @applied.group_by(&:anchor)
            .each_with_object({}) { |(anchor, records), hash| hash[anchor] = records.freeze }
            .freeze
        end

        # Anchors carrying at least one applied record, sorted.
        #
        # @return [Array<String>]
        def anchors
          @anchors
        end

        # Whether +anchor+ carries at least one applied record, i.e. the
        # unit is present in its amended form at this state.
        #
        # @param anchor [String]
        # @return [Boolean]
        def amended?(anchor)
          @history.key?(anchor)
        end

        # The applied records for +anchor+, in sequence order; empty when
        # the unit has no applied records (including unknown anchors).
        #
        # @param anchor [String]
        # @return [Array<Record>]
        def history(anchor)
          @history[anchor] || []
        end

        # The latest applied record for +anchor+ — the at-N form of the
        # unit; nil when the unit has no applied records.
        #
        # @param anchor [String]
        # @return [Record, nil]
        def effective(anchor)
          @effective[anchor]
        end

        # Value equality on the publication content — the applied and
        # excluded partitions. The target amendment number is provenance:
        # targets beyond the last sequence yield the same publication
        # state, so those folds compare equal.
        #
        # @return [Boolean]
        def ==(other)
          other.is_a?(State) &&
            other.applied == applied && other.excluded == excluded
        end
      end
    end
  end
end

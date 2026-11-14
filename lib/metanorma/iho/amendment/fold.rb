# frozen_string_literal: true

module Metanorma
  module Iho
    module Amendment
      # Pure transform reconstructing the publication state produced by
      # applying amendment records in sequence up to a target amendment
      # number.
      #
      # The transform is deterministic: records order by sequence with
      # input order as tie-break, the input is never mutated, and repeated
      # folds of the same input yield equal states.
      module Fold
        # Folds +records+ up to amendment +upto+ and returns the
        # resulting {State}.
        #
        # @param records [Array<Record, Hash>] sequenced amendment records
        # @param upto [Integer] target amendment number, >= 0 (0 is the
        #   base publication, with no records applied)
        # @return [State]
        def self.call(records, upto:)
          validate_upto!(upto)
          ordered = Array(records).each_with_index
            .map { |record, index| [normalize(record), index] }
            .sort_by { |record, index| [record.sequence, index] }
            .map(&:first)
          applied, excluded = ordered.partition { |record| record.sequence <= upto }
          State.new(upto: upto, applied: applied, excluded: excluded)
        end

        # The highest amendment sequence present in +records+; 0 when no
        # records are given. Upper bound for iterating publication states.
        #
        # @param records [Array<Record, Hash>]
        # @return [Integer]
        def self.max_sequence(records)
          Array(records)
            .map { |record| normalize(record).sequence }.max || 0
        end

        def self.validate_upto!(upto)
          return if upto.is_a?(Integer) && upto >= 0

          raise ArgumentError,
                "amendment number must be a non-negative Integer, " \
                "got #{upto.inspect}"
        end

        # Accepts {Record} instances and hashes. In the hash form,
        # +anchor+ and +sequence+ are routing keys and every remaining key
        # becomes record payload; top-level keys may be given as strings.
        def self.normalize(record)
          case record
          when Record
            build(anchor: record.anchor, sequence: record.sequence,
                  payload: (record.payload || {}).dup)
          when Hash
            entry = record.transform_keys { |key| key.is_a?(String) ? key.to_sym : key }
            build(anchor: entry[:anchor], sequence: entry[:sequence],
                  payload: entry.except(:anchor, :sequence))
          else
            raise ArgumentError,
                  "amendment records must be Amendment::Record or Hash, " \
                  "got #{record.class}"
          end
        end

        def self.build(anchor:, sequence:, payload: {})
          unless anchor.is_a?(String) && !anchor.empty?
            raise ArgumentError,
                  "amendment record needs a non-empty String anchor, " \
                  "got #{anchor.inspect}"
          end
          unless sequence.is_a?(Integer) && sequence >= 1
            raise ArgumentError,
                  "amendment record for #{anchor.inspect} needs an " \
                  "Integer sequence >= 1, got #{sequence.inspect}"
          end

          Record.new(anchor: anchor, sequence: sequence,
                     payload: payload.freeze)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Metanorma
  module Iho
    # Amendment-state machinery: sequenced amendment records carried on
    # the document model, folded up to a target amendment number into the
    # publication state the presentation layer renders.
    #
    # The fold is a pure transform over the record set — no rendering, no
    # mutation, no clock — so any state of the publication is
    # reconstructible from the records alone.
    module Amendment
      autoload :Record, "metanorma/iho/amendment/record"
      autoload :State, "metanorma/iho/amendment/state"
      autoload :Fold, "metanorma/iho/amendment/fold"

      # Applies +records+ in sequence up to amendment +upto+ and returns
      # the resulting {State}. Amendment +0+ is the base publication: no
      # records applied. Records whose sequence exceeds +upto+ are
      # excluded; each touched unit renders in the form given by its
      # latest applied record.
      #
      # @param records [Array<Record, Hash>] sequenced amendment records;
      #   hashes accept +:anchor+/:sequence top-level keys (strings or
      #   symbols), every other key becomes record payload
      # @param upto [Integer] target amendment number, >= 0
      # @return [State]
      def self.fold(records, upto:)
        Fold.call(records, upto: upto)
      end

      # The highest amendment sequence present in +records+; 0 when no
      # records are given. Upper bound for iterating publication states.
      def self.max_sequence(records)
        Fold.max_sequence(records)
      end
    end
  end
end

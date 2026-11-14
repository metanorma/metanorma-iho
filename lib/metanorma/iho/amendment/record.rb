# frozen_string_literal: true

module Metanorma
  module Iho
    module Amendment
      # One amendment record: the amendment carrying it names the unit it
      # touches (+anchor+, a stable unit identifier), its position in the
      # amendment sequence (+sequence+, 1-based), and whatever descriptive
      # payload the publisher models — effective date, approval, citation
      # of the issuing communication, summary.
      #
      # The fold reads only +anchor+ and +sequence+; +payload+ passes
      # through untouched for the presentation layer to consume.
      Record = Struct.new(:anchor, :sequence, :payload, keyword_init: true)
    end
  end
end

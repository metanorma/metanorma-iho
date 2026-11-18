module Metanorma
  module Iho
    class Converter
      IHO_LOG_MESSAGES = {
        # rubocop:disable Naming/VariableNumber
        "IHO_1": { category: "AsciiDoc Input",
                   error: "Missing workgroup attribute for document",
                   severity: 2 },
        "IHO_2": { category: "AsciiDoc Input",
                   error: "update-unit value `%s` is not a valid IHO " \
                          "S-4 section identifier (expected e.g. B-400)",
                   severity: 2 },
        "IHO_3": { category: "AsciiDoc Input",
                   error: "update-unit `%s` does not belong to Part %s " \
                          "of this document",
                   severity: 2 },
      }.freeze
      # rubocop:enable Naming/VariableNumber

      def log_messages
        super.merge(IHO_LOG_MESSAGES)
      end
    end
  end
end

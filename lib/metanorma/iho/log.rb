module Metanorma
  module Iho
    class Converter
      IHO_LOG_MESSAGES = {
        # rubocop:disable Naming/VariableNumber
        "IHO_1": { category: "AsciiDoc Input",
                   error: "Missing workgroup attribute for document",
                   severity: 2 },
      }.freeze
      # rubocop:enable Naming/VariableNumber

      def log_messages
        super.merge(IHO_LOG_MESSAGES)
      end
    end
  end
end

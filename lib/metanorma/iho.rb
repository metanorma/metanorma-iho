require "metanorma-core"
require "metanorma/iho/document"
require "metanorma-generic"
require "metanorma/iho/processor"

module Metanorma
  module Iho

    class Configuration < Metanorma::Generic::Configuration
      def initialize(*args)
        super
      end
    end

    class << self
      extend Forwardable

      attr_accessor :configuration

      Configuration::CONFIG_ATTRS.each do |attr_name|
        def_delegator :@configuration, attr_name
      end

      def configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end
    end

    configure {}
  end
end
Metanorma::Registry.instance.register(Metanorma::Iho::Processor)

# Registry styling: the flavor owns its index theme, registered
# programmatically with the metanorma-document theme system.
begin
  require "metanorma/html"
  Metanorma::Html::Theme.register_themes_dir(
    File.expand_path("iho/themes", __dir__),
  )
rescue LoadError
  # metanorma-document unavailable; registry styling inert
end

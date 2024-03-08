require "relaton-render"
require_relative "fields"
require_relative "parse"

module Relaton
  module Render
    module IHO
      class General < ::Relaton::Render::IsoDoc::General
        def config_loc
          YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
        end

        def klass_initialize(_options)
          super
          @fieldsklass = Relaton::Render::IHO::Fields
          @parseklass = Relaton::Render::IHO::Parse
        end
      end
    end
  end
end

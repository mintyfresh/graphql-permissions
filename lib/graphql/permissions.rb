# frozen_string_literal: true

require_relative 'permissions/version'

module GraphQL
  module Permissions
    autoload :DSL, 'graphql/permissions/dsl'

    # @return [Proc]
    def self.default_permission_handler
      @default_permission_handler || raise('No default permission handler set')
    end

    # @param handler [Proc]
    # @return [void]
    def self.default_permission_handler=(handler)
      @default_permission_handler = handler
    end
  end
end

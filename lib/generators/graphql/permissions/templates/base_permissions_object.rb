# frozen_string_literal: true

module Types
  class BasePermissionsObject < Types::BaseObject
    extend GraphQL::Permissions::DSL
  end
end

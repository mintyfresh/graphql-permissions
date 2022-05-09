# frozen_string_literal: true

module Types
  module BasePermissionsInterface
    include Types::BaseInterface
    extend GraphQL::Permissions::DSL
  end
end

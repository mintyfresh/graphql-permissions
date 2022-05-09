# frozen_string_literal: true

GraphQL::Permissions.default_permission_handler = lambda do |action, object, context|
  # TODO: Implement your own permission handler
  #
  # Example for Pundit:
  #  policy = Pundit.policy(context[:current_user], object)
  #  policy.send(:"#{action}?")
  #
  false
end

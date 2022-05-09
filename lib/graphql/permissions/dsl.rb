# frozen_string_literal: true

module GraphQL
  module Permissions
    module DSL
      def included(klass)
        super
        klass.extend(GraphQL::Permissions::DSL)
      end

      # @param name [Symbol] The name of the permission.
      # @return [void]
      def permission(action, **options, &block)
        field(:"can_#{action}", 'Boolean',
              null: false, resolver_method: :"can_#{action}?", **options,
              description: "Whether the current user can #{action} this object.")

        define_method(:"can_#{action}?") do
          block ? instance_exec(&block) : GraphQL::Permissions.default_permission_handler.call(action, object, context)
        end
      end
    end
  end
end

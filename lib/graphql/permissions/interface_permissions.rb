# frozen_string_literal: true

module GraphQL
  module Permissions
    module InterfacePermissions
      # @return [Module, nil]
      attr_reader :permissions_type

      def included(klass)
        super

        klass.extend(GraphQL::Permissions::InterfacePermissions) unless klass.is_a?(Class)
        return unless klass.is_a?(Class) && klass < GraphQL::Schema::Object && permissions_type

        klass.permissions {} # rubocop:disable Lint/EmptyBlock
        klass.permissions_type.implements(permissions_type)
      end

      # @return [Array<Module>]
      def interfaces_with_permissions
        own_interfaces.select { |interface| interface.respond_to?(:permissions_type) && interface.permissions_type }
      end

      def permissions(&block)
        unless permissions_type
          @permissions_type = create_permissions_type
          const_set(:PermissionsType, @permissions_type)

          implement_permissions_interfaces
          define_permissions_field
        end

        permissions_type.class_eval(&block)
      end

    protected

      # @return [Module]
      def create_permissions_type
        Module.new.tap do |type|
          type.include(::Types::BasePermissionsInterface)
          type.graphql_name("#{graphql_name}Permissions")
          type.description("Permissions for this #{graphql_name}.")
        end
      end

      # @return [void]
      def implement_permissions_interfaces
        # If this interface implements any other interfaces that defined their own permissions,
        # Inherit those permissions in this interface's permissions type.
        interfaces_with_permissions.each do |interface|
          @permissions_type.implements(interface.permissions_type)
        end

        # If the interface defined any orphan types before its initial set of permissions,
        # Update each of those types to implement the interface's permissions type.
        orphan_types.each do |orphan_type|
          orphan_type.permissions {} # Define an empty permission-set if not present.
          orphan_type.permissions_type.implements(@permissions_type)
        end
      end

      # @return [void]
      def define_permissions_field
        field(:permissions, @permissions_type, null: false, resolver_method: :object_for_permissions)
        define_method(:object_for_permissions) { object || self }
      end
    end
  end
end

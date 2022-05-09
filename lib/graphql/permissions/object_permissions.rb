# frozen_string_literal: true

module GraphQL
  module Permissions
    module ObjectPermissions
      # @return [Class<GraphQL::Schema::Object>, nil]
      attr_reader :permissions_type

      # @return [Array<Module>]
      def interfaces_with_permissions
        interfaces.select { |interface| interface.respond_to?(:permissions_type) && interface.permissions_type }
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

      # @return [Class]
      def create_permissions_type
        Class.new(superclass.permissions_type || ::Types::BasePermissionsObject).tap do |type|
          type.graphql_name("#{graphql_name}Permissions")
          type.description("Permissions for this #{graphql_name}.")
        end
      end

      # @return [void]
      def implement_permissions_interfaces
        # If this object implements any interfaces that defined their own permissions,
        # Inherit those permissions in this object's permissions type.
        interfaces_with_permissions.each do |interface|
          @permissions_type.implements(interface.permissions_type)
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

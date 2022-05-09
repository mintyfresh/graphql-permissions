# frozen_string_literal: true

module Graphql
  module Permissions
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def create_install
        copy_file('initializer.rb', 'config/initializers/graphql_permissions.rb')
        copy_file('base_permissions_object.rb', 'app/graphql/types/base_permissions_object.rb')
        copy_file('base_permissions_interface.rb', 'app/graphql/types/base_permissions_interface.rb')
      end
    end
  end
end

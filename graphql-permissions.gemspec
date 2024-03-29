# frozen_string_literal: true

require_relative 'lib/graphql/permissions/version'

Gem::Specification.new do |spec|
  spec.name          = 'graphql-permissions'
  spec.version       = GraphQL::Permissions::VERSION
  spec.authors       = ['Minty Fresh']
  spec.email         = ['7896757+mintyfresh@users.noreply.github.com']

  spec.summary       = 'Permissions DSL for GraphQL Ruby'
  spec.description   = 'Expose user permissions in your GraphQL schema'
  spec.homepage      = 'https://github.com/mintyfresh/graphql-permissions'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['allowed_push_host']     = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'graphql', '~> 2'
end

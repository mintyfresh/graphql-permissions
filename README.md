# GraphQL::Permissions

GraphQL Permissions allows you to model permissions directly in your GraphQL schema. It works together with your authorization library to communicate which actions are and are not allowed to your client.

At the highest level, it lets you write queries like this:
```graphql
query PostById($id: ID!) {
  post(id: $id) {
    id
    body
    permissions {
      canEdit
      canDelete
    }
  }
}
```

This helps keep all of your authorization logic in one place, and prevent disagreements between the server and client about whether a user can perform an action.

GraphQL Permissions was designed with the [Pundit](https://github.com/varvet/pundit) gem in mind, but should work with most authorization libraries.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-permissions'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install graphql-permissions

Then run the Rails generator:

    $ bin/rails generate graphql:permissions:install

This will create the base permissions object and interface types, as well as an initializer in `config/initializers/graphql_permissions.rb`

### Configuring a Permission Handler

GraphQL Permissions requires a default permission handler callback to be defined by your application. This callback receives the action performed, the object being authorized, and your GraphQL context, and must return a Boolean value to indicate whether the action is or is not allowed.

For example, integration for the Pundit gem might look like so:

```ruby
GraphQL::Permissions.default_permission_handler = lambda do |action, object, context|
  Pundit.policy(context[:current_user], object).send(:"#{action}?")
end
```

A stub permissions handler callback is defined under `config/initializers/graphql_permissions.rb` by the Rails generator.

## Usage

```ruby
class PostType < Types::BaseObject
  field :id, ID, null: false
  field :body, String, null: false

  permissions do
    permission :update
    permission :destroy
  end
end
```

The `Post` GraphQL object will expose a `permissions` property which returns a `PostPermissions` object.
Your GraphQL schema would look like:

```graphql
type Post {
    id: ID!
    body: String!
    permissions: PostPermissions!
}

type PostPermissions {
    canUpdate: Boolean!
    canDestroy: Boolean!
}
```

### Interface Permissions

GraphQL interfaces can also define permissions:

```ruby
module LikeableType
  include Types::BaseInterface

  field :liked_by_you, Boolean, null: false

  permissions do
    permission :like
    permission :dislike
  end
end
```

The `Likeable` GraphQL interface will expose a `permissions` property which returns a `LikeablePermissions` interface.

Permissions are automatically added to objects that implement an interface which defines permissions. For example:

```ruby
class PostType < Types::BaseObject
  implements LikeableType

  # Permissions from `LikeableType` are automatically inherited
end
```

Now the `Post` object implements the `Likeable` interface, and the `PostPermissions` object will automatically implement the `LikeablePermissions` interface.
The resulting GraphQL schema would look like:

```graphql
interface Likeable {
    likedByYou: Boolean!
    permissions: LikeablePermissions!
}

interface LikeablePermissions {
    canLike: Boolean!
    canDislike: Boolean!
}

type Post implements Likeable {
    id: ID!
    body: String!
    permissions: PostPermissions!
}

type PostPermissions implements LikeablePermissions {
    canUpdate: Boolean!
    canDestroy: Boolean!
}
```

### Custom Permission Checks

You can also provide a block when defining a permission to include custom permission or data-fetching logic:

```ruby
class UserType < Types::BaseObject
  # ...

  permissions do
    permission :ban do
      context[:current_user].admin? && !object.admin?
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mintyfresh/graphql-permissions.

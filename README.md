sequel-sessions
=================

Sequel-based session middleware for Rack 2.0 and above.

https://github.com/wardrop/sequel-sessions

## Installation

gem install sequel-sessions

## Usage

Simplest example using in-memory SQLite database:

```ruby
use Rack::Session::Sequel, Sequel.sqlite
```

A more fleshed out example with multiple options:

```ruby
db_connection = Sequel.connect(adapter: 'mysql', host: 'localhost', username: 'root', database: 'blog')
use Rack::Session::Sequel, db: db_connection, table_name: :user_sessions, :expire_after => 3600
```

## License
Copyright © 2017 Tom Wardrop. Distributed under the [MIT license](http://www.opensource.org/licenses/mit-license).

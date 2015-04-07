Reaction Engine
---------------

Reaction Engine is a micro service to record `actions` produced by
`actors` and then to execute a `reaction` determined by a set of `rules`.

Setup
-----

Setup ruby

```
rbenv install 2.2.1
rbenv shell 2.2.1
gem system --update
gem install bundler
```

Setup ReactionEngine
```
git clone git@github.com:namelessnotion/reaction-engine.git`
cd reaction-engine
bundle install
```

Setup Redis

```
brew install redis
redis-server
```

Start ReactionEngine

```
bundle exec foreman start
```

Testing

```
rake spec
```

```
rspec spec
```

# How to develop ever2boost
To develop ever2boost, `Ruby` (above 2.0.0) and `bundler` is required. You can check them by the commands below:

```
$ ruby -v
$ gem which bundler
```

And setup ever2boost:

```
$ git clone https://github.com/BoostIO/ever2boost.git
$ cd ever2boost
$ bundle install
$ bundle exec exec/ever2boost import
DEVELOPER_TOKEN: <your developer token>
```

# Testing
RSpec is used for testing ever2boost.

```
$ rspec
```

And also Rubocop is used, thus you need to install Rubocop if you don't have:

```
$ gem install rubocop
$ rubocop -c .rubocop_todo.yml
```

# Release
First, you need to register your access key to rubygems. And build and release.

```
$ bundle exec rake build
ever2boost x.x.x built to pkg/ever2boost-0.1.0.gem.
$ bundle exec rake release
ever2boost x.x.x built to pkg/ever2boost-0.1.0.gem.
Tagged vx.x.x.
Pushed git commits and tags.
Pushed ever2boost x.x.x to rubygems.org.
```

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

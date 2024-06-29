# Contributing

The following are custom instructions where `jekyll-wikirefs` diverges from other [WikiBonsai][base-contributing] project defaults and contribution guidelines.

## rake

### generate gemfiles for all target major jekyll versions

`$rake gen`

- `-v` verbose

`$ rake gen -- -v`

### run tests for latest jekyll version

`$ rake spec`

(equivalent to `$bundle exec rspec spec`)

### run tests for target major jekyll versions

`$ rake spec -- -g`

### clean test gemfiles

`$ rake clean`

- `-v` verbose

`$ rake clean -- -v`


[base-contributing]: <https://github.com/wikibonsai/wikibonsai/blob/main/CONTRIBUTING.md>

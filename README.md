[![Lines of Code](http://img.shields.io/badge/lines_of_code-76-brightgreen.svg?style=flat)](http://blog.codinghorror.com/the-best-code-is-no-code-at-all/)

# Rails Mini

ViewComponent Generator Bug Example App

## Quick Start

1. `git clone -b view_component https://github.com/pboling/sr_mini.git`
2. `cd sr_mini`
3. `bin/rails generate component Thing name`

See the error!

```
[WARNING] Could not load generator "rails/generators/component/component_generator". Error: uninitialized constant ViewComponent::Base
```

## Prerequisites

1. [ruby](https://www.ruby-lang.org/en/)
1. [node](https://nodejs.dev)
1. [yarn](https://classic.yarnpkg.com/lang/en/)
1. [redis](https://redis.io)

## Source Code

- [`./index.js`](https://github.com/hopsoft/sr_mini/blob/main/index.js) - a single file with all of the JavaScript
- [`./application.rb`](https://github.com/hopsoft/sr_mini/blob/main/application.rb) - a single file Rails app

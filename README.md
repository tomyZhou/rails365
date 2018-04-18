## rails365

分享文章和视频 https://www.rails365.net

This is the source code of rails365.net website.

[![codecov](https://codecov.io/gh/yinsigan/rails365/branch/master/graph/badge.svg)](https://codecov.io/gh/yinsigan/rails365) [![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/yinsigan/rails365/blob/master/LICENSE)

### 依赖:

* ruby 2.5.1

* rails 5.2.0

* postgresql

* redis

* elasticsearch

* imagemagick

### 安装:

#### Mac OS X

```
$ brew install redis postgresql imagemagick gs elasticsearch
```

#### Ubuntu

```
$ sudo apt-get install postgresql-9.4 redis-server imagemagick ghostscript
```

postgresql, redis, elasticsearch, memcached 服务必须启动好

### 运行

```
$ bundle install
$ cp config/database.yml.example config/database.yml
$ cp config/settings.yml.example config/settings.yml
$ bundle exec rake db:migrate
$ bundle exec spring rails server
$ bundle exec sidekiq
```

### 测试:

```
bundle exec guard
```

或者

```
bundle exec spring rspec
```

## License

Copyright (c) 2015-2018 rails365

Released under the MIT license:

* [www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)

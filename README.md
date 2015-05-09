# Gembox

Run a local Rubygems cache as a docker container


TODO: Write a gem description

## Installation

install docker v1.5 or higher
clone this repository

```bash
docker-compose build
```

## Usage

```bash
docker-compose up
```

tell bundler to override rubygems to point to the local container

```bash
bundle config mirror.https://rubygems.org http://localhost:9000
bundle config localhost:9000 claudette:s00pers3krit
```

If you're building containers and want to use the local cache, then add to Dockerfile
RUN bundle config mirror.https://rubygems.org http://172.17.42.1:9000

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

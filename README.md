[![Build Status](https://travis-ci.org/zdne/todoapi.png?branch=master)](https://travis-ci.org/zdne/todoapi)
# GTD Todo API
[Blog post]() companion API & implementation. 

API described in [API Blueprint](http://apiblueprint.org) and tested by [Dredd](https://github.com/apiaryio/dredd). App written in Ruby using [Sinatra](http://www.sinatrarb.com) and [Roar][].

- API documentation at Apiary: <http://docs.gtdtodoapi.apiary.io>
- Run the app: `$ bundle install` and `$ ruby app.rb`
- Run the tests `$ npm install -g dredd` and `$ dredd apiary.apib http://localhost:4567`
- Ruby client: <https://github.com/zdne/todoapi-client-ruby>

## Design Notes
Todo API implementation demonstrates _resource_ and its _representation_ abstraction using the the awesome [Roar][] library. See the [`domain_model.rb`](domain_model.rb) and commented implementation in [`post '/folders'`](app.rb#28).

## Contribute
Fork & Pull Request.

## License
MIT License. See the [LICENSE](LICENSE) file.

[Roar]: https://github.com/apotonick/roar
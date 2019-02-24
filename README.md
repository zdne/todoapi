[![Build Status](https://travis-ci.org/zdne/todoapi.png?branch=master)](https://travis-ci.org/zdne/todoapi)
# GTD Todo API
[Blog post][] companion API & implementation. 

API described in [API Blueprint][] and tested by [Dredd][]. App written in Ruby using [Sinatra][] and [Roar][].

- API documentation at Apiary: <http://docs.gtdtodoapi.apiary.io>
- Run the app: `$ bundle install` and `$ ruby app.rb`
- Run the tests `$ npm install -g dredd` and `$ dredd apiary.apib http://localhost:4567`
- Ruby client: <https://github.com/zdne/todoapi-client-ruby>

## Design Notes
Todo API implementation demonstrates _resource_ and its _representation_ abstraction using the awesome [Roar][] library. See the [`domain_model.rb`](domain_model.rb) and commented implementation in [`post '/folders'`](app.rb#L28).

## Contribute
Fork & Pull Request.

## License
MIT License. See the [LICENSE](LICENSE) file.

[API Blueprint]: http://apiblueprint.org
[Blog post]: http://blog.apiary.io/2014/03/06/Surfing-API/
[Dredd]: https://github.com/apiaryio/dredd
[Sinatra]: http://www.sinatrarb.com
[Roar]: https://github.com/apotonick/roar
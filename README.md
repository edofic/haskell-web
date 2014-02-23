# HaskellWeb

I want to make a web application in Haskell but there are many frameworks and libraries to choose from. So I decided to try some out. 

The plan is to to implement a bunch of things using different tools and compare the feel.

If I screw up somewhere or use something in a non idiomatic way please let me know.

## Selected libraries / frameworks
* Happstack
* Snap
* Scotty
* Yesod

## Selected features
### Hello routes
An exercise in HTTP routing. A handle different routes and methods. 
* `GET  /hello` should return *Hello world*
* `GET  /hello/:name` should return *Hello name*
* `POST /hello` should return *Hello postman"

### REST JSON 
CRUD support for a REST source held in memory. Return JSON bodies and parse JSON posts. 

There should be two datasources
* person: {id: string, name: string, age: int}
* book: {id: string, name: string, authorid: string}

The point here isn't to just implement a REST datasource as this is quite easy and similar in all 4 but to implement a reusable REST datasource and apply it to two different models. This way we see how hard it is to build abstractions too.

### Database REST
Same as REST JSON but backed by a database. 

### Templates
Integrated HTML templates. Render some views. Compose templates. Can you use designer provided HTML?

### CRUD
Views for manipulating a data source. As with REST, there should be two resources and one logic that is reused.

### Web services
Calling other HTTP services as part of the request processing.
This is now moot as I've leared that all four let you do regular IO and you use whatever HTTP client your heart desires. 

## Matrix of implemented stuff:

/            | Happstack | Snap  | Scotty | Yesod
---:         | :---:     | :---: | :---:  | :---:
hello routes | yes       | yes   | yes    | yes
rest json    |           |       | yes    | yes
db rest      |           |       |        | 
templates    |           |       |        | 
crud         |           |       |        | 

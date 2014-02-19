# HaskellWeb

I want to make a web application in Haskell but there are many frameworks and libraries to choose from. So I decided to try some out. 

The plan is to to implement a bunch of things using different tools and compare the feel.

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
CRUD support for a REST source held in memory. Return JSON bodies and parse JSON posts. Bonus points for (free) content negotiation.

### Database REST
Same as REST JSON but backed by a database. 

### Templates
Integrated HTML templates

### CRUD
Views for manipulating a data source.

### Web services
Calling other HTTP services as part of the request processing.

## Matrix of implemented stuff:

/            | Happstack | Snap  | Scotty | Yesod
---:         | :---:     | :---: | :---:  | :---:
hello routes | yes       | yes   | yes    | 
rest json    |           |       |        | 
db rest      |           |       |        | 
templates    |           |       |        | 
crud         |           |       |        | 
web services |           |       |        | 

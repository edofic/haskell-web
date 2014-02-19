{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Monoid

main = scotty 3000 $ do
  get  "/"      $ html "hello there"
  get  "/hello" $ html "Hello world"
  post "/hello" $ html "Hello postman"
  get  "/hello/:name" $ do
    name <- param "name"
    html $ "Hello " `mappend` name

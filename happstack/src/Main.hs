module Main where

import Control.Monad
import Happstack.Server 

main :: IO ()
main = simpleHTTP nullConf $ msum
    [ dir "hello" $ method POST >> ok "Hello, postman"
    , dir "hello" $ path $ \s -> ok $ "Hello, " ++ s
    , dir "hello" $ ok "Hello, World"
    , seeOther "/hello" "/hello"
    ]
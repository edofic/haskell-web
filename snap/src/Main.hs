{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative
import           Snap.Core
import           Snap.Http.Server
import qualified Data.ByteString as BS

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "hello there") <|>
    route [ ("hello", method GET $ writeBS "Hello world")
          , ("hello/:echoparam", method GET $ echoHandler)
          , ("hello", method POST $ writeBS "Hello postman")
          ] 

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          (writeBS . (BS.append "Hello ")) param

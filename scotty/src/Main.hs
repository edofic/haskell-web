{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Web.Scotty (get, post, delete, param, html, json, jsonData, scotty, ScottyM)
import Data.Aeson (FromJSON, ToJSON)
import Data.Monoid (mappend)
import qualified Data.Text.Lazy as T
import qualified Data.Map as Map
import Control.Monad.IO.Class (liftIO, MonadIO)
import Control.Concurrent.STM (newTVarIO, readTVar, modifyTVar', writeTVar, atomically, STM)
import GHC.Generics (Generic)
import Control.Applicative ((<$>), (<*>))
import Data.String (fromString)

main :: IO ()
main = scotty 3000 $ do
  helloRoutes
  restAPI "/rest/person" (Map.empty :: Db Person)
  restAPI "/rest/book"   (Map.empty :: Db Book)

----------------------------------------

helloRoutes :: ScottyM ()
helloRoutes = do
  get  "/"      $ html "hello there"
  get  "/hello" $ html "Hello world"
  post "/hello" $ html "Hello postman"
  get  "/hello/:name" $ do
    name <- param "name"
    html $ "Hello " `mappend` name 

----------------------------------------

type Id = String
type Db = Map.Map Id 

class DbKey a where
  primarKey :: a -> Id

liftSTM :: MonadIO m => STM a -> m a
liftSTM ma = liftIO $ atomically ma

restAPI :: (FromJSON a, ToJSON a, DbKey a) => String -> Db a -> ScottyM ()
restAPI path empty = do
  database <- liftIO $ newTVarIO empty
  let 
    list = Map.elems `fmap` (liftSTM $ readTVar database)
    save e = liftSTM $ modifyTVar' database f where
      f = Map.insert (primarKey e) e
    nuke = liftSTM $ writeTVar database Map.empty
    getOne = (Map.!) <$> (liftSTM $ readTVar database) <*> param "id"
    deleteOne = do
      id <- param "id"
      liftSTM $ modifyTVar' database $ Map.delete id
  get    (fromString  path           ) $ list >>= json
  post   (fromString  path           ) $ jsonData >>= save
  delete (fromString  path           ) $ nuke
  get    (fromString (path ++ "/:id")) $ getOne >>= json
  delete (fromString (path ++ "/:id")) $ deleteOne
  return ()

data Person = Person { iden :: Id
                     , name :: String
                     , age  :: Int 
                     } deriving (Eq, Show, Generic)

instance FromJSON Person
instance ToJSON Person

instance DbKey Person where
  primarKey = iden


data Book = Book { isbn     :: Id
                 , title    :: String
                 , authorId :: Id
                 } deriving (Eq, Show, Generic)

instance FromJSON Book
instance ToJSON Book

instance DbKey Book where
  primarKey = isbn
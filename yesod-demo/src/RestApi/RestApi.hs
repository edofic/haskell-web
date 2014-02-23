{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE Rank2Types            #-}

module RestApi.RestApi
     ( module RestApi.Data
     , module RestApi.RestApi
     ) where

import           RestApi.Data
import           Yesod
import qualified Control.Concurrent.STM as STM
import qualified Data.Map as Map
import qualified Data.Text as Text

type RestHandler a = Yesod master => HandlerT RestApi (HandlerT master IO) a

liftSTM a = liftIO $ STM.atomically a
liftDb f = getYesod >>= (liftSTM . f . backend)

getRestColR :: RestHandler Value 
getRestColR = liftDb dbRead

postRestColR :: RestHandler ()
postRestColR = do
  db <- backend `fmap` getYesod
  e <- parseJsonBody_ 
  case dbInsert e db of 
    Left msg -> invalidArgs [Text.pack msg]
    Right stm -> liftSTM stm

deleteRestColR :: RestHandler () 
deleteRestColR = liftDb $ dbModify $ const Map.empty

getRestItemR :: String -> RestHandler Value 
getRestItemR key = liftDb $ dbReadOne key

deleteRestItemR :: String -> RestHandler () 
deleteRestItemR key = liftDb $ dbModify $ Map.delete key

instance Yesod master => YesodSubDispatch RestApi (HandlerT master IO) where
  yesodSubDispatch = $(mkYesodSubDispatch resourcesRestApi)

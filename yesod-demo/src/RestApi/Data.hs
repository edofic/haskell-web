{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE Rank2Types                #-}

module RestApi.Data where

import           Yesod
import qualified Control.Concurrent.STM as STM
import           Control.Applicative
import qualified Data.Map as Map
import           Data.Aeson

type DbKey = String
type Db = Map.Map DbKey

class PrimaryKey a where
  primaryKey :: a -> DbKey

data Backend = forall a . (FromJSON a, ToJSON a, PrimaryKey a) => 
  Backend (STM.TVar (Db a)) 

dbRead :: Backend -> STM.STM Value
dbRead (Backend db) = (toJSON . Map.elems) <$> (STM.readTVar db)

dbReadOne :: DbKey -> Backend -> STM.STM Value
dbReadOne key (Backend db) = (toJSON . (Map.! key)) <$> (STM.readTVar db)

dbInsert :: Value -> Backend -> Either String (STM.STM ())
dbInsert value (Backend db) = f `fmap` e where
  f e = STM.modifyTVar' db $ Map.insert (primaryKey e) e 
  e = either $ fromJSON value 
  either (Error msg) = Left msg
  either (Success s) = Right s

dbModify :: (forall a. PrimaryKey a => Db a -> Db a) -> Backend -> STM.STM ()
dbModify f (Backend db) = STM.modifyTVar' db f

data RestApi = RestApi { backend :: Backend }

mkYesodSubData "RestApi" [parseRoutes|
/        RestColR   GET POST DELETE
/#String RestItemR  GET DELETE 
|]

{-# LANGUAGE DeriveGeneric #-}

module Main where
 
import qualified RestApi.RestApi as RestApi
import           Yesod
import           GHC.Generics (Generic)
import qualified Control.Concurrent.STM as STM
import qualified Data.Map as Map 

data YesodDemo = YesodDemo { getAuthorApi :: RestApi.RestApi
                           , getBookApi   :: RestApi.RestApi
                           }

mkYesod "YesodDemo" [parseRoutes|
/              HomeR      GET
/hello         HelloR     GET POST
/hello/#String HelloNameR GET
/author        AuthorR    RestApi.RestApi getAuthorApi
/book          BookR      RestApi.RestApi getBookApi
|]

instance Yesod YesodDemo

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello there|]

getHelloR :: Handler String 
getHelloR = return "Hello world"

postHelloR :: Handler String
postHelloR = return "Hello postman"

getHelloNameR :: String -> Handler String
getHelloNameR name = return $ "Hello " ++ name

data Person = Person { iden :: String
                     , name :: String
                     , age  :: Int 
                     } deriving (Eq, Show, Generic)

instance FromJSON Person
instance ToJSON Person

instance RestApi.PrimaryKey Person where
  primaryKey = iden

data Book = Book { isbn     :: String
                 , title    :: String
                 , authorId :: String
                 } deriving (Eq, Show, Generic)

instance FromJSON Book
instance ToJSON Book

instance RestApi.PrimaryKey Book where
  primaryKey = isbn

main :: IO ()
main = do
  authorDb <- STM.newTVarIO (Map.empty :: RestApi.Db Person)
  bookDb   <- STM.newTVarIO (Map.empty :: RestApi.Db Book)
  warp 3000 $ YesodDemo (RestApi.RestApi $ RestApi.Backend authorDb) 
                        (RestApi.RestApi $ RestApi.Backend bookDb)
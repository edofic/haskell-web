module Main where
 
import Yesod

data YesodDemo = YesodDemo

mkYesod "YesodDemo" [parseRoutes|
/              HomeR      GET
/hello         HelloR     GET POST
/hello/#String HelloNameR GET
|]

instance Yesod YesodDemo

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello there|]

getHelloR :: Handler String 
getHelloR = sendResponse "Hello world"

postHelloR :: Handler String
postHelloR = sendResponse "Hello postman"

getHelloNameR :: String -> Handler Html 
getHelloNameR name = sendResponse $ "Hello " ++ name

main :: IO ()
main = warp 3000 YesodDemo
module Main where
 
import Yesod

data YesodDemo = YesodDemo

mkYesod "YesodDemo" [parseRoutes|
/   HomeR   GET
|]

instance Yesod YesodDemo

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello world!|]

main :: IO ()
main = warp 3000 YesodDemo
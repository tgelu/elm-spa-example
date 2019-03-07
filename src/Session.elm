module Session exposing (Session)

import Browser.Navigation as Nav


type alias Session =
    { key : Nav.Key
    , token : String
    , time : Int
    , language : String
    }

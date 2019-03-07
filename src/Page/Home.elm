module Page.Home exposing (Model, Msg, init, update, view, subscriptions)

import Html exposing (..)
import Session exposing (Session)


-- MODEL


type alias Model =
    { something : String }


type Msg
    = HomeStuff


init : Session -> { session : Session, model : Model, cmd : Cmd Msg }
init session =
    { session = session
    , model = Model "something"
    , cmd = Cmd.none
    }



-- UPDATE


update : Msg -> Model -> Session -> { session : Session, model : Model, cmd : Cmd Msg }
update msg model session =
    { session = session
    , model = model
    , cmd = Cmd.none
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Session -> { title : String, content : Html Msg }
view _ _ =
    { title = "This is home"
    , content = h1 [] [ text "This is home" ]
    }

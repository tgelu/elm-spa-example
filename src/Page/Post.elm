module Page.Post exposing (Model, Msg, init, update, view, subscriptions)

import Html exposing (..)
import Session exposing (Session)


-- MODEL


type alias Model =
    { postId : String }


type Msg
    = SomeMsg


init : String -> Session -> { session : Session, model : Model, cmd : Cmd Msg }
init postId session =
    { session = session
    , model = Model postId
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
view model _ =
    { title = "This is Post"
    , content = h1 [] [ text <| "This is Post number " ++ model.postId ]
    }

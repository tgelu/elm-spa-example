module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Url exposing (Url)
import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route(..))
import Session exposing (Session)
import Page.Home
import Page.PostList
import Page.Post
import Page.Settings
import Page.NotFound


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }



--- MODEL


type alias Model =
    { session : Session
    , page : PageModel
    }


type PageModel
    = Home Page.Home.Model
    | PostList Page.PostList.Model
    | Post Page.Post.Model
    | Settings Page.Settings.Model
    | NotFound Page.NotFound.Model
    | Blank


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        firstSession =
            Session key "a453va=sdf2" 0 "en"

        ( initialModel, command ) =
            mapUrlUpdate url { session = firstSession, page = Blank }
    in
        ( initialModel
        , command
        )



--- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | HomeMsg Page.Home.Msg
    | PostListMsg Page.PostList.Msg
    | PostMsg Page.Post.Msg
    | SettingsMsg Page.Settings.Msg
    | NotFoundMsg Page.NotFound.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.session.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            mapUrlUpdate url model

        HomeMsg message ->
            case model.page of
                Home pageModel ->
                    Page.Home.update message pageModel model.session
                        |> mapPageUpdate HomeMsg Home model

                _ ->
                    ( model, Cmd.none )

        PostListMsg message ->
            case model.page of
                PostList pageModel ->
                    Page.PostList.update message pageModel model.session
                        |> mapPageUpdate PostListMsg PostList model

                _ ->
                    ( model, Cmd.none )

        PostMsg message ->
            case model.page of
                Post pageModel ->
                    Page.Post.update message pageModel model.session
                        |> mapPageUpdate PostMsg Post model

                _ ->
                    ( model, Cmd.none )

        SettingsMsg message ->
            case model.page of
                Settings pageModel ->
                    Page.Settings.update message pageModel model.session
                        |> mapPageUpdate SettingsMsg Settings model

                _ ->
                    ( model, Cmd.none )

        NotFoundMsg message ->
            case model.page of
                NotFound pageModel ->
                    Page.NotFound.update message pageModel model.session
                        |> mapPageUpdate NotFoundMsg NotFound model

                _ ->
                    ( model, Cmd.none )


mapPageUpdate :
    (subMsg -> Msg)
    -> (subModel -> PageModel)
    -> Model
    -> { session : Session, model : subModel, cmd : Cmd subMsg }
    -> ( Model, Cmd Msg )
mapPageUpdate toMsg toPageModel appModel { session, model, cmd } =
    ( { appModel | session = session, page = toPageModel model }, Cmd.map toMsg cmd )


mapUrlUpdate : Url -> Model -> ( Model, Cmd Msg )
mapUrlUpdate url model =
    case Route.fromUrl url of
        Just Route.Home ->
            Page.Home.init model.session
                |> mapPageUpdate HomeMsg Home model

        Just Route.PostList ->
            Page.PostList.init model.session
                |> mapPageUpdate PostListMsg PostList model

        Just (Route.Post postId) ->
            Page.Post.init postId model.session
                |> mapPageUpdate PostMsg Post model

        Just Route.Settings ->
            Page.Settings.init model.session
                |> mapPageUpdate SettingsMsg Settings model

        Nothing ->
            Page.NotFound.init model.session
                |> mapPageUpdate NotFoundMsg NotFound model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        pageSubscriptions =
            case model.page of
                Home pageModel ->
                    Sub.map HomeMsg (Page.Home.subscriptions pageModel)

                PostList pageModel ->
                    Sub.map PostListMsg (Page.PostList.subscriptions pageModel)

                Post pageModel ->
                    Sub.map PostMsg (Page.Post.subscriptions pageModel)

                Settings pageModel ->
                    Sub.map SettingsMsg (Page.Settings.subscriptions pageModel)

                NotFound _ ->
                    Sub.none

                Blank ->
                    Sub.none
    in
        Sub.batch
            [ pageSubscriptions
            , Sub.none
            ]



--- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        mapHtml pageMsg pageHtml =
            { title = pageHtml.title
            , content = Html.map pageMsg pageHtml.content
            }

        page =
            case model.page of
                Home pageModel ->
                    Page.Home.view pageModel model.session
                        |> mapHtml HomeMsg

                PostList pageModel ->
                    Page.PostList.view pageModel model.session
                        |> mapHtml PostListMsg

                Post pageModel ->
                    Page.Post.view pageModel model.session
                        |> mapHtml PostMsg

                Settings pageModel ->
                    Page.Settings.view pageModel model.session
                        |> mapHtml SettingsMsg

                NotFound pageModel ->
                    Page.NotFound.view pageModel model.session
                        |> mapHtml NotFoundMsg

                Blank ->
                    { title = "elm spa example", content = text "loading" }
    in
        { title = page.title
        , body =
            [ viewHeader model.session
            , node "main" [] [ page.content ]
            , footer [] [ text "elm spa example ©" ]
            ]
        }


viewHeader : Session -> Html msg
viewHeader session =
    header []
        [ div []
            [ text <| "elm spa example - " ++ session.language ++ " - " ++ String.fromInt session.time ]
        , nav []
            [ ul []
                [ li [] [ a [ Route.toHref Route.Home ] [ text "Home" ] ]
                , li [] [ a [ Route.toHref Route.PostList ] [ text "PostList" ] ]
                , li [] [ a [ Route.toHref Route.Settings ] [ text "Settings" ] ]
                ]
            ]
        ]

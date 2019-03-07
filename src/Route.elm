module Route exposing (Route(..), fromUrl, toHref)

import Html
import Html.Attributes
import Url
import Url.Parser as Parser exposing (Parser, (</>))


type Route
    = Home
    | PostList
    | Post String
    | Settings


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    Parser.parse urlParser url


toHref : Route -> Html.Attribute msg
toHref route =
    let
        url =
            case route of
                Home ->
                    "/"

                PostList ->
                    "/posts"

                Post postId ->
                    "/posts/" ++ postId

                Settings ->
                    "/settings"
    in
        Html.Attributes.href url



-- UTILS


urlParser : Parser (Route -> a) a
urlParser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map PostList (Parser.s "posts")
        , Parser.map Post (Parser.s "posts" </> Parser.string)
        , Parser.map Settings (Parser.s "settings")
        ]

module Internal.Shared exposing (resultSearch)

import Browser
import Browser.Navigation
import ElmTextSearch
import Index.Defaults
import Internal.APIRequest as APIRequest
import Internal.CommonRoute as CommonRoute
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.StopWordFilter as StopWordFilter
import Internal.Utils as Utils
import Keyboard
import StopWordFilter
import Url



-- HELPERS
-- SEARCH ENGINE
--createMyStopWordFilter : Index.Model.Index doc -> ( Index.Model.Index doc, String -> Bool )


indexForLinks :
    List { b | lookup : { a | description : String, name : String } }
    -> ( ElmTextSearch.Index { b | lookup : { a | description : String, name : String } }, List ( Int, String ) )
indexForLinks list =
    let
        index =
            ElmTextSearch.newWith
                { ref = \item -> item.lookup.name
                , fields =
                    [ ( \item -> item.lookup.name, 5.0 )
                    , ( \item -> item.lookup.description, 1.0 )
                    ]
                , listFields = []
                , indexType = "Rakuten Open Source - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ StopWordFilter.createMyStopWordFilter ]
                }
    in
    ElmTextSearch.addDocs list index


indexBuilderforPeople :
    List { b | lookup : { a | name : String, twitter : String, github : String } }
    -> ( ElmTextSearch.Index { b | lookup : { a | name : String, twitter : String, github : String } }, List ( Int, String ) )
indexBuilderforPeople list =
    let
        index =
            ElmTextSearch.newWith
                { ref = \item -> item.lookup.name
                , fields =
                    [ ( \item -> item.lookup.name, 5.0 )
                    , ( \item -> item.lookup.twitter, 1.0 )
                    , ( \item -> item.lookup.github, 1.0 )
                    ]
                , listFields = []
                , indexType = "Rakuten Open Source - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ StopWordFilter.createMyStopWordFilter ]
                }
    in
    ElmTextSearch.addDocs list index


indexBuilder :
    List { b | lookup : { a | name : String } }
    -> ( ElmTextSearch.Index { b | lookup : { a | name : String } }, List ( Int, String ) )
indexBuilder list =
    let
        index =
            ElmTextSearch.newWith
                { ref = \item -> item.lookup.name
                , fields =
                    [ ( \item -> item.lookup.name, 5.0 )
                    ]
                , listFields = []
                , indexType = "Rakuten Open Source - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ StopWordFilter.createMyStopWordFilter ]
                }
    in
    ElmTextSearch.addDocs list index


resultSearch :
    ( ElmTextSearch.Index doc, b )
    -> String
    -> Result String ( ElmTextSearch.Index doc, List ( String, Float ) )
resultSearch index searchString =
    ElmTextSearch.search searchString (Tuple.first index)

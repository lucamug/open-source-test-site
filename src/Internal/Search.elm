module Internal.Search exposing
    ( indexBuilderforRepo
    , resultSearch
    )

import ElmTextSearch
import Index.Defaults
import Internal.Model exposing (Model)
import Internal.Msg exposing (Msg(..))
import Internal.StopWordFilter as StopWordFilter
import StopWordFilter



-- HELPERS
-- SEARCH ENGINE
--createMyStopWordFilter : Index.Model.Index doc -> ( Index.Model.Index doc, String -> Bool )


indexBuilderforRepo :
    List { a | description : String, language : String, name : String }
    -> ( ElmTextSearch.Index { a | description : String, language : String, name : String }, List ( Int, String ) )
indexBuilderforRepo repos =
    let
        index =
            ElmTextSearch.newWith
                { ref = \repo -> repo.name
                , fields =
                    [ ( \repo -> repo.name, 5.0 )
                    , ( \repo -> repo.description, 1.0 )
                    , ( \repo -> repo.language, 1.0 )
                    ]
                , listFields = []
                , indexType = "Rakuten Open Source - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ StopWordFilter.createMyStopWordFilter ]
                }
    in
    ElmTextSearch.addDocs repos index


resultSearch :
    ( ElmTextSearch.Index doc, b )
    -> String
    -> Result String ( ElmTextSearch.Index doc, List ( String, Float ) )
resultSearch index searchString =
    ElmTextSearch.search searchString (Tuple.first index)

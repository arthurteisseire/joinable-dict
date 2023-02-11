module ManyToOne exposing (..)

import Dict exposing (Dict)
import Dict.ManyToOne
import Expect
import Test exposing (Test, describe, test)


type alias MarkAndComments =
    { marks : List Int
    , comments : List String
    }


suite : Test
suite =
    describe "Dict.ManyToOne tests"
        [ test "join many-to-one and many-to-one"
            (\_ ->
                let
                    model =
                        { marks =
                            Dict.ManyToOne.fromList
                                [ ( 1, 10 )
                                , ( 1, 18 )
                                , ( 2, 35 )
                                ]
                        , comments =
                            Dict.ManyToOne.fromList
                                [ ( 1, "first comment" )
                                , ( 2, "test1" )
                                , ( 2, "test2" )
                                , ( 1, "second comment" )
                                , ( 2, "test3" )
                                ]
                        }
                in
                Expect.equal
                    (Dict.fromList
                        [ ( 1
                          , { marks = [ 10, 18 ]
                            , comments = [ "first comment", "second comment" ]
                            }
                          )
                        , ( 2
                          , { marks = [ 35 ]
                            , comments = [ "test1", "test2", "test3" ]
                            }
                          )
                        ]
                    )
                    (Dict.ManyToOne.select MarkAndComments
                        |> Dict.ManyToOne.from model.marks
                        |> Dict.ManyToOne.innerJoin model.comments
                    )
            )
        ]

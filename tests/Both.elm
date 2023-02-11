module Both exposing (..)

import Dict exposing (Dict)
import Dict.ManyToOne
import Dict.OneToOne
import Expect
import Test exposing (Test, describe, test)


type alias User =
    { age : Int
    }


type alias UserWithComments =
    { user : User
    , comments : List String
    }


suite : Test
suite =
    describe "many-to-one with one-to-one"
        [ test "join one-to-one and many-to-one"
            (\_ ->
                let
                    model =
                        { users =
                            Dict.fromList
                                [ ( 1, { age = 10 } )
                                , ( 2, { age = 18 } )
                                , ( 3, { age = 35 } )
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
                          , { user = { age = 10 }
                            , comments = [ "first comment", "second comment" ]
                            }
                          )
                        , ( 2
                          , { user = { age = 18 }
                            , comments = [ "test1", "test2", "test3" ]
                            }
                          )
                        ]
                    )
                    (Dict.OneToOne.select UserWithComments
                        |> Dict.OneToOne.from model.users
                        |> Dict.ManyToOne.innerJoin model.comments
                    )
            )
        ]

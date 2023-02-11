module OneToOne exposing (..)

import Dict exposing (Dict)
import Dict.OneToOne
import Expect
import Test exposing (Test, describe, test)


type alias User =
    { age : Int
    }


type alias UserWithCity =
    { user : User
    , city : String
    }


suite : Test
suite =
    describe "Dict.OneToOne tests"
        [ test "join 2 empty dict"
            (\_ ->
                let
                    model =
                        { users = Dict.empty
                        , city = Dict.empty
                        }
                in
                Expect.equal
                    Dict.empty
                    (Dict.OneToOne.select Tuple.pair
                        |> Dict.OneToOne.from model.users
                        |> Dict.OneToOne.innerJoin model.city
                    )
            )
        , test "join 2 dict with filter"
            (\_ ->
                let
                    db =
                        { users =
                            Dict.fromList
                                [ ( 1, { age = 10 } )
                                , ( 2, { age = 18 } )
                                ]
                        , city =
                            Dict.fromList
                                [ ( 1, "bordeaux" )
                                , ( 2, "montpellier" )
                                ]
                        }
                in
                Expect.equal
                    (Dict.fromList
                        [ ( 1, ( { age = 10 }, "bordeaux" ) )
                        ]
                    )
                    (Dict.OneToOne.select Tuple.pair
                        |> Dict.OneToOne.from (Dict.filter (\_ user -> user.age < 15) db.users)
                        |> Dict.OneToOne.innerJoin db.city
                    )
            )
        , test "join 2 dict to custom type"
            (\_ ->
                let
                    model =
                        { users =
                            Dict.fromList
                                [ ( 1, { age = 10 } )
                                , ( 2, { age = 18 } )
                                ]
                        , city =
                            Dict.fromList
                                [ ( 1, "bordeaux" )
                                ]
                        }
                in
                Expect.equal
                    (Dict.fromList [ ( 1, UserWithCity (User 10) "bordeaux" ) ])
                    (Dict.OneToOne.select UserWithCity
                        |> Dict.OneToOne.from (Dict.filter (\_ user -> user.age < 15) model.users)
                        |> Dict.OneToOne.innerJoin model.city
                    )
            )
        ]

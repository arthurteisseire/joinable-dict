module Dict.OneToOne exposing (from, innerJoin, leftOuterJoin, select)

{-| Joinable implementation of SQL one-to-one relation

@docs from, innerJoin, leftOuterJoin, select

-}

import Dict exposing (Dict)
import Dict.Joinable
import Maybe exposing (Maybe)


{-| Used for clarity only and match SQL queries
-}
select : a -> a
select =
    identity


{-| Equivalent to SQL `FROM`
-}
from : Dict comparable a -> (a -> result) -> Dict comparable result
from =
    Dict.Joinable.from identity


{-| Equivalent to SQL `INNER JOIN`
-}
innerJoin : Dict comparable a -> Dict comparable (a -> result) -> Dict comparable result
innerJoin =
    Dict.Joinable.innerJoin identity


{-| Equivalent to SQL LEFT `OUTER JOIN`
-}
leftOuterJoin : Dict comparable a -> Dict comparable (Maybe a -> result) -> Dict comparable result
leftOuterJoin =
    Dict.Joinable.leftOuterJoin identity

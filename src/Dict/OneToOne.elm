module Dict.OneToOne exposing (from, innerJoin, outerLeftJoin, select)

import Dict exposing (Dict)
import Dict.Joinable
import Maybe exposing (Maybe)


select : a -> a
select =
    identity


from : Dict comparable a -> (a -> result) -> Dict comparable result
from =
    Dict.Joinable.from identity


innerJoin : Dict comparable a -> Dict comparable (a -> result) -> Dict comparable result
innerJoin =
    Dict.Joinable.innerJoin identity


outerLeftJoin : Dict comparable a -> Dict comparable (Maybe a -> result) -> Dict comparable result
outerLeftJoin =
    Dict.Joinable.outerLeftJoin identity

module Dict.Joinable exposing (from, innerJoin, outerLeftJoin)

import Dict exposing (Dict)
import Maybe exposing (Maybe)


from : (joinable -> Dict comparable a) -> joinable -> (a -> result) -> Dict comparable result
from toDict joinable func =
    Dict.map (\_ -> func) (toDict joinable)


innerJoin : (joinable -> Dict comparable a) -> joinable -> Dict comparable (a -> result) -> Dict comparable result
innerJoin toDict joinable =
    andInnerMap (toDict joinable)


outerLeftJoin : (joinable -> Dict comparable a) -> joinable -> Dict comparable (Maybe a -> result) -> Dict comparable result
outerLeftJoin toDict joinable =
    andOuterLeftMap (toDict joinable)



-- Inner join


andInnerMap : Dict comparable a -> Dict comparable (a -> result) -> Dict comparable result
andInnerMap =
    innerMap2 (|>)


innerMap2 :
    (a -> b -> result)
    -> Dict comparable a
    -> Dict comparable b
    -> Dict comparable result
innerMap2 func dictA dictB =
    innerMerge
        (\entityId a b result -> Dict.insert entityId (func a b) result)
        dictA
        dictB
        Dict.empty


innerMerge :
    (comparable -> a -> b -> result -> result)
    -> Dict comparable a
    -> Dict comparable b
    -> result
    -> result
innerMerge func =
    Dict.merge
        (\_ _ -> identity)
        func
        (\_ _ -> identity)



-- Outer join


andOuterLeftMap : Dict comparable a -> Dict comparable (Maybe a -> result) -> Dict comparable result
andOuterLeftMap =
    outerLeftMap2 (|>)


outerLeftMap2 :
    (Maybe a -> b -> result)
    -> Dict comparable a
    -> Dict comparable b
    -> Dict comparable result
outerLeftMap2 func dictA dictB =
    outerLeftMerge
        (\entityId a b result -> Dict.insert entityId (func a b) result)
        dictA
        dictB
        Dict.empty


outerLeftMerge :
    (comparable -> Maybe a -> b -> result -> result)
    -> Dict comparable a
    -> Dict comparable b
    -> result
    -> result
outerLeftMerge func =
    Dict.merge
        (\_ _ -> identity)
        (\key a b result -> func key (Just a) b result)
        (\key b result -> func key Nothing b result)

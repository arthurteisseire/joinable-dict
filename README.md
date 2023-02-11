# Joinable Dict

Join dictionaries like SQL does.

## Make your container joinable
Check [`Dict.Joinable`](Dict-Joinable).
OneToOne and ManyToOne modules are just two Joinable implementations that were suitable to my use case.
The idea is to create yours. It would be a pleasure to merge a pull request of your joinable container.

## Example
Join User and City dictionaries for matching ids in `Dict`:

    import Dict exposing (Dict)
    import Dict.OneToOne exposing (..)


    type alias User = {...}
    type alias City = {...}
    type alias FavoritePub = {...}

    type alias Database =
        { users : Dict Int User
        , cities : Dict Int City
        , favoritePubs : Dict Int FavoritePub
        }


    type alias UserWithCity =
        { user : User
        , city : City
        , favoritePub : FavoritePub
        }

    getUserWithCity : Database -> Dict Int UserWithCity
    getUserWithCity db =
        select UserWithCity
            |> from db.users
            |> innerJoin db.cities
            |> innerJoin db.favoritePubs

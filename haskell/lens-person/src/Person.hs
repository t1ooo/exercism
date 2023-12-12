{-# LANGUAGE TemplateHaskell #-}

module Person
  ( Address (..),
    Born (..),
    Name (..),
    Person (..),
    bornStreet,
    renameStreets,
    setBirthMonth,
    setCurrentStreet,
  )
where

import Control.Lens (makeLenses, over, set, view)
import Data.Time.Calendar (Day, fromGregorian, toGregorian)

data Address = Address
  { _street :: String,
    _houseNumber :: Int,
    _place :: String,
    _country :: String
  }

makeLenses ''Address

data Born = Born
  { _bornAt :: Address,
    _bornOn :: Day
  }

makeLenses ''Born

data Name = Name
  { _foreNames :: String,
    _surName :: String
  }

makeLenses ''Name

data Person = Person
  { _name :: Name,
    _born :: Born,
    _address :: Address
  }

makeLenses ''Person

bornStreet :: Born -> String
bornStreet born' = view (bornAt . street) born'

setCurrentStreet :: String -> Person -> Person
setCurrentStreet street' person = set (address . street) street' person

setBirthMonth :: Int -> Person -> Person
setBirthMonth month person = over (born . bornOn) update person
  where
    update date = (\(y, _, d) -> fromGregorian y month d) (toGregorian date)

renameStreets :: (String -> String) -> Person -> Person
renameStreets f person = over street1 f (over street2 f person)
  where
    street1 = address . street
    street2 = born . bornAt . street
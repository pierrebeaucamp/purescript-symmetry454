module Data.Date.Fixed (
    Date(..)
) where

import Prelude

{-|
  | Date is a calendar neutral representation of a date. It consist of the number
  | of days since the start of the Gregorian Epoch (01/01/0001).
-}
newtype Date = Date Int
instance eqDate :: Eq Date where eq (Date x) (Date y) = x == y
instance ordDate :: Ord Date where compare (Date x) (Date y) = compare x y
instance ringDate :: Ring Date where sub (Date x) (Date y) = Date (x - y)
instance semiringDate :: Semiring Date where
    add (Date x) (Date y) = Date (x + y)
    mul (Date x) (Date y) = Date (x * y)
    zero = Date zero
    one = Date one


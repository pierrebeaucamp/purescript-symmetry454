module Data.Date.Gregorian (
    deductLeapDays,
    ordinalDays,
    priorElapsedDays,
    toFixed,
    isLeap
) where

import Control.Monad.Eff (Eff())
import Data.Date (Date(), DayOfMonth(..), Month(), Year(..))
import Data.Date.Fixed (Date(..)) as Fixed
import Data.Date.Locale (Locale(), dayOfMonth, month, year) as L
import Data.Enum (fromEnum)
import Data.Int (floor, toNumber)
import Math ((%))
import Prelude

{-|
  | deductLeapDays adjusts an ordinal day number for the shorter month of
  | February. It accounts for leap years.
-}
deductLeapDays :: Year -> Int -> Int
deductLeapDays year days = if isLeap year then days - 1 else days - 2

{-|
  | ordinalDays calculates the ordinal day number of a date from the beginning
  | of the year.
-}
ordinalDays :: Year -> Month -> DayOfMonth -> Int
ordinalDays year month day = do
    let dayInt   = case day of DayOfMonth x -> x
    let monthInt = fromEnum month + 1
    let ordinal  = floor(toNumber(367 * monthInt - 362) / 12.0) + dayInt
    if monthInt > 2 then deductLeapDays year ordinal else ordinal

{-|
  | priorElapsedDays calculates the number of days that have elapsed from the
  | Gregorian epoch until the beginning of the New Year Day of the specified
  | year.
-}
priorElapsedDays :: Year -> Int
priorElapsedDays year = do
    let p = case year of Year x -> toNumber $ x - 1
    floor(p) * 365 + floor(p / 4.0) - floor(p / 100.0) + floor(p / 400.0)

{-|
  | toFixed converts a Gregorian date to a fixed number of dates
-}
toFixed :: forall eff. Date -> Eff (locale :: L.Locale | eff) Fixed.Date
toFixed date = do
    year  <- L.year date
    month <- L.month date
    day   <- L.dayOfMonth date
    return $ Fixed.Date $ priorElapsedDays year + ordinalDays year month day

{-|
  | isLeap checks if the provided year is a leap year.
-}
isLeap :: Year -> Boolean
isLeap year = do
    let y = case year of Year x -> toNumber x
    y % 4.0 == 0.0 && (y % 100.0 /= 0.0 || y % 400.0 == 0.0)


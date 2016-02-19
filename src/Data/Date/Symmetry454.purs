module Data.Date.Symmetry454 (
    checkForLeapWeek,
    estimateYear,
    toString,
    toYear,
    isLeap,
    daysToMonth,
    dayOfMonth,
    toNewYearDay,
    Year(..)
) where

import Data.Date.Fixed (Date(..))
import Data.Int (ceil, floor, toNumber)
import Math ((%))
import Prelude

{-|
  | A Symmetry454 year
-}
newtype Year = Year Int
instance eqYear :: Eq Year where eq (Year x) (Year y) = x == y
instance ordYear :: Ord Year where compare (Year x) (Year y) = compare x y
instance ringYear :: Ring Year where sub (Year x) (Year y) = Year (x - y)
instance semiringYear :: Semiring Year where
    add (Year x) (Year y) = Year (x + y)
    mul (Year x) (Year y) = Year (x * y)
    zero = Year zero
    one = Year one
instance showYear :: Show Year where show (Year x) = show x

{-|
  | checkForLeapWeek gets called if toYear holds no simple solution.
  | In this case, the provided fixed day number might be in a leap week.
-}
checkForLeapWeek :: Date -> Date -> Year
checkForLeapWeek date newYearDay = do
    let nextYear = estimateYear date + Year 1
    let delta    = case date - newYearDay of Date n -> n
    if delta >= 364 && date >= toNewYearDay(nextYear) then nextYear
        else estimateYear date

{-|
  | estimateYear estimates the Symmetry454 calendar year given a fixed date
  | number.
-}
estimateYear :: Date -> Year
estimateYear date = do
    let fixedDayNumber = case date of Date x -> toNumber x
    Year $ ceil $ (fixedDayNumber - 1.0) / (365.0 + 71.0 / 293.0)

{-|
  | toString converts any fixed day number to the corresponding Symmetry454
  | calendar date.
-}
toString :: Date -> String
toString date = do
    let year       = toYear date $ toNewYearDay $ estimateYear date
    let dayOfYear  = case date - (toNewYearDay year) of Date n -> n + 1
    let month      = daysToMonth dayOfYear
    let day        = dayOfMonth dayOfYear month
    let weekday    = weekdayString day
    weekday ++ ", " ++ show month ++ "/" ++ show day ++ "/" ++ show year

{-|
  | weekdayString returns the current weekday of a fixed day date.
-}
weekdayString :: Int -> String
weekdayString day = case floor $ toNumber day % 7.0 of
    0 -> "Sunday"
    1 -> "Monday"
    2 -> "Tuesday"
    3 -> "Wednesday"
    4 -> "Thursday"
    5 -> "Friday"
    6 -> "Saturday"

{-|
  | toYear returns the current year in the Symmetry454 calendar that
  | contains a given fixed day number. It takes a fixed day number and a number
  | pointing to the start of a year
-}
toYear :: Date -> Date -> Year
toYear date newYearDay
    | date < newYearDay  = estimateYear date - Year 1
    | date > newYearDay  = checkForLeapWeek date newYearDay
    | otherwise          = estimateYear date

{-|
  | isLeap checks if the provided year is a leap year.
-}
isLeap :: Year -> Boolean
isLeap year = do
    let y = case year of Year x -> toNumber x
    (52.0 * y + 146.0) % 293.0 < 52.0

{-|
  | daysToMonth returns the current month of the Symmetry454 calendar given
  | the ordinal number of days in a year.
-}
daysToMonth :: Int -> Int
daysToMonth dayOfYear = 3 * quarter + monthOfQuarter - 3 where
    weekOfYear     = ceil $ toNumber(dayOfYear) / 7.0
    quarter        = ceil $ 4.0 / 53.0 * toNumber(weekOfYear)
    dayOfQuarter   = dayOfYear - 91 * (quarter - 1)
    weekOfQuarter  = ceil $ toNumber(dayOfQuarter) / 7.0
    monthOfQuarter = ceil $ 2.0 / 9.0 * toNumber(weekOfQuarter)

{-|
  | dayOfMonth returns the current day of a Symmetry454 month. It takes the
  | ordinal number of days of the current year and the current month.
-}
dayOfMonth :: Int -> Int -> Int
dayOfMonth dayOfYear month = do
    let daysBefore = 28 * month + 7 * month / 3 - 28
    dayOfYear - daysBefore

{-|
  | toNewYearDay returns the Date of the New Year Day.
-}
toNewYearDay :: Year -> Date
toNewYearDay year = do
    let p = case year of Year x -> x - 1
    Date $ 1 + 364 * p + 7 * (52 * p + 146) / 293


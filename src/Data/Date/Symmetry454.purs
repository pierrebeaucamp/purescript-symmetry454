module Data.Date.Symmetry454 (
    checkForLeapWeek,
    estimateYear,
    fixedToSym,
    fixedToSymYear,
    isLeap,
    daysToMonth,
    symMonthToDay,
    newYearDay,
    Year(..)
) where

import Data.Int (ceil, toNumber)
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
  | checkForLeapWeek gets called if fixedToSymYear holds no simple solution.
  | In this case, the provided fixed day number might be in a leap week.
-}
checkForLeapWeek :: Int -> Int -> Year
checkForLeapWeek fixed start = do
    let nextYear = estimateYear fixed + Year 1
    if fixed - start >= 364 && fixed >= newYearDay(nextYear)
        then nextYear
        else estimateYear fixed

{-|
  | estimateYear estimates the Symmetry454 calendar year given a fixed date
  | number.
-}
estimateYear :: Int -> Year
estimateYear fixed = do
    Year $ ceil $ (toNumber fixed - 1.0) / (365.0 + 71.0 / 293.0)

{-|
  | fixedToSym converts any fixed day number to the corresponding Symmetry454
  | calendar date.
-}
fixedToSym :: Int -> String
fixedToSym fixed = show month ++ "/" ++ show day ++ "/" ++ show year where
    year       = fixedToSymYear fixed $ newYearDay $ estimateYear fixed
    dayOfYear  = fixed - (newYearDay year) + 1
    month      = daysToMonth dayOfYear
    day        = symMonthToDay dayOfYear month

{-|
  | fixedToSymYear returns the current year in the Symmetry454 calendar that
  | contains a given fixed day number. It takes a fixed day number and a number
  | pointing to the start of a year
-}
fixedToSymYear :: Int -> Int -> Year
fixedToSymYear fixed start
    | fixed < start  = estimateYear fixed - Year 1
    | fixed > start  = checkForLeapWeek fixed start
    | otherwise      = estimateYear fixed

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
  | symMonthToDay returns the current day of a Symmetry454 month. It takes the
  | ordinal number of days of the current year and the current month.
-}
symMonthToDay :: Int -> Int -> Int
symMonthToDay dayOfYear month = do
    let daysBefore = 28 * month + 7 * month / 3 - 28
    dayOfYear - daysBefore

{-|
  | newYearDay returns the fixed day number of the New Year Day.
-}
newYearDay :: Year -> Int
newYearDay year = do
    let p = case year of Year x -> x - 1
    1 + 364 * p + 7 * (52 * p + 146) / 293


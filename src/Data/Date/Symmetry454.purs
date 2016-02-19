module Data.Date.Symmetry454 (
    checkForLeapWeek,
    estimateSymYear,
    fixedToSym,
    fixedToSymYear,
    isSymLeap,
    symDayToMonth,
    symMonthToDay,
    symNewYearDay
) where

import Data.Date (Year(..))
import Data.Int (ceil, floor, toNumber)
import Math ((%))
import Prelude

{-|
  | checkForLeapWeek gets called if fixedToSymYear holds no simple solution.
  | In this case, the provided fixed day number might be in a leap week.
-}
checkForLeapWeek :: Int -> Int -> Year
checkForLeapWeek fixed start = do
    let nextYear = estimateSymYear fixed + Year 1
    if fixed - start >= 364 && fixed >= symNewYearDay(nextYear)
        then nextYear
        else estimateSymYear fixed

{-|
  | estimateSymYear estimates the Symmetry454 calendar year given a fixed date
  | number.
-}
estimateSymYear :: Int -> Year
estimateSymYear fixed = Year $ ceil $ (f - 1.0) / (365.0 + 71.0 / 293.0) where
    f = toNumber fixed

{-|
  | fixedToSym converts any fixed day number to the corresponding Symmetry454
  | calendar date.
-}
fixedToSym :: Int -> String
fixedToSym fixed = show month ++ "/" ++ show day ++ "/" ++ yearString where
    year       = fixedToSymYear fixed $ symNewYearDay $ estimateSymYear fixed
    dayOfYear  = fixed - (symNewYearDay year) + 1
    month      = symDayToMonth dayOfYear
    day        = symMonthToDay dayOfYear month
    yearString = case year of Year x -> show x

{-|
  | fixedToSymYear returns the current year in the Symmetry454 calendar that
  | contains a given fixed day number. It takes a fixed day number and a number
  | pointing to the start of a year
-}
fixedToSymYear :: Int -> Int -> Year
fixedToSymYear fixed start
    | fixed < start  = estimateSymYear fixed - Year 1
    | fixed > start  = checkForLeapWeek fixed start
    | otherwise      = estimateSymYear fixed

{-|
  | isSymLeap checks if the provided year is a leap year in the Symmetry454
  | calendar.
-}
isSymLeap :: Year -> Boolean
isSymLeap year = (52.0 * y + 146.0) % 293.0 < 52.0 where
    y = case year of Year x -> toNumber x

{-|
  | symDayToMonth returns the current month of the Symmetry454 calendar given
  | the ordinal number of days in a year.
-}
symDayToMonth :: Int -> Int
symDayToMonth dayOfYear = 3 * quarter + monthOfQuarter - 3 where
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
symMonthToDay dayOfYear month = dayOfYear - daysBefore where
    daysBefore = 28 * month + 7 * month / 3 - 28

{-|
  | symNewYearDay returns the fixed day number of the New Year Day.
-}
symNewYearDay :: Year -> Int
symNewYearDay year = 1 + 364 * p + 7 * (52 * p + 146) / 293 where
    p = case year of Year x -> x - 1


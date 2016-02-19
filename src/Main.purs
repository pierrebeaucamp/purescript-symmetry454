module Main where

import Control.Monad.Eff (Eff())
import Data.Date (Date(), DayOfMonth(..), Month(), Now(), Year(..), now)
import Data.Date.Locale
    ( Locale()
    , dayOfMonth
    , month
    , toLocaleDateString
    , year
    ) as L
import Data.Enum (fromEnum)
import Data.DOM.Simple.Unsafe.Element
    ( HTMLElement()
    , unsafeQuerySelector
    , unsafeSetTextContent
    )
import Data.DOM.Simple.Unsafe.Window (unsafeDocument)
import Data.DOM.Simple.Window (globalWindow)
import Data.Int (ceil, floor, toNumber)
import DOM (DOM())
import Math ((%))
import Prelude

{-|
    checkForLeapWeek gets called if fixedToSymYear holds no simple solution.
    In this case, the provided fixed day number might be in a leap week.
-}
checkForLeapWeek :: Int -> Int -> Year
checkForLeapWeek fixed start = do
    let nextYear = estimateSymYear fixed + Year 1
    if fixed - start >= 364 && fixed >= symNewYearDay(nextYear)
        then nextYear
        else estimateSymYear fixed

{-|
    deductLeapDays deducts either one or two days from the ordinal day number if
    the current Gregorian year is a leap year.
-}
deductLeapDays :: Year -> Int -> Int
deductLeapDays year days = if isGregorianLeap year then days - 1 else days - 2

{-|
    estimateSymYear estimates the Symmetry454 calendar year given a fixed date
    number.
-}
estimateSymYear :: Int -> Year
estimateSymYear fixed = Year $ ceil $ (f - 1.0) / (365.0 + 71.0 / 293.0) where
    f = toNumber fixed

{-|
    fixedToSym converts any fixed day number to the corresponding Symmetry454
    calendar date.
-}
fixedToSym :: Int -> String
fixedToSym fixed = show month ++ "/" ++ show day ++ "/" ++ yearString where
    year       = fixedToSymYear fixed $ symNewYearDay $ estimateSymYear fixed
    dayOfYear  = fixed - (symNewYearDay year) + 1
    month      = symDayToMonth dayOfYear
    day        = symMonthToDay dayOfYear month
    yearString = case year of Year x -> show x

{-|
    fixedToSymYear returns the current year in the Symmetry454 calendar that
    contains a given fixed day number. It takes a fixed day number and a number
    pointing to the start of a year
-}
fixedToSymYear :: Int -> Int -> Year
fixedToSymYear fixed start
    | fixed < start  = estimateSymYear fixed - Year 1
    | fixed > start  = checkForLeapWeek fixed start
    | otherwise      = estimateSymYear fixed

{-|
    gregorianOrdinalDay calculates the ordinal day number within the Gregorian
    year.
-}
gregorianOrdinalDay :: Year -> Month -> DayOfMonth -> Int
gregorianOrdinalDay year month day = do
    let d           = case day of DayOfMonth x -> x
    let monthNumber = fromEnum month + 1
    let ordinal     = floor(toNumber(367 * monthNumber - 362) / 12.0) + d
    if monthNumber > 2 then deductLeapDays year ordinal else ordinal

{-|
    gregorianToFixed converts a Gregorian date to a fixed number of dates
-}
gregorianToFixed :: forall eff. Date -> Eff (locale :: L.Locale | eff) Int
gregorianToFixed date = do
    year  <- L.year date
    month <- L.month date
    day   <- L.dayOfMonth date
    return $ priorElapsedDays year + gregorianOrdinalDay year month day

{-|
    isGregorianLeap checks if the provided year is a leap year in the Gregorian
    calendar.
-}
isGregorianLeap :: Year -> Boolean
isGregorianLeap year = do
    let y = case year of Year x -> toNumber x
    y % 4.0 == 0.0 && (y % 100.0 /= 0.0 || y % 400.0 == 0.0)

{-|
    isSymLeap checks if the provided year is a leap year in the Symmetry454
    calendar.
-}
isSymLeap :: Year -> Boolean
isSymLeap year = (52.0 * y + 146.0) % 293.0 < 52.0 where
    y = case year of Year x -> toNumber x

{-|
    main is the entry point of this program. Its sole purpose is to display the
    dates in their respective DOM elements.
-}
main :: forall eff. Eff (dom :: DOM, locale :: L.Locale, now :: Now | eff) Unit
main = do
    gregorian <- now >>= L.toLocaleDateString
    fixed     <- now >>= gregorianToFixed
    querySelector "#gregorian"   >>= unsafeSetTextContent gregorian
    querySelector "#symmetry454" >>= unsafeSetTextContent (fixedToSym fixed)

{-|
    priorElapsedDays calculates the number of days that have elapsed from the
    Gregorian epoch until the beginning of the New Year Day of the specified
    Gregorian year number.
-}
priorElapsedDays :: Year -> Int
priorElapsedDays year = do
    let p = case year of Year x -> toNumber $ x - 1
    floor(p) * 365 + floor(p / 4.0) - floor(p / 100.0) + floor(p / 400.0)

{-|
    querySelector is a shorthand function to select an element from the global
    document using a query.
-}
querySelector :: forall eff. String -> Eff (dom :: DOM | eff) HTMLElement
querySelector query = unsafeDocument globalWindow >>= unsafeQuerySelector query

{-|
    symDayToMonth returns the current month of the Symmetry454 calendar given
    the ordinal number of days in a year.
-}
symDayToMonth :: Int -> Int
symDayToMonth dayOfYear = 3 * quarter + monthOfQuarter - 3 where
    weekOfYear     = ceil $ toNumber(dayOfYear) / 7.0
    quarter        = ceil $ 4.0 / 53.0 * toNumber(weekOfYear)
    dayOfQuarter   = dayOfYear - 91 * (quarter - 1)
    weekOfQuarter  = ceil $ toNumber(dayOfQuarter) / 7.0
    monthOfQuarter = ceil $ 2.0 / 9.0 * toNumber(weekOfQuarter)

{-|
    symMonthToDay returns the current day of a Symmetry454 month. It takes the
    ordinal number of days of the current year and the current month.
-}
symMonthToDay :: Int -> Int -> Int
symMonthToDay dayOfYear month = dayOfYear - daysBefore where
    daysBefore = 28 * month + 7 * month / 3 - 28

{-|
    symNewYearDay returns the fixed day number of the New Year Day.
-}
symNewYearDay :: Year -> Int
symNewYearDay year = 1 + 364 * p + 7 * (52 * p + 146) / 293 where
    p = case year of Year x -> x - 1


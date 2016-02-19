## Module Data.Date.Symmetry454

#### `checkForLeapWeek`

``` purescript
checkForLeapWeek :: Int -> Int -> Year
```


checkForLeapWeek gets called if fixedToSymYear holds no simple solution.
In this case, the provided fixed day number might be in a leap week.

#### `deductLeapDays`

``` purescript
deductLeapDays :: Year -> Int -> Int
```


deductLeapDays deducts either one or two days from the ordinal day number if
the current Gregorian year is a leap year.

#### `estimateSymYear`

``` purescript
estimateSymYear :: Int -> Year
```


estimateSymYear estimates the Symmetry454 calendar year given a fixed date
number.

#### `fixedToSym`

``` purescript
fixedToSym :: Int -> String
```


fixedToSym converts any fixed day number to the corresponding Symmetry454
calendar date.

#### `fixedToSymYear`

``` purescript
fixedToSymYear :: Int -> Int -> Year
```


fixedToSymYear returns the current year in the Symmetry454 calendar that
contains a given fixed day number. It takes a fixed day number and a number
pointing to the start of a year

#### `gregorianOrdinalDay`

``` purescript
gregorianOrdinalDay :: Year -> Month -> DayOfMonth -> Int
```


gregorianOrdinalDay calculates the ordinal day number within the Gregorian
year.

#### `gregorianToFixed`

``` purescript
gregorianToFixed :: forall eff. Date -> Eff (locale :: Locale | eff) Int
```


gregorianToFixed converts a Gregorian date to a fixed number of dates

#### `isGregorianLeap`

``` purescript
isGregorianLeap :: Year -> Boolean
```


isGregorianLeap checks if the provided year is a leap year in the Gregorian
calendar.

#### `isSymLeap`

``` purescript
isSymLeap :: Year -> Boolean
```


isSymLeap checks if the provided year is a leap year in the Symmetry454
calendar.

#### `priorElapsedDays`

``` purescript
priorElapsedDays :: Year -> Int
```


priorElapsedDays calculates the number of days that have elapsed from the
Gregorian epoch until the beginning of the New Year Day of the specified
Gregorian year number.

#### `symDayToMonth`

``` purescript
symDayToMonth :: Int -> Int
```


symDayToMonth returns the current month of the Symmetry454 calendar given
the ordinal number of days in a year.

#### `symMonthToDay`

``` purescript
symMonthToDay :: Int -> Int -> Int
```


symMonthToDay returns the current day of a Symmetry454 month. It takes the
ordinal number of days of the current year and the current month.

#### `symNewYearDay`

``` purescript
symNewYearDay :: Year -> Int
```


symNewYearDay returns the fixed day number of the New Year Day.



## Module Data.Date.Symmetry454

#### `Year`

``` purescript
newtype Year
  = Year Int
```


A Symmetry454 year

##### Instances
``` purescript
Eq Year
Ord Year
Ring Year
Semiring Year
Show Year
```

#### `checkForLeapWeek`

``` purescript
checkForLeapWeek :: Date -> Date -> Year
```


checkForLeapWeek gets called if toYear holds no simple solution.
In this case, the provided fixed day number might be in a leap week.

#### `estimateYear`

``` purescript
estimateYear :: Date -> Year
```


estimateYear estimates the Symmetry454 calendar year given a fixed date
number.

#### `toString`

``` purescript
toString :: Date -> String
```


toString converts any fixed day number to the corresponding Symmetry454
calendar date.

#### `toYear`

``` purescript
toYear :: Date -> Date -> Year
```


toYear returns the current year in the Symmetry454 calendar that
contains a given fixed day number. It takes a fixed day number and a number
pointing to the start of a year

#### `isLeap`

``` purescript
isLeap :: Year -> Boolean
```


isLeap checks if the provided year is a leap year.

#### `daysToMonth`

``` purescript
daysToMonth :: Int -> Int
```


daysToMonth returns the current month of the Symmetry454 calendar given
the ordinal number of days in a year.

#### `dayOfMonth`

``` purescript
dayOfMonth :: Int -> Int -> Int
```


dayOfMonth returns the current day of a Symmetry454 month. It takes the
ordinal number of days of the current year and the current month.

#### `toNewYearDay`

``` purescript
toNewYearDay :: Year -> Date
```


toNewYearDay returns the Date of the New Year Day.



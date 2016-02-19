## Module Data.Date.Gregorian

#### `deductLeapDays`

``` purescript
deductLeapDays :: Year -> Int -> Int
```


deductLeapDays adjusts an ordinal day number for the shorter month of
February. It accounts for leap years.

#### `ordinalDays`

``` purescript
ordinalDays :: Year -> Month -> DayOfMonth -> Int
```


ordinalDays calculates the ordinal day number of a date from the beginning
of the year.

#### `priorElapsedDays`

``` purescript
priorElapsedDays :: Year -> Int
```


priorElapsedDays calculates the number of days that have elapsed from the
Gregorian epoch until the beginning of the New Year Day of the specified
year.

#### `toFixed`

``` purescript
toFixed :: forall eff. Date -> Eff (locale :: Locale | eff) Date
```


toFixed converts a Gregorian date to a fixed number of dates

#### `isLeap`

``` purescript
isLeap :: Year -> Boolean
```


isLeap checks if the provided year is a leap year.



## Module Data.Date.Symmetry454

#### `checkForLeapWeek`

``` purescript
checkForLeapWeek :: Int -> Int -> Year
```

#### `deductLeapDays`

``` purescript
deductLeapDays :: Year -> Int -> Int
```

#### `estimateSymYear`

``` purescript
estimateSymYear :: Int -> Year
```

#### `fixedToSym`

``` purescript
fixedToSym :: Int -> String
```

#### `fixedToSymYear`

``` purescript
fixedToSymYear :: Int -> Int -> Year
```

#### `gregorianOrdinalDay`

``` purescript
gregorianOrdinalDay :: Year -> Month -> DayOfMonth -> Int
```

#### `gregorianToFixed`

``` purescript
gregorianToFixed :: forall eff. Date -> Eff (locale :: Locale | eff) Int
```

#### `isGregorianLeap`

``` purescript
isGregorianLeap :: Year -> Boolean
```

#### `isSymLeap`

``` purescript
isSymLeap :: Year -> Boolean
```

#### `priorElapsedDays`

``` purescript
priorElapsedDays :: Year -> Int
```

#### `symDayToMonth`

``` purescript
symDayToMonth :: Int -> Int
```

#### `symMonthToDay`

``` purescript
symMonthToDay :: Int -> Int -> Int
```

#### `symNewYearDay`

``` purescript
symNewYearDay :: Year -> Int
```



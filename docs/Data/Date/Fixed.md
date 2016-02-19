## Module Data.Date.Fixed

#### `Date`

``` purescript
newtype Date
  = Date Int
```


Date is a calendar neutral representation of a date. It consist of the number
of days since the start of the Gregorian Epoch (01/01/0001).

##### Instances
``` purescript
Eq Date
Ord Date
Ring Date
Semiring Date
```



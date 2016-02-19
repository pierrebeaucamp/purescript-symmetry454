module Main where

import Control.Monad.Eff (Eff())
import Data.Date (Now(), now)
import Data.Date.Locale (Locale(), toLocaleDateString) as L
import Data.Date.Symmetry454
import Data.DOM.Simple.Unsafe.Element (
    HTMLElement(),
    unsafeQuerySelector,
    unsafeSetTextContent
)
import Data.DOM.Simple.Unsafe.Window (unsafeDocument)
import Data.DOM.Simple.Window (globalWindow)
import DOM (DOM())
import Prelude

{-|
  | main is the entry point of this program. Its sole purpose is to display the
  | dates in their respective DOM elements.
-}
main :: forall eff. Eff (dom :: DOM, locale :: L.Locale, now :: Now | eff) Unit
main = do
    gregorian <- now >>= L.toLocaleDateString
    fixed     <- now >>= gregorianToFixed
    querySelector "#gregorian"   >>= unsafeSetTextContent gregorian
    querySelector "#symmetry454" >>= unsafeSetTextContent (fixedToSym fixed)

{-|
  | querySelector is a shorthand function to select an element from the global
  | document using a query.
-}
querySelector :: forall eff. String -> Eff (dom :: DOM | eff) HTMLElement
querySelector query = unsafeDocument globalWindow >>= unsafeQuerySelector query


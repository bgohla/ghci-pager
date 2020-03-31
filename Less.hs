module Less where

import           Control.Monad
import           System.Directory
import           System.Environment
import           System.IO.Temp
import           System.Process

tempTemplate :: String
tempTemplate = "ghciPrint.txt"

data Window a = Window a a deriving Show

wrapLine :: Int -> String -> [String]
wrapLine _ [] = []
wrapLine l s
  | length s < l = [s]
  | otherwise = [take l s] <> (wrapLine l $ drop l s)

wrapLines :: Int -> String -> String
wrapLines l = unlines . fmap (unlines . wrapLine l) . lines

defaultWindow :: Window Int
defaultWindow = Window 40 80

less :: (Show a) => a -> IO ()
less a = do
  Window _ w <- pure defaultWindow
  lessPath <- getEnv "PAGER"
  p <- writeSystemTempFile tempTemplate $ wrapLines ((-) w 1) $ show a
  (_, _, _, h) <- createProcess $ proc lessPath [p]
  void $ waitForProcess h
  removeFile p

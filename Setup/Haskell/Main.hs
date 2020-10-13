module Main where

main :: IO()
main = do 
    content <- readFile "input.txt"
    putStrLn content
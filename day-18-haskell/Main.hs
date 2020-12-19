module Main where

import Data.Char ( isDigit )

data Token = LParen
           | RParen
           | TokPlus
           | TokMul
           | Number Int
    deriving (Show, Eq)

tokenize :: String -> [Token]
tokenize = reverse . tokenize' []
    where tokenize' :: [Token] -> String -> [Token]
          tokenize' acc [] = acc
          tokenize' acc s@(c:cs) = case c of 
              '(' -> tokenize' (LParen:acc) cs
              ')' -> tokenize' (RParen:acc) cs
              ' ' -> tokenize' acc cs
              '+' -> tokenize' (TokPlus:acc) cs
              '*' -> tokenize' (TokMul:acc) cs
              _   -> let (n, rest) = span isDigit s in
                     tokenize' (Number (read n):acc) rest

data Op = OpPlus
        | OpMul
    deriving (Show)

data Node = BinOp Node Op Node
          | IntNode Int
    deriving (Show)

tree :: [Token] -> Node
tree [Number n]  = IntNode n
tree ts = splitExpr 0 [] (reverse ts)
    where splitExpr :: Int -> [Token] -> [Token] -> Node
          splitExpr 0 (LParen:ts) []       = tree $ init ts   -- expressions of the form (...)
          splitExpr 0 [] [Number n]        = IntNode n
          splitExpr 0 left (TokPlus:right) = BinOp (tree left) OpPlus (tree $ reverse right)
          splitExpr 0 left (TokMul:right)  = BinOp (tree left) OpMul  (tree $ reverse right)
          splitExpr n left (RParen:right)  = splitExpr (n + 1) (RParen:left) right 
          splitExpr n left (LParen:right)  = splitExpr (n - 1) (LParen:left) right 
          splitExpr n left (t:right)       = splitExpr n       (t:left)      right 

-- different precedence
tree2 :: [Token] -> Node
tree2 [Number n]  = IntNode n
tree2 ts = splitExpr False 0 [] ts
    where splitExpr :: Bool -> Int -> [Token] -> [Token] -> Node
          splitExpr True      0 (RParen:left) []             = tree2 $ reverse (init left)   -- expressions of the form (...)
          splitExpr _         0 []            [Number n]     = IntNode n
          splitExpr False     0 left          []             = splitExpr True 0 [] (reverse left)
          splitExpr True      0 left          (TokPlus:right)= BinOp (tree2 $ reverse left) OpPlus (tree2 right)
          splitExpr _         0 left          (TokMul:right) = BinOp (tree2 $ reverse left) OpMul  (tree2 right)
          splitExpr splitplus n left          (RParen:right) = splitExpr splitplus (n - 1) (RParen:left) right 
          splitExpr splitplus n left          (LParen:right) = splitExpr splitplus (n + 1) (LParen:left) right 
          splitExpr splitplus n left          (t:right)      = splitExpr splitplus n       (t:left)      right 
          splitExpr splitplus n left           []            = error $ "Bracket mismatch: " ++ show splitplus ++ show n ++ show (reverse left)

eval :: Node -> Int 
eval (IntNode n)        = n
eval (BinOp l OpPlus r) = eval l + eval r
eval (BinOp l OpMul  r) = eval l * eval r

part1 :: String -> Int
part1 s = sum . map (eval . tree . tokenize) $ lines s

part2 :: String -> Int
part2 s = sum . map (eval . tree2 . tokenize) $ lines s

main :: IO()
main = do 
    content <- readFile "input.txt"
    -- print $ map tokenize $ lines content
    -- print $ map (tree2 . tokenize) $ lines content
    print $ part1 content
    print $ part2 content
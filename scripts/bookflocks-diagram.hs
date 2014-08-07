{-# LANGUAGE NoMonomorphismRestriction #-}
import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine
import Data.List
import Data.Colour.SRGB (sRGB24read)

type Dia = Diagram B R2

-- makeBox :: String -> String -> Dia
makeBox title name c = (text title # scale 0.2 # font "Georgia" <> rect 1 0.5 # fc c ) 
                   # named name

markdownBox = makeBox "Markdown"   "markdown" white
bibtexBox   = makeBox "BibTeX"     "bibtex" white
dancer      = makeBox "Dancer app" "dancer" white
wallflower  = makeBox "Wallflower" "wallflower" white
staticfiles = makeBox "Static\nfiles" "staticfiles" white

input :: Dia
input = markdownBox === strutY 0.2 === bibtexBox

output = staticfiles

arrowOpts = with & headGap  .~ 0.07
                 & tailGap  .~ 0.07
                 & headSize .~ 0.1

finalDiagram :: Dia
finalDiagram = (input 
           ||| strutX 0.5 
           ||| dancer 
           ||| strutX 0.5 
           ||| wallflower 
           ||| strutX 0.5 
           ||| output) 
             # connectOutside' arrowOpts "markdown" "dancer"
             # connectOutside' arrowOpts "bibtex" "dancer"
             # connectOutside' arrowOpts "wallflower" "dancer"
             # connectOutside' arrowOpts "wallflower" "staticfiles"

main = mainWith finalDiagram

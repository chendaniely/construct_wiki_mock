library(shiny)

library(data.tree)
library(networkD3)
library(DT)

pokemon <- read.csv('data/pokemon.csv', sep = '\t')

tree <- FromDataFrameNetwork(pokemon[, 1:2])
lol <- ToListExplicit(tree, unname = TRUE)

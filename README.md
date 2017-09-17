MultipleStarts for R
====

Over view

## Description
Many multivariate analysis requires multiple stats which the algorithm starts from multiple different initial values. This is a function for multiple starts and an arbitrary function is repeated for finding global optima.

## Demo
```R:example.R
kmmult <- function(dat,k){ #modified k-means
    reslist <- kmeans(dat,k)
    lossmin <- reslist$betweenss/reslist[[ite]]$totss
  list(reslist,LOSS_MIN=lossmin)
}

MULTIPLE_STARTS("kmmult(dat,k)",100)
```

## Version
1.0.0.

## Requirement
snowfall package (only for MultipleStart.R)

## Usage
- "function_args" is repeated "starts" times
- The repeated function must contain LOSSS_MIN (min.of loss function). Also, must store some results as a list.
- The best solution which yields minimum function value and frequency of local minimum returned.
- Snowfall package supported.

## Lisence
[MIT] (https://github.com/tcnksm/tool/blob/master/LICENCE)

## Author
Naoto Yamashita
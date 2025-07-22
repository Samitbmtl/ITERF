# ITERF
The ITERF package provides methods for estimating treatment effects in two scenarios: (1) survival outcomes with right-censoring and a binary treatment, and (2) continuous outcomes with a continuous treatment. All methods are based on random forests, where trees are constructed using splitting rules that aim to maximize the heterogeneity of the estimated treatment effect. 

# Authors
This package is written and maintained by *Denis Larocque (<denis.larocque@hec.ca>)* , *Sami Tabib (<sami.tabib@hec.ca>)*

# Installation
To install this package, follow these steps:
```
install.packages("devtools")
devtools::install_github("Samitbmtl/ITERF")
```

# Example:
Below is an example illustrating the utilization of the HET function with data from causaldrf package (1987 National Medical Expenditure Survey. Impact of smoking on medical expenditure).

```
# Loading libraries and preparing the data.
library(ITERF)
library(causaldrf)
# example dataset
data(nmes_data, package = "causaldrf")

# dataset cleaning
dat <- nmes_data
dat <- dat[dat$TOTALEXP != 0,]
dat$uid <- seq.int(nrow(dat))
dat$beltuse <- as.numeric(unclass(dat$beltuse))
dat$POVSTALB <- as.numeric(unclass(dat$POVSTALB))
dat$Y = log(dat$TOTALEXP+1)
dat$G = dat$packyears
dat$G = dat$G - min(dat$packyears)
dat$G = dat$G / max(dat$G)

# training data
datrain=dat[1:(nrow(dat)-100),]

# new data
datest=dat[(nrow(dat)-100+1):nrow(dat),]

# build forest
obj <- HET(f(Y, G) ~ AGESMOKE+LASTAGE+MALE+RACE3+beltuse+educate+marital+POVSTALB, data = datrain ,ntree = 100,samptype ="swr")

# prediction for the training data
pred <- predict(obj, data=datrain,OOB = TRUE, obsUniqueInTree = TRUE)
pred$predicted

# prediction with new data
pred <- predict(obj, newdata=datest,OOB = FALSE, obsUniqueInTree = TRUE)
pred$predicted

```
# References
Tabib, S. and Larocque, D. (2020). Non-Parametric Individual Treatment Effect Estimation for Survival Data with Random Forests. Bioinformatics 36, 629–636.
https://academic.oup.com/bioinformatics/article/36/2/629/5542949

Tabib, S. and Larocque, D. (2024). Comparison of Random Forest Methods for Conditional Average Treatment Effect Estimation with a Continuous Treatment. Statistical Methods in Medical Research. 2024;33(11-12):1952-1966. doi:10.1177/09622802241275401.

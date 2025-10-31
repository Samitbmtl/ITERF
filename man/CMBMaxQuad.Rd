\name{CMBMaxQuad}
\alias{CMBMaxQuad}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
CMBMaxQuad Help
}
\description{
Random forest to estimate the maximum CATE (conditional average treatment effect) with a continuous treatment and a continuous response. It is based on a CART type MOdel Based recursive partitioning (MOB) algorithm.
}
\usage{
CMBMaxQuad(formula, 
           data, 
           iterf.nbCore = -1
           ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{formula}{
Formula in the form f(response, treatment) ~ covariates 
}
  \item{data}{
Data frame used for building the trees.
}
  \item{iterf.nbCore}{
When set to -1 (default), ITERF will use all cpu's core available to make the calculations. Otherwise, it will use the number of cores indicated (which should be > 0 and <= number of CPU's cores). A value 1 means no parallelism.
}
  \item{...}{
Other arguments used in the rfsrc function from the randomForestSRC package version 2.9.2 
}
}
\details{

Refer to the conclusion of the article below for more details. \cr
This method assumes the following local quadratic model E[Y | X=x,G=g] = b0(x) + b1(x) g + b2(x) g^2, where Y is a continuous response and G a continuous treatment. Treatment values are assumed to lie in the interval [0,1]. The maximum CATE, denoted by tau(x) is the maximum of the function b0(x) + b1(x) g + b2(x) g^2, when g is in [0,1]. \cr
Trees are built using the RandomForestSRC package and leveraging its custom split rule feature. \cr
Predictions from a fitted forest return estimated values for tau(x), called tau, and the values of g where the maximum are attained, called gmax (which are necessarily in [0,1]).   \cr
When making prediction two arguments can be used : \cr

OOB = TRUE or FALSE\cr
This argument defines how the Bag of Observations for Prediction (BOP) will be constructed. The BOP is the set of locally similar observations from the training data that we use to estimate tau(x). \cr
If OOB = TRUE, only the tree's out of bag observations are used to construct the BOP. \cr
If OOB = FALSE, the In-Bag observations are used to construct the BOP.\cr

obsUniqueInTree = TRUE or FALSE\cr
This argument is used to define how the function manages multiple copies of observations in a terminal node (which is possible is we use bootstrap samples to build the trees). \cr
If obsUniqueInTree = TRUE, the function will only keep one copy of a training observation in each tree to construct the BOP.\cr
If obsUniqueInTree = FALSE, the function will keep all copies of a training observation in each tree to construct the BOP.\cr

}
\value{
Returns a fitted random forest object. 
}
\references{
Tabib, S. and Larocque, D. (2024). Comparison of Random Forest Methods for Conditional Average Treatment Effect Estimation with a Continuous Treatment. Statistical Methods in Medical Research. 2024;33(11-12):1952-1966. doi:10.1177/09622802241275401.
}
\author{
Sami Tabib
}
\note{

}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{

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
obj <- CMBMaxQuad(f(Y, G) ~ AGESMOKE+LASTAGE+MALE+RACE3+beltuse+educate+marital+POVSTALB, data = datrain ,ntree = 100,samptype ="swr")

# prediction for the training data
pred <- predict(obj, data=datrain,OOB = TRUE, obsUniqueInTree = TRUE)
pred$predicted

# prediction with new data
pred <- predict(obj, newdata=datest,OOB = FALSE, obsUniqueInTree = TRUE)
pred$predicted


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.

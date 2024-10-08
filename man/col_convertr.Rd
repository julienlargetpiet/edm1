% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{col_convertr}
\alias{col_convertr}
\title{col_convertr}
\usage{
col_convertr(inpt_datf)
}
\arguments{
\item{inpt_datf}{is the input dataframe}
}
\description{
Allow to convert all column that may be converted to a numeric, to a numeric, see examples
}
\examples{

datf <- mtcars
datf[, 3] <- as.character(datf[, 3])
datf[, 4] <- as.character(datf[, 4])
str(datf)

'data.frame':	32 obs. of  11 variables:
 $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
 $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
 $ disp: chr  "160" "160" "108" "258" ...
 $ hp  : chr  "110" "110" "93" "110" ...
 $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
 $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
 $ qsec: num  16.5 17 18.6 19.4 17 ...
 $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
 $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
 $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
 $ carb: num  4 4 1 1 2 1 4 2 2 4 ...

datf <- col_convertr(inpt_datf = datf)

all(datf == mtcars)

[1] TRUE

}

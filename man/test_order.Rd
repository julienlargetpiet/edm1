% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{test_order}
\alias{test_order}
\title{test_order}
\usage{
test_order(inpt_v_from, inpt_v_test)
}
\arguments{
\item{is}{the vector we want to test if its commun element with inpt_v_from are in the same order}
}
\description{
Allow to get if two vectors have their commun elements in the same order, see examples
}
\examples{

print(test_order(inpt_v_from = c(1:8), inpt_v_test = c(1, 4)))

[1] TRUE

print(test_order(inpt_v_from = c(1:8), inpt_v_test = c(1, 4, 2)))

[1] FALSE

}

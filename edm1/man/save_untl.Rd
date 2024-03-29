% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{save_untl}
\alias{save_untl}
\title{save_untl}
\usage{
save_untl(inpt_l = list(), val_to_stop_v = c())
}
\arguments{
\item{inpt_l}{is the input list containing all the vectors}

\item{val_to_stop_v}{is a vector containing the values that marks the end of the vectors returned in the returned list, see the examples}
}
\description{
Get the elements in each vector from a list that are located before certain values
}
\examples{

print(save_untl(inpt_l=list(c(1:4), c(1, 1, 3, 4), c(1, 2, 4, 3)), val_to_stop_v=c(3, 4)))

#[[1]]
#[1] 1 2
#
#[[2]]
#[1] 1 1
#
#[[3]]
#[1] 1 2

print(save_untl(inpt_l=list(c(1:4), c(1, 1, 3, 4), c(1, 2, 4, 3)), val_to_stop_v=c(3)))

#[[1]]
#[1] 1 2
#
#[[2]]
#[1] 1 1
#
#[[3]]
#[1] 1 2 4

}

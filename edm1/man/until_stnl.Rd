% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{until_stnl}
\alias{until_stnl}
\title{until_stnl}
\usage{
until_stnl(vec1, goal)
}
\arguments{
\item{vec1}{is the input vector}

\item{goal}{is the length to reach}
}
\description{
Maxes a vector to a chosen length. ex: if i want my vector c(1, 2) to be 5 of length this function will return me: c(1, 2, 1, 2, 1)
}
\examples{

print(until_stnl(vec1=c(1, 3, 2), goal=56))

# [1] 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3
#[39] 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3

}

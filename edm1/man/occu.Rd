% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{occu}
\alias{occu}
\title{occu}
\usage{
occu(inpt_v)
}
\arguments{
\item{inpt_v}{the input dataframe}
}
\description{
Allow to see the occurence of each variable in a vector. Returns a datafame with, as the first column, the all the unique variable of the vector and , in he second column, their occurence respectively.
}
\examples{

print(occu(inpt_v=c("oui", "peut", "peut", "non", "oui")))

#   var occurence
#1  oui         2
#2 peut         2
#3  non         1

}

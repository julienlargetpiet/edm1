% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{extrt_only_v}
\alias{extrt_only_v}
\title{extrt_only_v}
\usage{
extrt_only_v(inpt_v, pttrn_v)
}
\arguments{
\item{inpt_v}{is the input vector}

\item{pttrn_v}{is the vector contining all the elements that can be in inpt_v}
}
\description{
Returns the elements from a vector "inpt_v" that are in another vector "pttrn_v"
}
\examples{

print(extrt_only_v(inpt_v=c("oui", "non", "peut", "oo", "ll", "oui", "non", "oui", "oui"), 
     pttrn_v=c("oui")))

#[1] "oui" "oui" "oui" "oui"

}

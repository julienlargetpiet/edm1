% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{isnt_divisible}
\alias{isnt_divisible}
\title{isnt_divisible}
\usage{
isnt_divisible(inpt_v = c(), divisible_v = c())
}
\arguments{
\item{inpt_v}{is the input vector}

\item{divisible_v}{is the vector containing all the numbers that will try to divide those contained in inpt_v}
}
\description{
Takes a vector as an input and returns all the elements that are not divisible by all choosen numbers from another vector.
}
\examples{

 print(isnt_divisible(inpt_v=c(1:111), divisible_v=c(2, 4, 5)))

# [1]   1   3   7   9  11  13  17  19  21  23  27  29  31  33  37  39  41  43  47
#[20]  49  51  53  57  59  61  63  67  69  71  73  77  79  81  83  87  89  91  93
#[39]  97  99 101 103 107 109 111

}

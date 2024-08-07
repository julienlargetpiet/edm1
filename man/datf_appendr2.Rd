% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{datf_appendr2}
\alias{datf_appendr2}
\title{datf_appendr2}
\usage{
datf_appendr2(inpt_datf, chs_type = "integer")
}
\arguments{
\item{inpt_datf}{is the inout dataframe}
}
\description{
Allow to append all columns of a dataframe in a vector,
specifying the column types ("integer" or "character"), see examples
}
\examples{

datf_teste <- data.frame("col1" = c(1:5), "col2" = c(5:1), 
  "col3" = c("oui", "oui", "oui", "non", "non"))

print(datf_appendr2(inpt_datf = datf_teste, chs_type = "integer"))

[1] 1 2 3 4 5 5 4 3 2 1

print(datf_appendr2(inpt_datf = datf_teste, chs_type = "character"))

[1] "oui" "oui" "oui" "non" "non"

}

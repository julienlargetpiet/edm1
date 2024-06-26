% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{insert_datf}
\alias{insert_datf}
\title{insert_datf}
\usage{
insert_datf(datf_in, datf_ins, ins_loc)
}
\arguments{
\item{datf_in}{is the dataframe that will be inserted}

\item{datf_ins}{is the dataset to be inserted}

\item{ins_loc}{is a vector containg two parameters (row, column) of the begining for the insertion}
}
\description{
Allow to insert dataframe into another dataframe according to coordinates (row, column) from the dataframe that will be inserted
}
\examples{

datf1 <- data.frame(c(1, 4), c(5, 3))

datf2 <- data.frame(c(1, 3, 5, 6), c(1:4), c(5, 4, 5, "ereer"))

print(insert_datf(datf_in=datf2, datf_ins=datf1, ins_loc=c(4, 2)))

#   c.1..3..5..6. c.1.4. c.5..4..5...ereer..
# 1             1      1                   5
# 2             3      2                   4
# 3             5      3                   5
# 4             6      1                   5

print(insert_datf(datf_in=datf2, datf_ins=datf1, ins_loc=c(3, 2)))

#   c.1..3..5..6. c.1.4. c.5..4..5...ereer..
# 1             1      1                   5
# 2             3      2                   4
# 3             5      1                   5
# 4             6      4                   3

print(insert_datf(datf_in=datf2, datf_ins=datf1, ins_loc=c(2, 2)))

#   c.1..3..5..6. c.1.4. c.5..4..5...ereer..
# 1             1      1                   5
# 2             3      1                   5
# 3             5      4                   3
# 4             6      4               ereer

}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{historic_sequence1}
\alias{historic_sequence1}
\title{historic_sequence1}
\usage{
historic_sequence1(inpt_datf, bf_ = 1)
}
\arguments{
\item{inpt_datf}{is the input dataframe}

\item{bf_}{is the number of previous value of the individual it will search for, see examples}
}
\description{
Allow to perform a pivot wider on a sequencial dataset (here the type is dataframe), each variable will be dupplicated in a column to show the value to this variable at n - 1 for each individual, see examples.
}
\examples{

set.seed(123)
var1 <- round(runif(n = 14, min = 100, max = 122))
set.seed(123)
var2 <- round(runif(n = 14, min = 14, max = 20))

datf <- data.frame("ids" = c(20, 20, 20, 20, 19, 19, 19, 18, 18, 18, 18,
                            17, 17, 17),
                  "individual" = c("oui", "non", "peut1", "peut2",
                                   "oui", "peut1", "peut2"),
                  "var1" = var1,
                  "var2" = var2)
print(datf)

   ids individual var1 var2
1   20        oui  106   16
2   20        non  117   19
3   20      peut1  109   16
4   20      peut2  119   19
5   19        oui  121   20
6   19      peut1  101   14
7   19      peut2  112   17
8   18        oui  120   19
9   18        non  112   17
10  18      peut1  110   17
11  18      peut2  121   20
12  17        oui  110   17
13  17      peut1  115   18
14  17      peut2  113   17

historic_sequence1(inpt_datf = datf, bf_ = 2)

  id_seq individual var1-1 var1-2 var2-1 var2-2
1     20        oui    121    120     20     19
2     20        non     NA    112     NA     17
3     20      peut1    101    110     14     17
4     20      peut2    112    121     17     20
5     19        oui    120    110     19     17
6     19      peut1    110    115     17     18
7     19      peut2    121    113     20     17

historic_sequence1(inpt_datf = datf, bf_ = 3)

  id_seq individual var1-1 var1-2 var1-3 var2-1 var2-2 var2-3
1     20        oui    121    120    110     20     19     17
2     20        non     NA    112     NA     NA     17     NA
3     20      peut1    101    110    115     14     17     18
4     20      peut2    112    121    113     17     20     17

}

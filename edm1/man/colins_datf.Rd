% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{colins_datf}
\alias{colins_datf}
\title{colins_datf}
\usage{
colins_datf(inpt_datf, target_col = list(), target_pos = list())
}
\arguments{
\item{inpt_datf}{is the dataframe where vectors will be inserted}

\item{target_col}{is a list containing all the vectors to be inserted}

\item{target_pos}{is a list containing the vectors made of the columns names or numbers where the associated vectors from target_col will be inserted after}
}
\description{
Allow to insert vectors into a dataframe.
}
\examples{

datf1 <- data.frame("frst_col"=c(1:5), "scd_col"=c(5:1))

print(colins_datf(inpt_datf=datf1, target_col=list(c("oui", "oui", "oui", "non", "non"), 
             c("u", "z", "z", "z", "u")), 
                target_pos=list(c("frst_col", "scd_col"), c("scd_col"))))

#  frst_col cur_col scd_col cur_col.1 cur_col
#1        1     oui       5       oui       u
#2        2     oui       4       oui       z
#3        3     oui       3       oui       z
#4        4     non       2       non       z
#5        5     non       1       non       u

print(colins_datf(inpt_datf=datf1, target_col=list(c("oui", "oui", "oui", "non", "non"), 
             c("u", "z", "z", "z", "u")), 
                target_pos=list(c(1, 2), c("frst_col"))))

#  frst_col cur_col scd_col cur_col cur_col
#1        1     oui       5       u     oui
#2        2     oui       4       z     oui
#3        3     oui       3       z     oui
#4        4     non       2       z     non
#5        5     non       1       u     non

}

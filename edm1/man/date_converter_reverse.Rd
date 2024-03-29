% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_fun.R
\name{date_converter_reverse}
\alias{date_converter_reverse}
\title{date_converter_reverse}
\usage{
date_converter_reverse(inpt_date, convert_to = "dmy", frmt = "y", sep_ = "-")
}
\arguments{
\item{inpt_date}{is the input date}

\item{convert_to}{is the date format the input date will be converted}

\item{frmt}{is the time unit of the input date}

\item{sep_}{is the separator of the outputed date}
}
\description{
Allow to convert single date value like 2025.36 year to a date like second/minutehour/day/month/year (snhdmy)
}
\examples{

print(date_converter_reverse(inpt_date="2024.929", convert_to="hmy", frmt="y", sep_="-"))

#[1] "110-11-2024"

print(date_converter_reverse(inpt_date="2024.929", convert_to="dmy", frmt="y", sep_="-"))

#[1] "4-11-2024"

print(date_converter_reverse(inpt_date="2024.929", convert_to="hdmy", frmt="y", sep_="-"))

#[1] "14-4-11-2024"

print(date_converter_reverse(inpt_date="2024.929", convert_to="dhym", frmt="y", sep_="-"))

#[1] "4-14-2024-11"

}

% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/SpRarefy.R
\docType{class}
\name{SpRarefy-class}
\alias{SpRarefy}
\alias{SpRarefy-class}
\title{SpRarefy: An S4 class to represent spatially rarefied datasets}
\description{
This class is used to store replicates of spatially rarefied datasets.
}
\section{Slots}{

\describe{
\item{\code{data}}{\code{SpatialPoints} or \code{SpatialPointsDataFrame} object with all records.}

\item{\code{samples}}{\code{list} with indices for records in each replicate.}

\item{\code{cellsize}}{\code{numeric} height and width of cells (m) used to sample records.}

\item{\code{call}}{\code{call} used to generate object.}

\item{\code{grid}}{\code{RasterLayer} used to rarefy data.}
}}
\seealso{
\code{\link{call}}, \code{\link{data}}, \code{\link{cellsize}}, \code{\link{nrep}}, \code{\link{plot}},\code{\link{summary}}, \code{\link{write}}.
}


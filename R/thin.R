#' @include dependencies.R generics.R RcppExports.R SpThin.R
NULL

#' @rdname spThin
#' @inheritParams spThin
#' @export
spThin.numeric<-function(x, y, dist, method='heuristic', nrep=1, great.circle.distance=FALSE, ...) {
	# check validity of inputs
	if (!is.numeric(x))
		stop('x is not a numeric vector')
	if (!is.numeric(y))
		stop('y is not a numeric vector')
	if (!identical(length(x),length(y)))
		stop('length(x) is not length(y)')
	# generate samples 
	x<-spThin(
		x=SpatialPoints(
			coords=matrix(c(x,y), ncol=2),
			proj4string=list(
				CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'),
				CRS()
			)[[great.circle.distance+1]]
		),
		dist,
		method,
		nrep,
		great.circle.distance,
		...
	)
	x@call<-match.call()
	return(x)
}


#' @rdname spThin
#' @inheritParams spThin
#' @export
spThin.data.frame<-function(x, x.col, y.col, dist, method='heuristic', nrep=1, great.circle.distance=FALSE, ...) {
	# check validity of inputs
	if (!x.col %in% names(x))
		stop('x.col not column in x')
	if (!y.col %in% names(x))
		stop('y.col not column in x')
	if (!great.circle.distance & all(x[[x.col]]<=180) & all(x[[x.col]]>=-180) & all(x[[y.col]]>=-90)& all(x[[y.col]]<=90))
		warning("data may be in lon/lat coordinate system.\nIf so, please use great.circle.distance=TRUE.")
	# generate samples
	x<-spThin(
		SpatialPointsDataFrame(
			coords=matrix(c(x[[x.col]],x[[y.col]]),ncol=2),
			data=x,
			proj4string=list(
				CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'),
				CRS()
			)[[great.circle.distance+1]]
		),
		dist,
		method,
		nrep,
		great.circle.distance,
		...
	)
	x@call<-match.call()
	return(x)
}

#' @rdname spThin
#' @inheritParams spThin
#' @export
spThin.SpatialPoints<-function(x, dist, method='heuristic', nrep=1, great.circle.distance=x@proj4string@projargs=='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs', ...) {
	if (!is.numeric(dist))
		stop('dist is not numeric')
	if (!is.numeric(nrep))
		stop('nrep is not numeric')
	match.arg(method, c('lpsolve', 'heuristic', 'gurobi'))		
	if (!is.logical(great.circle.distance))
		stop('great.circle.distance is not logical')
	# generate samples
	if (method=='lpsolve') {
		solution<-thin_lpsolve(
			x@coords[,1],
			x@coords[,2],
			dist,
			nrep,
			great.circle.distance,
			...
		)
	} else if (method=='gurobi') {
		solution<-thin_gurobi(
			x@coords[,1],
			x@coords[,2],
			dist,
			great.circle.distance,
			...
		)
	} else {
		solution<-rcpp_thin_algorithm(
			x@coords[,1],
			x@coords[,2],
			dist,
			nrep,
			great.circle.distance
		)
	}
		
	# return result
	return(
		SpThin(
			data=x,
			samples=solution,
			mindist=rcpp_get_mindists(x@coords[,1], x@coords[,2], great.circle.distance, solution),
			distname=ifelse(great.circle.distance, 'great circle distance', 'Euclidean distance'),
			thindist=dist,
			method=method,
			call=match.call()
		)
	)
}


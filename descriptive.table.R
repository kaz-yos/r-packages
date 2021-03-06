descriptive.table<-function(vars,strata,data,func.names = c("Mean","St. Deviation","Median",
								"25th Percentile","75th Percentile",
								"Minimum","Maximum","Skew","Kurtosis","Valid N"),func.additional){
	dat<-eval(substitute(vars),data, parent.frame())
	if(length(dim(dat))<1.5)
		dat<-d(dat)
	if(any(!sapply(dat,is.numeric))){
		dat<-dat[sapply(dat,is.numeric)]
		warning("Non-numeric variables dropped from descriptive table")
	}
	if(missing(strata)){
		strata<-rep("all cases",dim(dat)[1])
	}else{
		strata<-eval(substitute(strata),data, parent.frame())
		if(length(dim(strata))<1.5)
			strata<-d(strata)
	}

	if(!all(sapply(dat,is.numeric))) stop("Descriptives can only be run on numeric variables")
	func.indexes <- pmatch(func.names, c("Mean","St. Deviation","Median","25th Percentile",
							"75th Percentile","Minimum","Maximum","Skew",
							"Kurtosis","Valid N"))
	functions<-c(	function(x) mean(x,na.rm=TRUE),
					function(x) sd(x,na.rm=TRUE),
					function(x) median(x,na.rm=TRUE),
					function(x) quantile(x,.25,na.rm=TRUE),
					function(x) quantile(x,.75,na.rm=TRUE),
					function(x) min(x,na.rm=TRUE),
					function(x) max(x,na.rm=TRUE),
					function(x) skewness(x,na.rm=TRUE,type=2),
					function(x) kurtosis(x,na.rm=TRUE,type=2),
					function(x) sum(!is.na(x))
				)
	functions<-functions[func.indexes]

	if(!missing(func.additional)){
		if(!is.list(func.additional) || is.null(names(func.additional)))
			stop("func.additional must be a named list of functions")
		functions <- c(functions,unlist(func.additional))
		func.names<-c(func.names,names(func.additional))
	}


        ## This original part creates a functions-strata-variables structure, and transforms it.

	## ##calculate statistics
	## tbl.list<-list()
	## for(ind in 1:length(functions)){
	## 	tbl.list[[func.names[ind]]]<-by(dat, strata,
	## 								function(x) sapply(x, functions[[ind]]) ,simplify=FALSE)
	## }
	## ##format into table
	## result<-list()
	## for(ind in 1:length(tbl.list[[1]])){
    	## 	d <- dim(tbl.list[[1]])
    	## 	dn <- dimnames(tbl.list[[1]])
    	## 	dnn <- names(dn)
	## 	ii <- ind - 1
	## 	name<-""
	## 	for (j in seq_along(dn)) {
	## 		iii <- ii%%d[j] + 1
	## 		ii <- ii%/%d[j]
	## 		name <- paste(name,dnn[j], ": ", dn[[j]][iii], " ", sep = "")
	## 	}
	## 	result[[name]]<-sapply(tbl.list,function(x) x[[ind]])
	## }


        ## Create a strata-functions-variables structure directly.
        
        ## Name functions
        names(functions) <- func.names

        ## Devide by strata
        result <- by(data = dat, INDICES = strata,

                     ## Work on each stratum
                     FUN = function(strataDat) { # strataDat should be a data frame

                         ## Loop for functions
                         sapply(functions,
                                FUN = function(fun) {

                                    ## Loop for variables
                                    sapply(strataDat, fun)
                                })
                     })

        ## by object status can be retained if this part is not used
	##clean out nulls. 
	## result<-result[!sapply(result,function(x)all(sapply(x,function(x)all(is.null(x)))))]
        
	return(result)
}

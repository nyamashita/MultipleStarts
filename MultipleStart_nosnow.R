########################################################
####  General Function of Multiple Starts no snowfall
####             2017/9/17
####
####    Input: name of subfunction
####           
#### 2017/05/02 no snowfall version
#### Usage:
####  - "function_args" is repeated "starts" times
####  - The repeated function must contain LOSSS_MIN
####    (min.of loss function). Also, must store some
####    results as a list.
####  - The best solution which yields minimum function
####    value and frequency of local minimum returned.
####  - Snowfall package is not required.
########################################################

library(pbapply)

MULTIPLE_STARTS <- function(function_args, # function with args to be repeated as "TEXT"
                            starts,  # number of multiple starts
                            thresh = 1e-7)
{

  # define "instant" function
  FUN_INST <- function(start){
    eval(parse(text = function_args))
  }
  
  #multiple run procedure
  start.no <- c(1:starts)
  sol.list <- pblapply(start.no,FUN_INST)
  flist <- c()
  for(start in 1:starts){
    flist[start] <- sol.list[[start]]$LOSS_MIN
  }
  
  #find best solution
  solbest <- sol.list[[which.min(flist)]]
  fbest <- min(flist)
  
  #count local minimum
  lm <- 0
  for(sol in 1:starts){
    if(abs(fbest-flist[sol]) > thresh){lm <- lm+1}
  }
  
  
  #outputs
  return(
    list(solbest=solbest,
         localminimum=lm/starts,
         flist=flist)
  )

  
}



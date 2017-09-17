########################################################
####  General Function of Multiple Starts 
####             2017/9/17
####
####    Input: name of subfunction
####           
#### snowfall for multicore computation
#### Usage:
####  - "function_args" is repeated "starts" times
####  - The repeated function must contain LOSSS_MIN
####    (min.of loss function). Also, must store some
####    results as a list.
####  - The best solution which yields minimum function
####    value and frequency of local minimum returned.
####  - Snowfall package supported.
########################################################

library(snowfall)


MULTIPLE_STARTS <- function(function_args, # function with args to be repeated as "TEXT"
                            starts) # number of multiple starts
{
  sfInit(parallel = TRUE, cpus = 20)
  sfExportAll()
  
  # define "instant" function
  FUN_INST <- function(start){
    eval(parse(text = function_args))
  }
  
  #multiple run procedure
  start.no <- c(1:starts)
  sol.list <- sfLapply(start.no,FUN_INST)
  #sol.list <- lapply(start.no,FUN_INST)
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
    if(abs(fbest-flist[sol]) > 1e-5){lm <- lm+1}
  }
  
  
  #outputs
  return(
    list(solbest=solbest,
         localminimum=lm/starts)
  )
  sfRemoveAll()
  sfStop()
  
  
  
}



########################################################
####  General Function of Multiple Starts no snowfall
####       runs until two equivalent solutions are found
####             2020/2/15
####
####    Input: name of subfunction
####           
########################################################
library(pbapply)

MULTIPLE_STARTS <- function(function_args, # function with args to be repeated as "TEXT"
                            mmin,# minimum number of starts
                            mmax # maximum number of starts
)
{
  
  # define "instant" function
  FUN_INST <- function(start){
    eval(parse(text = function_args))
  }
  
  sol_flag <- 0
  start_time <- proc.time()
  
  #multiple run 1st phase; first mmin starts
  cat("1st phase...")
  cat("\n")
  start.no <- c(1:mmin)
  sol.list <- pblapply(start.no,FUN_INST)
  flist <- c()
  for(start in 1:mmin){
    flist[start] <- sol.list[[start]]$LOSS_MIN
  }
  
  #multiple run 2nd phase; last mmax starts
  i <- 1
  best_id <- which.min(flist)
  best_id_prev <- best_id
  cat("2nd phase...")
  cat("\n")
  while((sol_flag == 0)&(i <= mmax-mmin)){
    soltmp <- FUN_INST(0)
    sol.list[[mmin + i]] <- soltmp
    flist[mmin + i] <- soltmp$LOSS_MIN
    if(flist[best_id] > soltmp$LOSS_MIN){ #update the best solution
      best_id_prev <- best_id
      best_id <- mmin + i
      cat("updated!", flist[best_id])
      cat("\n")
    }
    if(abs(flist[best_id_prev] - soltmp$LOSS_MIN) < 1e-7){ #if two equivalently best solutions are found
      sol_flag <- 1
    }
    if(mmax >= 10){
      if(i%%round(mmax/10) == 0){
        cat(i, "out of", mmax-mmin, "iteration completed.")
        cat("\n")
      }
    }
    i <- i + 1
  }
  
  #find best solution
  solbest <- sol.list[[best_id]]
  fbest <- flist[best_id]
  
  #count local minimum
  lm <- 0
  for(sol in 1:length(flist)){
    if(abs(fbest-flist[sol]) > 1e-7){lm <- lm+1}
  }
  
  elapsed <- proc.time() - start_time
  
  #outputs
  return(
    list(solbest=solbest,
         localminimum=lm/length(flist),
         sol_flag = sol_flag,
         round = mmin + i,
         time = elapsed[3])
  )
  
}



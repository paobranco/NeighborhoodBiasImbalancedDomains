##########################################################################
# Workflows
# define several workflows for applying the different resampling strategies for classification tasks
##########################################################################
WFnone <- function(form, train, test, learner, learner.pars){
  ptm <- proc.time()
  preds <- do.call(paste('cv', learner, sep='.'),
                   list(form, train, test, learner.pars))
  trainpred.time <- proc.time() - ptm
  res <- list(trues=responseValues(form, test), preds=preds, trainpredtime=trainpred.time)
  return(res)
}


WFRandUnder <- function(form, train, test, learner, C.perc, repl,
                        dist, p, k, learner.pars){
  ptm <- proc.time()
  newtr <- LNRandUnderClassif(form, train, C.perc=C.perc, repl=repl, Fr=NULL, dist=dist, p=p, k=k)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  trainpred.time <- proc.time() - ptm
  res <- list(trues=responseValues(form,test),preds=preds, trainpredtime=trainpred.time)
  return(res)
}


WFRandUnderFT <- function(form, train, test, learner, C.perc, repl,
                          Fr, dist, p, k, learner.pars){
  ptm <- proc.time()
  newtr <- LNRandUnderClassif(form, train, C.perc=C.perc, repl=repl, Fr=Fr, dist=dist, p=p, k=k)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  trainpred.time <- proc.time() - ptm
  res <- list(trues=responseValues(form,test),preds=preds, trainpredtime=trainpred.time)
  return(res)
}

WFRandUnderFF <- function(form, train, test, learner, C.perc, repl,
                          Fr, dist, p, k, learner.pars){
  ptm <- proc.time()
  newtr <- LNRandUnderClassif(form, train, C.perc, repl, Fr, dist, p, k)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  trainpred.time <- proc.time() - ptm
  res <- list(trues=responseValues(form,test),preds=preds, trainpredtime=trainpred.time)
  return(res)
}


WFsmote <- function(form, train, test, learner, C.perc, k, repl, dist, p, learner.pars){
  ptm <- proc.time()
  newtr <- SmoteClassif(form, train, C.perc, k, repl, dist, p)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  trainpred.time <- proc.time() - ptm
  res <- list(trues=responseValues(form,test),preds=preds, trainpredtime=trainpred.time)
  return(res)
}

WFRFNFSmote <- function(form, train, test, learner, C.perc, FrN, FrR, k, repl, dist, p, learner.pars){ 
  ptm <- proc.time()
  newtr <- LNSmoteClassif(form, train, C.perc, FrN, FrR, k, repl, dist, p)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  trainpred.time <- proc.time() - ptm
  res <- list(trues=responseValues(form,test),preds=preds, trainpredtime=trainpred.time)
  return(res)
}

WFRFNSmote <- function(form, train, test, learner, C.perc, FrN, FrR, k, repl, dist, p, learner.pars){ 
  ptm <- proc.time()
  newtr <- LNSmoteClassif(form, train, C.perc, FrN, FrR, k, repl, dist, p)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  trainpred.time <- proc.time() - ptm
  res <- list(trues=responseValues(form,test),preds=preds, trainpredtime=trainpred.time)
  return(res)
}


WFRNFSmote <- function(form, train, test, learner, C.perc, FrN, FrR, k, repl, dist, p, learner.pars){ 
  ptm <- proc.time()
  newtr <- LNSmoteClassif(form, train, C.perc, FrN, FrR, k, repl, dist, p)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  trainpred.time <- proc.time() - ptm
  res <- list(trues=responseValues(form,test),preds=preds, trainpredtime=trainpred.time)
  return(res)
}


WFRNSmote <- function(form, train, test, learner, C.perc, FrN, FrR, k, repl, dist, p, learner.pars){ 
  ptm <- proc.time()
  newtr <- LNSmoteClassif(form, train, C.perc, FrN, FrR, k, repl, dist, p)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  trainpred.time <- proc.time() - ptm
  res <- list(trues=responseValues(form,test),preds=preds, trainpredtime=trainpred.time)
  return(res)
}



# define the learn/test functions for the systems
cv.svm <- function(form,train,test, learner.pars) {
  cost <- learner.pars$cost
  gamma <- learner.pars$gamma
  m <- svm(form,train, cost=cost, gamma=gamma)
  predict(m,test)
}
cv.randomForest <- function(form,train,test,learner.pars) {
  mtry <- learner.pars$mtry
  ntree <- learner.pars$ntree
  m <- randomForest(form,train, ntree=ntree, mtry=mtry)
  predict(m,test)
}

cv.rpart <- function(form,train,test,learner.pars) {
  minsplit <- learner.pars$minsplit
  maxdepth <- learner.pars$maxdepth
  m <- rpart(form,train,control=rpart.control(minsplit=minsplit, maxdepth=maxdepth))
  predict(m,test, type="class")
}


cv.nnet <- function(form, train, test, learner.pars) {
 size <- learner.pars$size
 decay <- learner.pars$decay
 m <- nnet(form, train, size=size, decay=decay, trace=FALSE)
 as.factor(predict(m, test, type="class"))
}


# ============================================================
# EVALUATION STATISTICS
# metrics definition for the estimation task
# ============================================================

eval.stats <- function(trues, preds, train, trainpredtime, metrics, posClass){

  prec <- classificationMetrics(trues, preds, metrics="prec", posClass = posClass)
  rec <- classificationMetrics(trues, preds, metrics="rec", posClass = posClass)
  F1 <- classificationMetrics(trues, preds, metrics="F", posClass = posClass)
  F05 <- classificationMetrics(trues, preds, metrics="F", posClass = posClass, beta=0.5)
  F2 <- classificationMetrics(trues, preds, metrics="F", posClass = posClass, beta=2)
  
  c(prec=prec,
    rec=rec,
    F1 = F1,
    F05 = F05,
    F2 = F2,
    tptime=mean(trainpredtime))
}



# ===================================================
# Auxiliar function which returns a list with the classes names
# and frequency of a data set
# P.Branco, Mar 2015
# ---------------------------------------------------

class.freq <- function(dat, tgt){
  names <- sort(unique(dat[, tgt]))
  li <- list(names, 
             sapply(names, 
                    function(x) length(which(dat[, tgt] == x))))
  li
}


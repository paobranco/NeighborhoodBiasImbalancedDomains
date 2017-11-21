
library(e1071)                 # where the svm is
library(performanceEstimation) # exps framework
library(randomForest)          # randomForest
library(rpart)                 # rpart implementation
library(UBL)                   # smoteR
library(uba)                   # utility-based evaluation framework
library(nnet)                 # nnet

source("AuxsClassif.R")
source("LNSmoteClassif.R")
source("LNRandUnderClassif.R")
##############################################################
# THE USED DATA SETS
# ============================================================
load("DataSets16.Rdata")

#########################################################################
# to generate information about the data sets for a given threshold
#########################################################################
myDSs <- list(PredTask(class ~ ., DSs[[1]]@data,  "austCredit" ), 
              PredTask(class ~ ., DSs[[2]]@data,  "bankNote" ), 
              PredTask(class ~ ., DSs[[3]]@data,  "bloodT" ), 
              PredTask(diagnosis ~ ., DSs[[4]]@data,  "breastCDiag" ), 
              PredTask(Class ~ ., DSs[[5]]@data,  "breastCWisc" ), 
              PredTask(outcome ~ ., DSs[[6]]@data,  "breastCProg" ),
              PredTask(outcome ~ ., DSs[[7]]@data,  "climateSim" ), 
              PredTask(class ~ ., DSs[[8]]@data,  "creditApproval" ), 
              PredTask(class ~ ., DSs[[9]]@data,  "diabRetinopathy" ), 
              PredTask(class ~ ., DSs[[10]]@data,  "fertility" ), 
              PredTask(class ~ ., DSs[[11]]@data,  "germanCredit" ), 
              PredTask(SurvivalStatus ~ ., DSs[[12]]@data,  "haberman" ),
              PredTask(Class ~ ., DSs[[13]]@data,  "pima" ), 
              PredTask(class ~ ., DSs[[14]]@data,  "ringNorm" ), 
              PredTask(SURVIVED ~ ., DSs[[15]]@data,  "titanic" ), 
              PredTask(class ~ ., DSs[[16]]@data,  "vehicle" ))


##########################################################################
# learners and estimation procedure
##########################################################################

WFs <- list()
WFs$svm <- list(learner.pars=list(cost=c(10,150,300), gamma=c(0.01,0.001)))
WFs$randomForest <- list(learner.pars=list(mtry=c(5,7),ntree=c(500,750,1500)))
WFs$rpart <- list(learner.pars=list(minsplit=c(20,10),maxdepth=c(20,30)))
WFs$nnet <- list(learner.pars=list(size=c(1,2,5,10), decay=c(0,0.01)))

# exps with 2 times 10 fold CV
 CVsetts <- list(EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[1]]@data[,1])))
                                  ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)
                                ),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[2]]@data[,1])))
                                  ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)
                                ),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[3]]@data[,1])))
                                  ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[4]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[5]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[6]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[7]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[8]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[9]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[10]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[11]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[12]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[13]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[14]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[15]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)),
                 EstimationTask(metrics=c('prec', 'rec', 'F1', 'F05', 'F2', 'tptime'), 
                                evaluator="eval.stats", 
                                evaluator.pars=list(
                                  posClass = names(which.min(summary(DSs[[16]]@data[,1])))
                                ),
                                method=CV(nReps=2,nFolds=10,strat=TRUE)))

##########################################################################
# exps
##########################################################################

for(d in 1:16){
  for(w in names(WFs)) {
    resObj <- paste(myDSs[[d]]@taskName,w,'Res',sep='')
    assign(resObj,
           try(
             performanceEstimation(
               myDSs[d],         
               c(
                 do.call('workflowVariants',
                         c(list('WFnone', learner=w),
                           WFs[[w]],
                           varsRootName=paste('WFnone',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFRandUnder',learner=w,
                                C.perc="balance", repl=FALSE,
                                dist="HEOM", p=2, k=5),
                           WFs[[w]],
                           varsRootName=paste('WFRandUnder',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFRandUnderFT',learner=w,
                                C.perc="balance", repl=FALSE, Fr=TRUE,
                                dist="HEOM", p=2, k=5),
                           WFs[[w]],
                           varsRootName=paste('WFRandUnderFT',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFRandUnderFF',learner=w,
                                C.perc="balance", repl=FALSE, Fr=FALSE,
                                dist="HEOM", p=2, k=5),
                           WFs[[w]],
                           varsRootName=paste('WFRandUnderFF',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFsmote',learner=w,
                                C.perc="balance",
                                k=5, repl=FALSE,
                                dist="HEOM", p=2),
                           WFs[[w]],
                           varsRootName=paste('WFsmote',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFRFNFSmote',learner=w,
                                C.perc="balance", FrN=TRUE, FrR=TRUE,
                                k=5, repl=FALSE,
                                dist="HEOM", p=2),
                           WFs[[w]],
                           varsRootName=paste('WFRFNFsmote',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFRFNSmote',learner=w,
                                C.perc="balance",FrN=FALSE, FrR=TRUE,
                                k=5, repl=FALSE,
                                dist="HEOM", p=2),
                           WFs[[w]],
                           varsRootName=paste('WFRFNsmote',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFRNFSmote',learner=w,
                                C.perc="balance",FrN=TRUE, FrR=FALSE,
                                k=5, repl=FALSE,
                                dist="HEOM", p=2),
                           WFs[[w]],
                           varsRootName=paste('WFRNFsmote',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFRNSmote',learner=w,
                                C.perc="balance",FrN=FALSE, FrR=FALSE,
                                k=5, repl=FALSE,
                                dist="HEOM", p=2),
                           WFs[[w]],
                           varsRootName=paste('WFRNsmote',w,sep='.')
                         ))
               ),
               CVsetts[[d]])
           )
    )
    if (class(get(resObj)) != 'try-error') save(list=resObj,file=paste(myDSs[[d]]@taskName,w,'Rdata',sep='.'))
  }
}


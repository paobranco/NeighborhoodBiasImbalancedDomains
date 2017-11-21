## ===================================================
## Smote for regression with Neighborhood bias
# ---------------------------------------------------
LNSmoteClassif <- function(form, dat, C.perc = "balance", FrN=TRUE, FrR=TRUE, 
                           k = 5, repl = FALSE, dist = "HEOM", p = 2)
  
  # INPUTS:
  # form    a model formula
  # dat     the original training set (with the unbalanced distribution)
  # C.perc  is a list containing the percentage of under- or/and 
  #         over-sampling to apply to each "class" obtained with the threshold.
  #         The over-sampling percentage means that the examples above the 
  #         threshold are increased by this percentage. The under sampling
  #         percentage means that the normal cases (cases below the threshold)
  #         are under-sampled by this percentage. Alternatively it may be
  #         "balance" or "extreme", cases where the sampling percentages
  #         are automatically estimated.
  # FrN     logical. Reinforce the frontier or safer normal cases.
  # FrR     logical. Reinforce the frontier or safer rare cases.
  # k       is the number of neighbors to consider as the pool from where
  #         the new synthetic examples are generated
  # repl    is it allowed to perform sampling with replacement
  # dist    is the distance measure to be used (defaults to "Euclidean")
  # p       is a parameter used when a p-norm is computed
{
 
  if (any(is.na(dat))) {
    stop("The data set provided contains NA values!")
  }
  # the column where the target variable is
  tgt <- which(names(dat) == as.character(form[[2]]))
  names <- sort(unique(dat[, tgt]))
  li <- class.freq(dat, tgt)
  if (tgt < ncol(dat)) {
    orig.order <- colnames(dat)
    cols <- 1:ncol(dat)
    cols[c(tgt, ncol(dat))] <- cols[c(ncol(dat), tgt)]
    dat <- dat[, cols]
  }
  
  kNNs <- neighbours(tgt, dat, dist, p, k)
  
  if (is.list(C.perc)) {
    names.und <- names(which(C.perc < 1))
    names.ove <- names(which(C.perc > 1))
    names.same <- setdiff(names, union(names.und, names.ove))
    
    # include examples from classes unchanged
    newdata <- dat[which(dat[, ncol(dat)] %in% names.same), ]
    
    if (length(names.und)) {  # perform under-sampling
      for (i in 1:length(names.und)) {
        Exs <- which(dat[, ncol(dat)] == names.und[i])
        if(FrN){ # reinforce the frontier normal cases
          r <- c()
          for(ex in Exs){
            r <- c(r, length(which(!(kNNs[ex,] %in% (Exs))))/k)
          }
        } else {# reinforce the far from frontier normal cases, i.e., the safe normal cases
          r <- c()
          for(ex in Exs){
            r <- c(r, length(which((kNNs[ex,] %in% (Exs))))/k)
          }
        }
        # to avoid error of "too few positive probabilities"
        new.r <- r + 0.1      
        
        # case vector r is always zero!
        if (any(is.na(new.r))){
          new.r <- NULL
        }
        # select examples to keep!
        sel <- sample(Exs,
                      as.integer(C.perc[[names.und[i]]] * length(Exs)),
                      replace = repl,
                      prob = new.r)
        newdata <- rbind(newdata, dat[sel, ])
      }
    }
    if (length(names.ove)) { # perform over-sampling
      for (i in 1:length(names.ove)) {
        if(length(which(dat[, ncol(dat)] == names.ove[i])) == 1){
          warning(paste("SmoteClassif :: Unable to use SmoteClassif in a bump with 1 example.
                        Introducing replicas of the example."), call.=FALSE)
          newdata <- rbind(newdata, dat[rep(which(dat[, ncol(dat)] == names.ove[i]),C.perc[names.ove[i]]),])
        } else if (length(which(dat[, ncol(dat)] == names.ove[i])) <= k){
          warning(paste("SmoteClassif :: Nr of examples is less or equal to k.\n Using k =",
                        length(which(dat[, ncol(dat)] == names.ove[i]))-1, 
                        "in the nearest neighbours computation in this bump."), call.=FALSE)
          Origk <- k
          k <- length(which(dat[, ncol(dat)] == names.ove[i]))-1
          newExs <- Smote.exsClassifFr(dat, which(dat[, ncol(dat)] == names.ove[i]),
                                     ncol(dat), li[[3]][ove[i]]/li[[2]][ove[i]] + 1,
                                     k, dist, p, FrR)
          # add original rare examples and synthetic generated examples
          newdata <- rbind(newdata, newExs, 
                           dat[which(dat[,ncol(dat)] == names.ove[i]),])
          k <- Origk
        } else {
          newExs <- Smote.exsClassifFr(dat, which(dat[, ncol(dat)] == names.ove[i]),
                                     ncol(dat), C.perc[[names.ove[i]]], k, dist,
                                     p, FrR)
          # add original rare examples and synthetic generated examples
          newdata <- rbind(newdata, newExs,
                           dat[which(dat[, ncol(dat)] == names.ove[i]), ])
        }
      }
    }
  } else {
    if (C.perc == "balance") {  
      li[[3]] <- round(sum(li[[2]])/length(li[[2]]), 0) - li[[2]]
    } else if (C.perc == "extreme") {
      med <- sum(li[[2]])/length(li[[2]])
      li[[3]] <- round(med^2/li[[2]] * sum(li[[2]])/sum(med^2/li[[2]]), 0) - li[[2]]
    } else {
      stop("Please provide a list with classes to under-/over-sample
           or alternatively indicate 'balance' or 'extreme'.")
    }
    und <- which(li[[3]] < 0) # classes to under-sample
    ove <- which(li[[3]] > 0) #classes to over-sample
    same <- which(li[[3]] == 0) # unchanged classes
    
    # include examples from classes unchanged
    newdata <- dat[which(dat[, ncol(dat)] %in% li[[1]][same]), ]
    
    if (length(und)) { #perform under-sampling
      for (i in 1:length(und)) { 
        Exs <- which(dat[, ncol(dat)] == li[[1]][und[i]])
        if(FrN){ # reinforce the frontier normal cases
          r <- c()
          for(ex in Exs){
            r <- c(r, length(which(!(kNNs[ex,] %in% (Exs))))/k)
          }
        } else {# reinforce the far from frontier normal cases, i.e., the safe normal cases
          r <- c()
          for(ex in Exs){
            r <- c(r, length(which((kNNs[ex,] %in% (Exs))))/k)
          }
        }
        # to avoid error of "too few positive probabilities"
        new.r <- r + 0.1      
        # case vector r is always zero!
        if (any(is.na(new.r))){
          new.r <- NULL
        }
        # select examples to keep!
        sel <- sample(Exs,
                      as.integer(li[[2]][und[i]] + li[[3]][und[i]]),
                      replace = repl, prob = new.r)
        newdata <- rbind(newdata, dat[sel, ])
      }
    }
    if (length(ove)) { #perform over-sampling
      for (i in 1:length(ove)) {
        if(length(which(dat[, ncol(dat)] == li[[1]][ove[i]])) == 1){
          warning(paste("SmoteClassif :: Unable to use SmoteClassif in a bump with 1 example.
                        Introducing replicas of the example."), call.=FALSE)
          newdata <- rbind(newdata, dat[rep(which(dat[, ncol(dat)] == li[[1]][ove[i]]), li[[3]][ove[i]]),])
        } else if(length(which(dat[, ncol(dat)] == li[[1]][ove[i]]))<= k){
          warning(paste("SmoteClassif :: Nr of examples is less or equal to k.\n Using k =",
                        length(which(dat[, ncol(dat)] == li[[1]][ove[i]]))-1, 
                        "in the nearest neighbours computation in this bump."), call.=FALSE)
          Origk <- k
          k <- length(which(dat[, ncol(dat)] == li[[1]][ove[i]]))-1
          newExs <- Smote.exsClassifFr(dat, which(dat[, ncol(dat)] == li[[1]][ove[i]]),
                                     ncol(dat), li[[3]][ove[i]]/li[[2]][ove[i]] + 1,
                                     k, dist, p, FrR)
          # add original rare examples and synthetic generated examples
          newdata <- rbind(newdata, newExs, 
                           dat[which(dat[,ncol(dat)] == li[[1]][ove[i]]),])
          k <- Origk
        } else {
          newExs <- Smote.exsClassifFr(dat, which(dat[, ncol(dat)] == li[[1]][ove[i]]),
                                     ncol(dat), li[[3]][ove[i]]/li[[2]][ove[i]] + 1,
                                     k, dist, p, FrR)
          # add original rare examples and synthetic generated examples
          newdata <- rbind(newdata, newExs, 
                           dat[which(dat[,ncol(dat)] == li[[1]][ove[i]]),])
        }
      } 
    }
  }
    
  if (tgt < ncol(dat)) {
    newdata <- newdata[,cols]
    dat <- dat[,cols]
  }
  
  newdata
}
  


# ===================================================
# Obtain a set of smoted examples for a set of rare cases.
#
# ---------------------------------------------------
Smote.exsClassifFr <- function(orig, ind, tgt, N, k, dist, p, Fr)
  # INPUTS:
  # orig the original data set with rare and normal cases
  # ind are the indexes of the rare cases (the minority "class" cases)
  # tgt the column nr of the target variable
  # N is the percentage of over-sampling to carry out;
  # and k is the number of nearest neighours
  # dist is the distance function used for the neighours computation
  # p is an integer used when a "p-norm" distance is selected
  # Fr logical indicating the behaviour that should be applied. 
  # If TRUE the frontier is reinforced, else the safe points far away
  # from the frontier are reinforced
  # OUTPUTS:
  # The result of the function is a (N-1)*nrow(dat) set of generate
  # examples with rare values on the target
{
  
  # assumes tgt is the last column in orig data
  # this is pre-processed in smote main function
  dat <- orig[ind,]
  

  nomatr <- c()
  T <- matrix(nrow = dim(dat)[1], ncol = dim(dat)[2] - 1)
  for (col in seq.int(dim(T)[2])) { 
    if (class(dat[, col]) %in% c('factor', 'character')) {
      T[, col] <- as.integer(dat[, col])
      nomatr <- c(nomatr, col)
    } else {
      T[, col] <- dat[, col]
    }
  }
  nC <- dim(T)[2]
  nT <- dim(T)[1]
  

  # check if there is enough data to determine the k neighbors
  if (nT <= k) {
    stop("Trying to determine ",k, " neighbors for a subset with only ",
         nT, " examples")
  }
  
  kNNs <- neighbours(tgt, orig, dist, p, k)
  
  # for each example in the partition under consideration
  # determine nr of examples out of the partition in the KNN
  r <- c()
  if(Fr){
    for(ex in ind){
      r <- c(r, length(which(!(kNNs[ex,] %in% (ind))))/k)
    }
  } else {
    for(ex in ind){
      r <- c(r, length(which((kNNs[ex,] %in% (ind))))/k)
    }
    
  }
  
  # normalize
  new.r <- r/sum(r)
  
  # case vector r is always zero!
  if (any(is.na(new.r))){
    r <- rep(1, nrow(dat))
    new.r <- r/sum(r)
  }
  
  
  nexs <-  as.integer(N - 1) # nr of examples to generate for each rare case
  extra <- as.integer(nT * (N - 1 - nexs)) # the extra examples to generate
  idx <- sample(1:nT, extra)
  newM <- matrix(nrow = nexs * nT + extra, ncol = nC)    # the new cases
  
  NrSynth <- nexs*nT+extra
  
  
  # for each ex generate g_i new examples
  g <- round(new.r*NrSynth, 0)
  
  # correct g for matching NrSynth if necessary
  if(sum(g) > NrSynth){
    rem <- sum(g) - NrSynth
    if(all(g != 0)){
      sp <- sample(1:nrow(dat), rem)
      g[sp] <- g[sp] - 1
    } else {
      g.zero <- which(g == 0)
      sp <- sample(setdiff(1:nrow(dat), g.zero), rem)
      g[sp] <- g[sp] - 1
    }
  }
  if(sum(g)< NrSynth){
    add <- NrSynth - sum(g)
    sp <- sample(1:nrow(dat), add)
    g[sp] <- g[sp]+1
  }
  
  if (nrow(dat) > k){
    kNNsLoc <- neighbours(tgt, dat, dist, p, k)
  } else if (nrow(dat)>=2){
    kNNsLoc <- neighbours(tgt, dat, dist, p, (nrow(dat)-1))
    k <- nrow(dat)-1
  } else if(nrow(dat)<2){
    stop("Unable to determine neighbors using only one example!")
  }
  
  count <- 1
  for(i in 1:nrow(dat)){
    if(g[i] != 0){
      for(n in 1:g[i]){
        # select randomly one of the k NNs
        neig <- sample(1:k, 1)
        # the attribute values of the generated case
        difs <- T[kNNsLoc[i, neig], ] - T[i, ]
        newM[count, ] <- T[i, ] + runif(1) * difs
        for (a in nomatr) {
          # nominal attributes are randomly selected among the existing
          # values of seed and the selected neighbour 
          newM[count, a] <- c(T[kNNsLoc[i, neig], a],
                              T[i, a])[1 + round(runif(1), 0)]
        }
        count <- count + 1
      }
    }
  }

  
  newCases <- data.frame(newM)
  
  for (a in nomatr){
    newCases[, a] <- factor(newCases[, a],
                            levels = 1:nlevels(orig[, a]),
                            labels = levels(orig[, a]))
  }
  newCases[, tgt] <- factor(rep(dat[1, tgt], nrow(newCases)),
                            levels = levels(orig[, tgt]))
  colnames(newCases) <- colnames(dat)
  
  newCases
  
}


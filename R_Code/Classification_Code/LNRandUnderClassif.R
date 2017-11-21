# ===================================================
# Performs an under-sampling strategy for classification problems
# with a bias towards the frontier or towards the safe cases.
# ---------------------------------------------------
LNRandUnderClassif <- function(form, dat, C.perc = "balance", repl = FALSE,
                               Fr=NULL, dist="HEOM", p=2, k=5)
    # Args:
  # form   a model formula
  # dat   the original training set (with the imbalanced distribution)
  # C.perc is a named list containing each class under-sampling percentage
  #        (between 0 and 1).
  #        The user may only provide the classes where he wants to apply 
  #        under-sampling. Alternatively it may be "balance" (the default)
  #        or "extreme", cases where the under-sampling percentages
  #        are automatically estimated
  # repl   is it allowed or not to perform sampling with replacement
  # Fr  logical. Notion applied to the normal cases which are the ones being undersampled
  #        Is the frontier of the normal cases reinforced (TRUE) or are
  #        the safe normal cases (FALSE). If Fr is set to NULL, random undersampling
  #        is applied
  # dist  character specifying the distance metric to use when computing neighbors
  # p     numeric required when a p-norm is computed
  # k    numeric. Nr. of neighbors to compute 
  # Returns: a data frame modified by the random under-sampling strategy
  #           with neighborhood bias
{
  # the column where the target variable is
  tgt <- which(names(dat) == as.character(form[[2]]))
  names <- sort(unique(dat[, tgt]))
  li <- class.freq(dat, tgt)

  if(!is.null(Fr)){
    kNNs <- neighbours(tgt, dat, dist, p, k)
  }

  
  if (is.list(C.perc)) { 
    # the under-sampling percentages are provided by the user
    if (any(C.perc > 1)) {
      stop("The percentages provided must be < 1 to perform under-sampling!")
    }
    names.und <- names(which(C.perc < 1))

    # include examples from classes unchanged
    newdata <- dat[which(dat[, tgt] %in% names[which(!(names %in% names.und))]), ]
    

    for (i in 1:length(names.und)) { # under-sampling each class provided
      Exs <- which(dat[,tgt] == names.und[i])

      if(is.null(Fr)){ # random under-sampling
        r <- NA
      }else if(Fr){ # reinforce the frontier cases
        r <- c()
        for(ex in Exs){
          r <- c(r, length(which(!(kNNs[ex,] %in% (Exs))))/k)
        }
      } else {# reinforce the far from frontier cases, i.e., the safe cases
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
  } else if (C.perc == "balance") { 
  # the under-sampling percentages must be calculated
    minCl <- names(which(table(dat[, tgt]) == min(table(dat[, tgt]))))
    if (length(minCl) == length(names)) {
      stop("Classes are already balanced!")
    }
    # add the cases of the minority classes
    minExs <- which(dat[, tgt] %in% minCl)
    newdata <- dat[minExs, ]
    names.und <- names[which(!(names %in% minCl))]
    
    # under-sample all the other classes

    
    for (i in 1:length(names.und)) { 
      Exs <- which(dat[, tgt] == names.und[i])

      if(is.null(Fr)){
        r <- NA
      } else if(Fr){ # reinforce the frontier cases
        # keeps the frontier normal cases
        r <- c()
        for(ex in Exs){
          r <- c(r, length(which(!(kNNs[ex,] %in% (Exs))))/k)
        }
      } else {# reinforce the far from frontier cases (the safe cases)
        # keeps the safer normal examples
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
                      as.integer(li[[2]][as.numeric(match(minCl, names))[1]]),
                      replace = repl,
                      prob = new.r)
        newdata <- rbind(newdata, dat[sel, ])
    }
  }else if (C.perc == "extreme") {
    #"reverse" the classes frequencies (freq.min^2/freq. each class)
    minCl <- names(which(table(dat[, tgt]) == min(table(dat[, tgt]))))
    if (length(minCl) == length(names)) {
      stop("Classes are balanced. Unable to reverse the frequencies!")
    }
    # add the cases of the minority classes
    minExs <- which(dat[, tgt] %in% minCl)
    newdata <- dat[minExs, ]
    names.und <- names[which(!(names %in% minCl))]
    

    # under-sample all the other classes reversing frequencies 
    for(i in 1:length(names.und)){ 
      Exs <- which(dat[, tgt] == names.und[i])

      mmcl <- as.numeric(match(minCl, names))
      num1 <- (li[[2]][mmcl[1]])^2/li[[2]][as.numeric(match(names.und[i], 
                                                            names))]
      if(is.null(Fr)){
        r <- NA
      } else if(Fr){ # reinforce the frontier cases
        r <- c()
        for(ex in Exs){
          r <- c(r, length(which(!(kNNs[ex,] %in% (Exs))))/k)
        }
      } else {# reinforce the far from frontier cases (the safe cases)
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
                    as.integer(num1),
                    replace = repl,
                    prob = new.r)
      newdata <- rbind(newdata, dat[sel, ])
    }      
  } else {
    stop("Please provide a list with classes to under-sample 
         or alternative specify 'balance' or 'extreme'.")
  }
  
  newdata
}

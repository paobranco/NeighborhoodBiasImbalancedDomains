## Reproducing the Paper Imbalanced Regression Experiments

## Contents

  This folder contains  all code that is necessary to replicate the experiments concerning the imbalanced classification tasks reported in the paper *"Resampling with Neighborhood Bias on Imbalanced Domains"* [1].

  The folder contains the following files:

  - **LNSmoteClassif.R**  the code implementing the strategies for smote for regression with neighborhood bias

  - **LNRandUnderClassif.R** the code implementing the strategies for under-sampling with neighborhood bias

  - **newExpsLNClassif.R**     the script for obtaining the results for the different workflows (baseline with no sampling, smote, random under-sampling and the proposed variants of smote and random under-sampling with neighborhood bias)

  - **AuxsClassif.R**    the script with auxiliary functions for defining the workflows and the evaluation procedure

  - **README.md**               this file


## Necessary Software

To replicate these experiments you will need a working installation of R. Check [https://www.r-project.org/] if you need to download and install it.

In your R installation you also need to install the following additional R packages:

  - performanceEstimation
  - UBL
  - uba
  - e1071
  - randomForest
  - nnet
  - rpart

  All the above packages with exception of uba, can be installed from CRAN Repository directly as any "normal" R package. Essentially you need to issue the following command within R:

```r
install.packages(c("performanceEstimation", "UBL", "e1071"", "randomForest", "nnet", "rpart"))
```

Additionally, you will need to install uba package from a tar.gz file that you can download from [http://www.dcc.fc.up.pt/~rpribeiro/uba/]. 

For installing this package issue the following command within R:
```r
install.packages("uba_0.7.7.tar.gz",repos=NULL,dependencies=T)
```


## Running the experiences:

Before running the experiments you need to load the data sets used in R. To obtain the 16 classification data sets and to see how you can load them, please check the README.md file in the **Data** folder. After having the necessary data sets, to run the experiments described in the paper you execute R in the folder with the code and then issue the command:
```r
source("newExpsLNClassif.R")
```

Alternatively, you may run the experiments directly from a Linux terminal
  (useful if you want to logout because some experiments take a long
  time to run):

```bash
nohup R --vanilla --quiet < newExpsLNClassif.R &
```

## Running a subset of the experiences:

  Given that the experiments take  long time to run, you may be interested in running only a partial set of experiments. To do this you must edit the newExpsLN2.R file. 
  
  Lets say, for instance, that you want to run all the workflows in only one data set. To do this, you can change the instruction ```for( d in 1:16)``` in line 155.
  
You can also change the number and/or the values of the learning algorithms parameters. To achieve this edit the ```WFs``` list in lines 46 to 49.
  
After making all the necessary changes run the experiments as previously explained.

*****

### References
[1] Branco, P. and Torgo, L. and Ribeiro R.P. (2017) *"Resampling with Neighborhood Bias on Imbalanced Domains"* Expert Systems (submitted).
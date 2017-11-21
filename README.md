## Resampling with Neighborhood Bias on Imbalanced Domains

This repository has all the data and code used in the experiments carried out in the paper *"Resampling with Neighborhood Bias on Imbalanced Domains"* [1].

This repository is organized as follows:

* **R_Code** folder - contains all the code for reproducing the experiments described in the paper for both regression and classification imbalanced problems;
* **Figures** folder - contains all the figures obtained from the experimental evaluation on the used regression and classification data sets;
* **Data** folder - contains the classification and regression data sets used in the experiments carried out;
* **Tables** folder - contains the tables with the classification and regression results of the experiments carried out.



Each folder above is organized with a README file and two folders: one for the classification tasks and another for the regression tasks.

### Requirements

The experimental design was implemented in R language. Both code and data are in a format suitable for R environment.

In order to replicate these experiments you will need a working installation of R. Check [https://www.r-project.org/] if you need to download and install it.

In your R installation you also need to install the following additional R packages:

  - DMwR
  - performanceEstimation
  - UBL
  - uba
  - e1071
  - randomForest
  - earth
  - nnet
  - rpart


All the above packages, with the exception of uba package, can be installed from CRAN Repository directly as any "normal" R package. Essentially you need to issue the following command within R:

```r
install.packages(c("DMwR", "performanceEstimation", UBL", "e1071", "randomForest", "earth", "nnet", "rpart"))
```

Additionally, you will need to install uba package from a tar.gz file that you can download from [http://www.dcc.fc.up.pt/~rpribeiro/uba/]. 

For installing this package issue the following command within R:
```r
install.packages("uba_0.7.7.tar.gz",repos=NULL,dependencies=T)
```


To replicate the figure in this repository you will also need to install the package:

  - ggplot2

As with any R package, we only need to issue the following command:

```r
install.packages("ggplot2")
```

Check the README files inside each folder to see more detailed instructions on how to run the experiments.

*****

### References
[1] Branco, P. and Torgo, L. and Ribeiro R.P. (2017) *"Resampling with Neighborhood Bias on Imbalanced Domains"* Expert Systems (submitted).
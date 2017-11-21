# Classification Data Sets Used #

### Load the Data Sets in R ###
For loading all the 16 classification data sets in R you need to issue the following command:

```r
load("DataSets16.Rdata")
```

This will load into R an object named `DSs` which contains a list with 16 objects of class `dataset` from package DMwR.


### Classification Data Sets Description ###
The main characteristics of the 16 classification data sets included in this folder are as follows:







ID  | Data Set   | N    | tpred | p.nom | p.num | nRare | % Rare |
----|------------|------|-------|-------|-------|-------|--------|
DS1 |ringNorm | 7400 | 20 | 0 | 20 | 3664 | 49.5 |
DS2 |diabRetinopathy | 1151 | 19 | 0 | 19 | 540 | 46.9 |
DS3 |creditApproval | 653 | 15 | 9 | 6 | 296 | 45.3 |
DS4 | austCredit | 690 | 14 | 0 | 14 | 307 | 44.5 |
DS5 |bankNote | 1372 | 4 | 0 | 4 | 610 | 44.5 |
DS6 |breastCDiag | 569 | 31 | 0 | 31 | 212 | 37.3 |
DS7 |breastCWisc | 683 | 10 | 0 | 10 | 239 | 35.0 |
DS8 |pima | 768 | 8 | 0 | 8 | 268 | 34.9 |
DS9 |titanic | 2201 | 3 | 3 | 0 | 711 | 32.3 |
DS10 |germanCredit | 1000 | 20 | 13 | 7 | 300 | 30.0 |
DS11 |haberman | 306 | 3 | 0 | 3 | 81 | 26.5 |
DS12 |bloodT | 748 | 4 | 0 | 4 | 178 | 23.8 |
DS13 |breastCProg | 194 | 34 | 0 | 34 | 46 | 23.7 |
DS14 |vehicle | 846 | 18 | 0 | 18 | 199 | 23.5 |
DS15 |fertility | 100 | 9 | 0 | 9 | 12 | 12.0 |
DS16 |climateSim | 540 | 20 | 0 | 20 | 46 | 8.5 |


where, 

N is the number of examples in the data set, 

tpred is the total number of features, 

p.nom is the number of nominal features, 

p.num is the number of numeric features, 

nRare is the number of rare cases and 

%Rare is the percentage of rare cases in the data set.

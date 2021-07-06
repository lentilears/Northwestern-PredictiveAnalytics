/*Assignment 3*/
libname orion '/sscc/home/a/abv902/ecourse';
data ames; set orion.ames_housing;

ods graphics on;


data temp; set ames;
TotalFlrSF = FirstFlrSF + SecondFlrSF; 
houseage = YrSold - YearBuilt;

data temp; set temp; drop FirstFlrSF SecondFlrSF;

data temp; set temp; keep TotalFlrSF GrLivArea houseage BedroomAbvGr FullBath KitchenQual 
WoodDeckSF BsmtFinSF1 OverallQual CentralAir GarageCars SalePrice BldgType;

** Task 1 - creating transformed variables;

data temp; set temp;
LogSalePrice = log(SalePrice);
SqrtSalePrice = sqrt(SalePrice);
LogGrLivArea = log(GrLivArea);
SqrtGrLivArea = sqrt(GrLivArea);
	proc print data=temp (obs=10);
	
* Task 2 - 4 SLR models;
proc reg data=temp;
model SalePrice = GrLivArea/ vif ;
title 'SLR - SalePrice vs GrLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model LogSalePrice = GrLivArea/ vif ;
title 'SLR - LogSalePrice vs GrLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model SalePrice = LogGrLivArea/ vif ;
title 'SLR - SalePrice vs LogGrLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model LogSalePrice = LogGrLivArea/ vif ;
title 'SLR - LogSalePrice vs LogGrLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;


** Task 3 - Correlation;
PROC CORR DATA=temp PLOT=(matrix) plots(maxpoints=NONE);
VAR SalePrice LogSalePrice SqrtSalePrice;
WITH WoodDeckSF GrLivArea BsmtFinSF1 OverallQual;
title 'Correlation of Various Continuous Variables against Transformations of SalePrice';
run;

proc sgscatter data=temp;
compare Y=SalePrice X=GrLivArea / loess reg;
run;
proc sgscatter data=temp;
compare Y=LogSalePrice X=GrLivArea / loess reg;
run;
proc sgscatter data=temp;
compare Y=SqrtSalePrice X=GrLivArea / loess reg;
run;


** task 4 Regression with Sqrt transformation;
PROC CORR DATA=temp PLOT=(matrix) plots(maxpoints=NONE);
VAR SalePrice LogSalePrice SqrtSalePrice;
WITH GrLivArea;
title 'Correlation of GrLivArea against SqrtSalePrice';
run;


proc reg data=temp;
model SqrtSalePrice = GrLivArea/ vif ;
title 'SLR - Sqrtsaleprice versus GrLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model SqrtSalePrice = SqrtGrLivArea/ vif ;
title 'SLR - Sqrtsaleprice versus SqrtGrLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;


** Task 5 Outliers;
** Task 6 Refit models from Assign #2 parts 2,5,6;
data temp; set temp;
format outlier_def $30.; 
outlier_def = 0; /* a 0 would indicate a valid record  */
if(SalePrice < 20000) then outlier_code=1;
if(SalePrice >= 340000)then outlier_code=2;
if(outlier_code > 1) then delete;

proc reg data=temp outest=rsq_var;
Title 'Model 2 - SLR with best R-Squared';
model SalePrice = TotalFlrSF GrLivArea houseage OverallQual
        FullBath WoodDeckSF BsmtFinSF1/ selection = rsquare AIC VIF BIC MSE best=1 B stop = 1;
output out=model_R2 pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model SalePrice = FullBath OverallQual/ vif;
title 'Model 5 - MLR with FullBath and OverallQual';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model SalePrice = FullBath OverallQual BedroomAbvGr/ vif;
title 'Model 6 - MLR with FullBath, OverallQual and BedroomAbvGr';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

** task 7 Model based outliers;
proc reg data=temp outest=outputmod1;
model LogSalePrice = FullBath OverallQual GrLivArea/ vif ;
title 'Three variable Regression Model with log transformation';
output out=fitted_model pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

** DFFITS threshold is 2*Sqrt(p/n) = 2*Sqrt(4/2840) = 0.075;

data out2; set fitted_model; if abs(dfits) > 0.075 then delete;**removes outliers;
 
proc reg data=out2 outest=outputmod2;
model LogSalePrice = FullBath OverallQual GrLivArea/ vif ;
title 'Three variable Regression Model with log transformation-Outliers Removed';
output out=fitted_model pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;




	

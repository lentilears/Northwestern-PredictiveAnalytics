/*Assignment 2*/
libname orion '/sscc/home/a/abv902/ecourse';
data ames; set orion.ames_housing;

ods graphics on;

data temp; set ames;
TotalFlrSF = FirstFlrSF + SecondFlrSF; 
houseage = YrSold - YearBuilt;

data temp; set temp; drop FirstFlrSF SecondFlrSF;

data temp; set temp; keep TotalFlrSF GrLivArea houseage Zoning BedroomAbvGr FullBath KitchenQual 
WoodDeckSF BsmtFinSF1 OverallQual CentralAir Alley GarageCars SalePrice Condition1 BldgType 
Electrical Heating Utilities RoofStyle;

** Task 1 Simple Linear Regression with approximate r=0.5;
proc reg data=temp;
model SalePrice = FullBath/ vif;
title 'Model 1 - SLR with FullBath';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;
/*
proc gplot data=fitted_model;
plot SalePrice*houseage yhat*houseage / overlay;
title 'Output from Gplot for Model 1 -  with FullBath';
run;
*/

** task 2 'best' SLR;
Proc Reg data=temp outest=rsq_var;
	Title 'Model 2 - SLR with best R-Squared';
	model SalePrice = TotalFlrSF GrLivArea houseage OverallQual
        FullBath WoodDeckSF BsmtFinSF1/ selection = rsquare AIC VIF BIC MSE best=1 B stop = 1;
		 output out=model_R2 pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
		 covratio=cov dffits=dfits press=prss;
run;


** Task 3 Simple Linear Regression with KitchenQual (categorical variable);
proc reg data=temp;
model SalePrice = KitchenQual/ vif;
title 'Model 3 - SLR with Kitchen Quality';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;


** task 5 MLR with FullBath & Overall Quality;
proc reg data=temp;
model SalePrice = FullBath OverallQual/ vif;
title 'Model 5 - MLR with FullBath and OverallQual';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;


** task 6 MLR with FullBath & Overall Quality along with BedroomAbvGr;
proc reg data=temp;
model SalePrice = FullBath OverallQual BedroomAbvGr/ vif;
title 'Model 6 - MLR with FullBath, OverallQual and BedroomAbvGr';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;


** Extra task  MLR with FullBath, Overall Quality along with GrLivArea;
proc reg data=temp;
model SalePrice = FullBath OverallQual GrLivArea/ vif;
title 'Model 7 - MLR with FullBath, OverallQual and GrLivArea';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;










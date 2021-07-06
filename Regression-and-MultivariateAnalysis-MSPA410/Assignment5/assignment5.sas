/*Assignment 5*/
libname orion '/sscc/home/a/abv902/ecourse';
data ames; set orion.ames_housing;

ods graphics on;


data temp; set ames;
TotalFlrSF = FirstFlrSF + SecondFlrSF; 
houseage = YrSold - YearBuilt;
TotalBath = FullBath + HalfBath + BsmtFullBath + BsmtHalfBath;

data temp; set temp; keep TotalFlrSF GrLivArea houseage Zoning LotShape OverallQual
HouseStyle Alley FullBath LotArea SalePrice BldgType BsmtFinSF1 TotalBath;

** creating transformed variables & dummy variables;

data temp; set temp;
LogSalePrice = log(SalePrice);
LogTotalFlrSF = log(TotalFlrSF);
If HouseStyle = '1Story' then Style1 = 1; else Style1 = 0;
If HouseStyle = '2Story' then Style2 = 1; else Style2 = 0;
** Note: For Story1, Style1=1 & Style2=0.. For Story2, Style1=0 & Style2=1..
For all other stories, Style1=0 & Style2=0;

********* Task 1 ;
data temp; set temp;
If HouseStyle = '1Story' then StyleCategory = 1;
 else If HouseStyle = '2Story' then StyleCategory = 2; 
   else StyleCategory = 0;
** Note: This is the WRONG WAY! We are 'randomly' assigning 0,1,2;

 proc sort; by StyleCategory;	
 proc means; var SalePrice; by StyleCategory; run;
 proc reg data=temp;
model SalePrice = StyleCategory;
title 'Model 1 - SLR with StyleCategory';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

** y = 147706 + 30045 X .. yhat = 147706, 177751, 207796.. Line does NOT thru means;
**********;

** task 2;

data temp; set temp;
If HouseStyle = '1Story' then Style1 = 1; else Style1 = 0;
If HouseStyle = '2Story' then Style2 = 1; else Style2 = 0;

proc reg data=temp;
model SalePrice = Style1 Style2;
title 'Model 2A - SLR with Style1 & Style2';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

** y = 146485 + 32215*Style1 + 60505*Style2
 yhat = 146485, 178700, 206990.. Plane DOES pass thru means;
 ** Note that when Style1=Style2=0, then yhat=146485=intercept (baseline);
** When Style1=1 & Style2=0 then yhat = 146485+32215=178700;
** When Style1=0 & Style2=0 then yhat = 146485+60505 = 206990;
**********;

** Task 3 - report;

** task 4;

data temp; set temp;
If Zoning = 'RL' then Zone1 = 1; else Zone1 = 0;
If Zoning = 'RM' then Zone2 = 1; else Zone2 = 0;

proc reg data=temp;
model SalePrice = Zone1 Zone2;
title 'Model 2B - SLR with Zone1 & Zone2';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

*** Task 5 revised;
/*STEPWISE*/
Proc Reg data=temp outest=stepwise_summary;
	Title 'Stepwise';
	model SalePrice = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2} {Zone1 Zone2}/ 
        selection = stepwise AIC VIF BIC MSE groupnames = 'Style' 'Zone';;
        output out=stepwise_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;
proc print data=stepwise_summary;

/*FORWARD*/
Proc Reg data=temp outest=forward_summary;
	Title 'FORWARD';
	model SalePrice = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2} {Zone1 Zone2}/ 
        selection = forward AIC VIF BIC MSE groupnames = 'Style' 'Zone';;
        output out=forward_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;
proc print data=forward_summary;

/*BACKWARD*/
Proc Reg data=temp outest=backward_summary;
	Title 'BACKWARD';
	model SalePrice = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2} {Zone1 Zone2}/ 
        selection = backward AIC VIF BIC MSE groupnames = 'Style' 'Zone';;
        output out=backward_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;
proc print data=backward_summary;

/*ADJUSTED R-SQUARED*/
Proc Reg data=temp outest=adjrsq_summary;
	Title 'ADJUSTED R-SQUARED';
	model SalePrice = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2} {Zone1 Zone2}/ 
        selection = adjrsq AIC VIF BIC MSE groupnames = 'Style' 'Zone';;
        output out=adjrsq_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;


/*R-SQUARED*/
Proc Reg data=temp outest=rsquared_summary;
	Title 'R-SQUARED';
	model SalePrice = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2} {Zone1 Zone2}/ 
        selection = rsquare AIC VIF BIC MSE groupnames = 'Style' 'Zone';;
        output out=rsquared_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;


/*MALLOWS CP*/
Proc Reg data=temp outest=mallowscp_summary;
	Title 'MALLOWS CP';
	model SalePrice = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2} {Zone1 Zone2}/ 
        selection = cp AIC VIF BIC MSE groupnames = 'Style' 'Zone';;
        output out=mallowscp_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;

*** Task 6;
/*Remove Zoning variable but using Stepwise selection*/
Proc Reg data=temp outest=stepwise_summary;
	Title 'Stepwise';
	model SalePrice = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2}/ 
        selection = stepwise AIC VIF BIC MSE groupnames = 'Style' 'Zone';;
        output out=stepwise_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;
proc print data=stepwise_summary;

** Task 7;
* Defining training set (70% of the data) & test set (30% of the data);
* We have created a variable called train_response which is same as log sale price
* except that we have defined it as 'missing value' for the test set;

data temp2; set temp;
* generate a uniform(0,1) random variable with seed set to 123; 
u = uniform(123);
if (u < 0.70) then train = 1;
else train = 0;
if (train=1) then train_response=LogSalePrice; else train_response=.;
run;

proc print data=temp2(obs=5); run;

** task 8  ;
/*STEPWISE*/
Proc Reg data=temp2 outest=stepwise_summary;
	Title 'Stepwise';
	model train_response = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2}/ 
        selection = stepwise AIC VIF BIC MSE groupnames = 'Style';
        output out=stepwise_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;
proc print data=stepwise_summary; run;

/*FORWARD*/
Proc Reg data=temp2 outest=forward_summary;
	Title 'Forward';
	model train_response = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2}/ 
        selection = forward AIC VIF BIC MSE groupnames = 'Style';
        output out = forward_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;
proc print data=forward_summary; run;

/*BACKWARD*/
Proc Reg data=temp2 outest=backward_summary;
	Title 'Backward';
	model train_response = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2}/ 
        selection = backward AIC VIF BIC MSE groupnames = 'Style';
        output out = backward_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;
proc print data=backward_summary; run;

/*ADJUSTED R-SQUARED*/
Proc Reg data=temp2 outest=adjrsq_summary;
	Title 'Adjusted R-squared';
	model train_response = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2}/ 
        selection = adjrsq AIC VIF BIC MSE groupnames = 'Style';
        output out = adjrsq_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;

/*R-SQUARED*/
Proc Reg data=temp2 outest=rsquared_summary;
	Title 'R-squared';
	model train_response = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2}/ 
        selection = rsquare AIC VIF BIC MSE groupnames = 'Style';
        output out = rsquared_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;

/*MALLOW'S CP*/
Proc Reg data=temp2 outest=mallowscp_summary;
	Title 'Mallows CP';
	model train_response = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath {Style1 Style2}/ 
        selection = cp AIC VIF BIC MSE groupnames = 'Style';
        output out = mallowscp_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
run;


** task 9;
/*Stepwise*/
data stepwise_out; set stepwise_out;
Title 'Model_S';
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(LogSalePrice-yhat);
square_error = (LogSalePrice-yhat)*(LogSalePrice-yhat); end;


proc means data=stepwise_out nway noprint;
class train;
var square_error absolute_error;
output out=stepwise_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data = stepwise_error; run;

/*Forward*/
data forward_out; set forward_out;
Title 'Model_F';
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(LogSalePrice-yhat);
square_error = (LogSalePrice-yhat)*(LogSalePrice-yhat); end;


proc means data=forward_out nway noprint;
class train;
var square_error absolute_error;
output out = forward_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data = forward_error; run;


/*Backward*/
data backward_out; set backward_out;
Title 'Model_B';
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(LogSalePrice-yhat);
square_error = (LogSalePrice-yhat)*(LogSalePrice-yhat); end;

proc means data=backward_out nway noprint;
class train;
var square_error absolute_error;
output out = backward_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data = backward_error; run;

/*Adjusted-Rsquared*/
data adjrsq_out; set adjrsq_out;
Title 'Model_AdjR2';
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(LogSalePrice-yhat);
square_error = (LogSalePrice-yhat)*(LogSalePrice-yhat); end;

proc means data=adjrsq_out nway noprint;
class train;
var square_error absolute_error;
output out = adjrsq_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data = adjrsq_error; run;

/*R-squared*/
data rsquared_out; set rsquared_out;
Title 'Model_Rsquared';
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(LogSalePrice-yhat);
square_error = (LogSalePrice-yhat)*(LogSalePrice-yhat); end;

proc means data=rsquared_out nway noprint;
class train;
var square_error absolute_error;
output out = rsquared_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data = rsquared_error; run;

/*Mallow's Cp*/
data mallowscp_out; set mallowscp_out;
Title 'Model_Mcp';
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(LogSalePrice-yhat);
square_error = (LogSalePrice-yhat)*(LogSalePrice-yhat); end;

proc means data=mallowscp_out nway noprint;
class train;
var square_error absolute_error;
output out = mallowscp_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data = mallowscp_error; run;


** Task 10  ;
data stepwise_out; set stepwise_out;
Title 'Stepwise model assessment- part 10';
if yhat >= log(SalePrice *0.9) and yhat <= log(SalePrice *1.1) then
	Prediction_Grade="Grade 1";
	else if yhat >= log(SalePrice *0.85) and yhat <= log(SalePrice *1.15) then
	Prediction_Grade="Grade 2";
	else Prediction_Grade="Grade 3";
	
proc sort data=stepwise_out; by train;
Proc freq data=stepwise_out; tables prediction_grade; by train; run;


** task 11; 
** In real life, you will go thru the whole model building process
including outliers, DFFITS, etc. before finalizing the model;
proc reg data=temp;
model LogSalePrice = TotalFlrSF houseage OverallQual
        LotArea BsmtFinSF1 TotalBath Style1 Style2/vif;
title 'Task 11: Reporting Final Model';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;






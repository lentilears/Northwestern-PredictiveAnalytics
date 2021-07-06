%let path=/sscc/home/a/abv902/ecourse;
libname orion "&path";

data ames; set orion.ames_housing;
proc contents; run;

data temp; set ames;
TotalFlrSF = FirstFlrSF + SecondFlrSF; 
houseage = YrSold - YearBuilt;

data temp; set temp; drop FirstFlrSF SecondFlrSF;

data temp; set temp; keep TotalFlrSF GrLivArea houseage Zoning FullBath BedroomAbvGr KitchenQual 
WoodDeckSF BsmtFinSF1 OverallQual CentralAir Alley GarageCars SalePrice Condition1 BldgType 
Electrical Heating Utilities RoofStyle;

/*data temp1; set temp; if _n_ < 10;
proc print; run;*/

** Task 2: Sort the saleprice;

 data temp1; set temp;
 proc sort data=temp1; by descending SalePrice;
   proc print data=temp1 (obs=10);
   
 data temp1; set temp;
 proc sort data=temp1; by SalePrice;
   proc print data=temp1 (obs=10);

** Sort the houseage;

 data temp1; set temp;
 proc sort data=temp1; by descending houseage;
   proc print data=temp1 (obs=10);
   
 data temp1; set temp;
 proc sort data=temp1; by houseage;
   proc print data=temp1 (obs=10);

** Sort the BedroomAbvGr;

 data temp1; set temp;
 proc sort data=temp1; by descending BedroomAbvGr;
   proc print data=temp1 (obs=10);
   
 data temp1; set temp;
 proc sort data=temp1; by BedroomAbvGr;
   proc print data=temp1 (obs=10);   
   
** Task 3 - correlations;
ods graphics on;
proc corr data=temp plot=matrix(histogram nvar=all) plots(maxpoints=NONE); 
run;
ods graphics off;


** Task 4 - scatter plots;   
ods graphics on;
proc sgplot; scatter x= OverallQual y=SalePrice; run;/*highest coefficient*/
proc sgplot; scatter x= BedroomAbvGr y=SalePrice; run;/*lowest coefficient*/
proc sgplot; scatter x= FullBath y=SalePrice; run;/*closest to coefficient=0.5*/
proc sgplot; scatter x= TotalFlrSF y=SalePrice; run;
proc sgplot; scatter x= GrLivArea y=SalePrice; run;
proc sgplot; scatter x= GarageCars y=SalePrice; run;
proc sgplot; scatter x= houseage y=SalePrice; run;
ods graphics off;   

** Task 5 - LOESS; 
ods graphics on;
proc sgscatter data=temp;
compare Y=SalePrice X=OverallQual / loess reg;
run;
proc sgscatter data=temp;
compare Y=SalePrice X=BedroomAbvGr / loess reg;
run;
proc sgscatter data=temp;
compare Y=SalePrice X=FullBath / loess reg;
run;
ods graphics off;

** Task 6 - Analysis of categorical variables;
proc freq; tables KitchenQual BldgType CentralAir; run;

ods graphics on;
proc sgplot; vbar KitchenQual; run;
proc sgplot; vbar BldgType; run;
proc sgplot; vbar CentralAir;
ods graphics off;

** Task 7 - Relating categorical variables with the response;
proc sort data = temp; by KitchenQual;
proc means; var SalePrice; by KitchenQual; run;
proc sort data = temp; by BldgType;
proc means; var SalePrice; by BldgType; run;
proc sort data = temp; by CentralAir;
proc means; var SalePrice; by CentralAir; run;


** Task 8 - General EDA;
proc means; var TotalFlrSF GrLivArea houseage FullBath BedroomAbvGr 
WoodDeckSF BsmtFinSF1 OverallQual GarageCars SalePrice; run;

proc sort data = temp; by BldgType;
proc boxplot data = temp;
  plot SalePrice*BldgType;
run;

proc sort data = temp; by OverallQual;
proc boxplot data = temp;
  plot SalePrice*OverallQual;
run;

proc sort data = temp; by GarageCars;
proc boxplot data = temp;
  plot SalePrice*GarageCars;
run;









      
   


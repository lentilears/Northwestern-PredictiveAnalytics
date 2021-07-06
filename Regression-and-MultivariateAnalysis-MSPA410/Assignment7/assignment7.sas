* Syamala Srinivasan;
* 02.19.2015;
* portfolio_fa.sas;

%let path=/sscc/home/a/abv902/ecourse;
libname orion "&path";

data temp; set orion.stock_portfolio;
proc contents; run;

*** Task 1;
** We are dropping some variables for this analysis;
** We are keeping 4 sectors;
** Banking: BAC, JPM, WFC;
** Oil Field Services: BHI, HAL, SLB;
** Oil Refining: CVX, HES, XOM;
** Industrial: DD, DOW, HUN;
data temp;
	set temp;
	
	* Let's drop some variables to get better factor analysis results;
	drop AA HON MMM DPS KO PEP MPC GS ;
run;

proc print data=temp(obs=10); run; quit;
proc sort data=temp; by date; run; quit;


data temp;
	set temp;

	* Compute the log-returs;
	* Note that the data needs to be sorted in the correct
		direction in order for us to compute the correct return;
	return_BAC = log(BAC/lag1(BAC));
	return_BHI = log(BHI/lag1(BHI));
	return_CVX = log(CVX/lag1(CVX));
	return_DD  = log(DD/lag1(DD));
	return_DOW = log(DOW/lag1(DOW));
	return_HAL = log(HAL/lag1(HAL));
	return_HES = log(HES/lag1(HES));
	return_HUN = log(HUN/lag1(HUN));
	return_JPM = log(JPM/lag1(JPM));
	return_SLB = log(SLB/lag1(SLB));
	return_WFC = log(WFC/lag1(WFC));
	return_XOM = log(XOM/lag1(XOM));
	*return_VV  = log(VV/lag1(VV));
	response_VV = log(VV/lag1(VV));
run;
 
proc print data=temp(obs=10); run; quit;


************************************************************************************;
* Begin Modeling;
************************************************************************************;
* Note that we do not want the response variable in the data used to compute the 
	principal components;

data return_data;
	set temp (keep= return_:); 
	* What happens when I put this keep statement in the set statement?;
	* Look it up in The Little SAS Book;
run;

proc print data=return_data(obs=10); run;

*** Task 2;

************************************************************************************;
* Principal Factor Analysis;
************************************************************************************;
* Perform Factor Analysis;
* Follow the guidelines in the notes;
* How many factors should we keep?;
* Do the factor loadings have any interpretability?  Can we display that interpretability using graphics?;

ods graphics on;
proc factor data=return_data method=principal priors=smc rotate=none
	plots=(all); 
run; quit;
ods graphics off;
* How many factors did SAS retain under the default settings? ;
* Which criterion did SAS use?;
* Maybe we should look in the SAS User's Manual to understand the SAS defaults.;
* By looking at the data, how many factors did you expect to be estimated? Maybe 3/4?;
* Oil Refining / Field Services, Banking, and Industrial-Chemical;
* We appear to have two groups.;
* Group 1: BAC, DD, DOW, HUN, JPM, WFC (Banking and Industrial-Chemical);
* Group 2: BHI, CVX, HAL, HES, SLB, XOM (Oil Refining and Field Services);

* Did we do something wrong?  Why did we not get the 3 or 4 factors that we might
	have preconceived?;
	
	
* How should we interpret the first factor? See Johnson and Wichern - Overall Market Factor;

* Note the scree plot and the variance explained plot.  These can be complete
	gibberish in factor analysis.  We have only two common factors.  When we 
	make these plots for a different number of factors, then we can 'explain'
	more than 100% of the variance, which should be a signal that something is
	wrong.
;

*** Task 3;

ods graphics on;
proc factor data=return_data method=principal priors=smc rotate=varimax
	plots=(all); 
run; quit;
ods graphics off;
* Did this rotation improve the factor analysis?  What does 'improve' mean?;
* Yes, we now have a better interpretability.;
* The rotation appears to move us towards a 'simple structure', although it 
	is not an idealized simple structure.;
* Group 1: BAC, DD, DOW, HUN, JPM, WFC (Banking and Industrial-Chemical);
* Group 2: BHI, CVX, HAL, HES, SLB, XOM (Oil Refining and Field Services);

*** Task 4;

************************************************************************************;
* Maximum Likelihood Factor Analysis;
************************************************************************************;

ods graphics on;
proc factor data=return_data method=ML priors=smc rotate=varimax
	plots=(loadings); 
run; quit;
ods graphics off;

* Do we prefer this output to the PRINCIPAL method with the VARIMAX rotation?;
* How do we interpret the SAS output for the ML factor estimation?;

** Task 5;

************************************************************************************;
* Consider how changing the prior communality estimates affect the factor loadings;
************************************************************************************;

ods graphics on;
proc factor data=return_data method=ML priors=max rotate=varimax
	plots=(loadings); 
run; quit;

* How did the output change?;

proc factor data=return_data method=ML priors=max rotate=varimax
	plots=(loadings) nfactors=4; 
run;


ods graphics off;





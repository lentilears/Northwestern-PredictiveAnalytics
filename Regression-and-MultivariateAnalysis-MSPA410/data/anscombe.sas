/* 	Syamala Srinivasan	
	anscombe.sas
*/
*LIBNAME mydata "/courses/dddaf5e5ba27fe300" access=readonly; 
*%let path=/home/ssvasan77/ecourse;
*libname orion "&path";

libname orion '/sscc/home/a/abv902/ecourse';

data anscombe; set orion.anscombe;
proc contents; run;

*TITLE "PROC CORR Example: Anscombe Quartet";
ods graphics on;
PROC PRINT data=orion.anscombe; RUN; QUIT;


PROC CORR DATA=anscombe PLOT=(matrix);
VAR X1 X2 X3 X4;
WITH Y1 Y2 Y3 Y4;
TITLE2 "X and Y Correlation";
run;
ods graphics off;

DATA long;
set orion.anscombe (keep=x1 y1 rename=(x1=x y1=y) in=a)
orion.anscombe (keep=x2 y2 rename=(x2=x y2=y) in=b)
orion.anscombe (keep=x3 y3 rename=(x3=x y3=y) in=c)
orion.anscombe (keep=x4 y4 rename=(x4=x y4=y) in=d)
;
if (a=1) then anscombe_group=1;
else if (b=1) then anscombe_group=2;
else if (c=1) then anscombe_group=3;
else if (d=1) then anscombe_group=4;
else anscombe_group=0;
RUN;
PROC PRINT data=long; RUN; QUIT;
data long; set long;
Proc sort; by anscombe_group;
proc reg; model y = x; by anscombe_group; 
TITLE 'Regression for the 4 groups';
run;

ods graphics on;
PROC SGPANEL data=long;
PANELBY anscombe_group / COLUMNS=4 ROWS=1;
SCATTER X=x Y=y;
TITLE 'Panel of Scatterplots - rows=1 colums=4';
RUN; QUIT;
ods graphics off;
ods graphics on;
PROC SGPANEL data=long;
PANELBY anscombe_group / COLUMNS=2 ROWS=2;
SCATTER X=x Y=y;
TITLE 'Panel of Scatterplots - rows=2 columns=2';
RUN; QUIT;
ods graphics off;



PROC SGPLOT DATA=anscombe;
scatter X=X1 Y=Y1;
title "X1 and Y1 Scatter Plot – No Smoothers";
run;
PROC SGPLOT DATA=anscombe;
LOESS X=X1 Y=Y1 / NOMARKERS;
REG X=X1 Y=Y1;
title "X1 and Y1 Scatter Plot with LOESS option";
run;
PROC SGSCATTER data=anscombe;
compare X=X1 Y=Y1 / loess reg;
title "X1 and Y1 Scatter with loess and Regression";
run;
PROC SGSCATTER data=anscombe;
plot Y2*X2 / loess reg;
title "X2 and Y2 Scatter with Loess and Regression";
run;
PROC SGSCATTER data=anscombe;
compare Y=Y3 X=X3 / loess reg;
title "X3 and Y3 Scatter with Loess and Regression";
run;
PROC SGSCATTER data=anscombe;
compare Y=Y4 X=X4 / loess reg;
title "X4 and Y4 Scatter with Loess and Regression";
run;
title "Anscombe Data"; run;
*ods graphics off;
proc reg data=anscombe; model y1 = x1; 
output out=out1 pred=yhat residual=resid 
ucl=ucl lcl=lcl;
run;

proc reg data=anscombe; model y2 = x2; 
output out=out2 pred=yhat residual=resid 
ucl=ucl lcl=lcl;
run;

proc reg data=anscombe; model y3 = x3; 
output out=out3 pred=yhat residual=resid 
ucl=ucl lcl=lcl;
run;

proc reg data=anscombe; model y4 = x4; 
output out=out4 pred=yhat residual=resid 
ucl=ucl lcl=lcl;
run;











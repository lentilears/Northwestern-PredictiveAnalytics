
%let path=/sscc/home/a/abv902/ecourse;
libname orion "&path";

data temp; set orion.european_employment;
proc contents; run;
proc print; run;

/*Part 1*/
* Produce the scatterplot matrix;
ods graphics on;
title Correlation Structure of the Raw Data;
proc corr data=temp plot=matrix(histogram nvar=all); 
run; quit;
title ;
ods graphics off;

ods graphics on;
proc sgplot data=temp;
title 'Scatterplot of Raw Data: FIN*SER';
scatter y=fin x=ser / datalabel=country group=group; run; quit;


proc sgplot data=temp;
title 'Scatterplot of Raw Data: MAN*SER';
scatter y=man x=ser / datalabel=country group=group; run; quit;
ods graphics off;

/*Part 2*/
ods graphics on;
title Principal Components Analysis using PROC PRINCOMP;
proc princomp data=temp out=pca_9components outstat=eigenvectors plots=all; run;
ods graphics off;


/*Part 3*/
title '';
ods graphics on;
proc cluster data=temp method=average outtree=tree1 pseudo ccc plots=all; var fin ser;
id country; run; quit;

ods graphics off;


ods graphics on;
proc tree data=tree1 ncl=5 out=_5_clusters; copy fin ser;
run; quit;
proc print data=_5_clusters; run;
ods graphics off;
ods graphics on;
proc tree data=tree1 ncl=4 out=_4_clusters; copy fin ser;
run; quit;
ods graphics off;
ods graphics on;
proc tree data=tree1 ncl=3 out=_3_clusters; copy fin ser;
run; quit;
ods graphics off;

%macro makeTable(treeout,group,outdata); data tree_data;
set &treeout.(rename=(_name_=country));
run;
proc sort data=tree_data; by country; run; quit; data group_affiliation;
set &group.(keep=group country);
run;
proc sort data=group_affiliation; by country; run; quit; data &outdata.;
merge tree_data group_affiliation; by country;
run;
proc freq data=&outdata.;
table group*clusname / nopercent norow nocol; run;
%mend makeTable;

* Call macro function;
%makeTable(treeout=_3_clusters,group=temp,outdata=_3_clusters_with_labels);
* Plot the clusters for a visual display; ods graphics on;
proc sgplot data=_3_clusters_with_labels;
title 'Scatterplot of Raw Data';
scatter y=fin x=ser / datalabel=country group=clusname; run; quit;
ods graphics off;
%makeTable(treeout=_4_clusters,group=temp,outdata=_4_clusters_with_labels);
* Plot the clusters for a visual display; ods graphics on;
proc sgplot data=_4_clusters_with_labels;
title 'Scatterplot of Raw Data';
scatter y=fin x=ser / datalabel=country group=clusname; run; quit;
ods graphics off;
%makeTable(treeout=_5_clusters,group=temp,outdata=_5_clusters_with_labels);
* Plot the clusters for a visual display; ods graphics on;
proc sgplot data=_5_clusters_with_labels;
title 'Scatterplot of Raw Data';
scatter y=fin x=ser / datalabel=country group=clusname; run;


*****************************************************************;
* Using the first 2 principal components;
*****************************************************************; ods graphics on;
proc cluster data=pca_9components method=average outtree=tree3 pseudo ccc plots=all;
var prin1 prin2; id country;
run; quit;
ods graphics off;
ods graphics on;
proc tree data=tree3 ncl=6 out=_6_clusters; copy prin1 prin2;
run; quit;
proc tree data=tree3 ncl=5 out=_5_clusters; copy prin1 prin2;
run; quit;
proc tree data=tree3 ncl=4 out=_4_clusters; copy prin1 prin2;
run; quit;
proc tree data=tree3 ncl=3 out=_3_clusters; copy prin1 prin2;
run; quit;
ods graphics off;
%makeTable(treeout=_3_clusters,group=temp,outdata=_3_clusters_with_labels);
%makeTable(treeout=_4_clusters,group=temp,outdata=_4_clusters_with_labels);
%makeTable(treeout=_5_clusters,group=temp,outdata=_5_clusters_with_labels);
%makeTable(treeout=_6_clusters,group=temp,outdata=_6_clusters_with_labels);
* Plot the clusters for a visual display; ods graphics on;

proc sgplot data=_3_clusters_with_labels;
title 'Scatterplot of Raw Data';
scatter y=prin2 x=prin1 / datalabel=country group=clusname; run; quit;
ods graphics off;
* Plot the clusters for a visual display; ods graphics on;
proc sgplot data=_4_clusters_with_labels;
title 'Scatterplot of Raw Data';
scatter y=prin2 x=prin1 / datalabel=country group=clusname; run; quit;
ods graphics off;
* Plot the clusters for a visual display; ods graphics on;
proc sgplot data=_5_clusters_with_labels;
title 'Scatterplot of Raw Data';
scatter y=prin2 x=prin1 / datalabel=country group=clusname; run; quit;
proc sgplot data=_6_clusters_with_labels;
title 'Scatterplot of Raw Data';
scatter y=prin2 x=prin1 / datalabel=country group=clusname; run; quit;












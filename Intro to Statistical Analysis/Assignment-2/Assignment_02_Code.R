# Assignment 2 401-DL-58
# read the comma-delimited text file creating a data frame object in R
require(moments)
require(ggplot2)
require(rockchalk)

mydata <- read.csv("mydata.csv", sep="")
head(mydata)
tail(mydata)
str(mydata)
summary(mydata) 
plot(mydata[,2:8])#review which correlations are linear (Pearson) and which are not (Spearman)

#Q1 Correlations
#Pearson Correlation Coefficients
cor(mydata[,2],mydata[,3], method = "pearson")# LENGTH v DIAM
cor(mydata[,2],mydata[,4], method = "pearson")# LENGTH v HEIGHT
cor(mydata[,3],mydata[,4], method = "pearson")# DIAM v HEIGHT
cor(mydata[,5],mydata[,6], method = "pearson")# WHOLE v SHUCK
cor(mydata[,5],mydata[,7], method = "pearson")# WHOLE v VISCERA
cor(mydata[,5],mydata[,8], method = "pearson")# WHOLE v SHELL
cor(mydata[,6],mydata[,7], method = "pearson")# SHUCK v VISCERA
cor(mydata[,6],mydata[,8], method = "pearson")# SHUCK v SHELL
cor(mydata[,7],mydata[,8], method = "pearson")# VISCERA v SHELL

#Spearman Correlation Coefficients
cor(mydata[,2],mydata[,5], method = "spearman")# LENGTH v WHOLE
cor(mydata[,2],mydata[,6], method = "spearman")# LENGTH v SHUCK
cor(mydata[,2],mydata[,7], method = "spearman")# LENGTH v VISCERA
cor(mydata[,2],mydata[,8], method = "spearman")# LENGTH v SHELL
cor(mydata[,3],mydata[,5], method = "spearman")# DIAM v WHOLE
cor(mydata[,3],mydata[,6], method = "spearman")# DIAM v SHUCK
cor(mydata[,3],mydata[,7], method = "spearman")# DIAM v VISCERA
cor(mydata[,3],mydata[,8], method = "spearman")# DIAM v SHELL
cor(mydata[,4],mydata[,5], method = "spearman")# HEIGHT v WHOLE
cor(mydata[,4],mydata[,6], method = "spearman")# HEIGHT v SHUCK
cor(mydata[,4],mydata[,7], method = "spearman")# HEIGHT v VISCERA
cor(mydata[,4],mydata[,8], method = "spearman")# HEIGHT v SHELL

#Q2 Boxplots: analyze SHUCK differentiated by CLASS and SEX
females <- subset(mydata, subset = (SEX =="F"))
infants <- subset(mydata, subset = (SEX =="I"))
males <- subset(mydata, subset = (SEX =="M")) 
#Create 3 x 1 matrix of 18 boxplots
par(mfrow = c(1,1))
boxplot(SHUCK~CLASS, data = females, col = "grey", main = "Female SHUCK", ylab = "SHUCK", ylim = c(0,1.3))
boxplot(SHUCK~CLASS, data = infants, col = "grey", main = "Infant SHUCK", ylab = "SHUCK", ylim = c(0,0.6))
boxplot(SHUCK~CLASS, data = males, col = "grey", main = "Male SHUCK", ylab = "SHUCK", ylim = c(0,1.2))
par(mfrow = c(1,1))     

#Q3 Pearson chi square statistic
shuck <- factor(mydata$SHUCK > median(mydata$SHUCK), labels=c("below","above"))
volume <- factor(mydata$VOLUME > median(mydata$VOLUME), labels=c("below","above"))
shuck_volume <- addmargins(table(shuck,volume))

#function which calculates chi-squared value given a 2x2 matrix with marginals
matrix <- function(x){
  e11 <- x[3,1]*x[1,3]/x[3,3]
  e12 <- x[3,2]*x[1,3]/x[3,3]
  e21 <- x[3,1]*x[2,3]/x[3,3]
  e22 <- x[3,2]*x[2,3]/x[3,3]
}
q <- matrix(shuck_volume)# q=124.5 (chi-squared statistic)
pchisq(q,1,lower.tail=FALSE)# p-value: p=6.547914e-29 (reject null hypothesis)

#Q4 Analysis of variance

aov.shuck <- aov(SHUCK~CLASS+SEX+CLASS*SEX, mydata)#with interaction CLASS*SEX
summary(aov.shuck)

aov.shuckmodel <- aov(SHUCK~CLASS+SEX, mydata)#without interaction CLASS*SEX
summary(aov.shuckmodel)

# Statistically significant F-test results.  Perform TukeyHSD.
TukeyHSD(aov.shuckmodel)

#Q5 ggplots of SHUCK versus VOLUME and their respective log plots
require(ggplot2)
library(gridExtra)

#create LSHUCK and LVOLUME as category variables of SHUCK and VOLUME, respectively and add to mydata
LSHUCK <- log(mydata[,6])#calculate ln(shuck)
LVOLUME <- log(mydata[,11])#calculate ln(volume)
mydata <- data.frame(mydata, LSHUCK, LVOLUME)#added LSHUCK and LVOLUME to mydata for convenience
str(mydata)#check LSHUCK/LVOLUME was added to mydata

grid.arrange(ggplot(data = mydata, aes(x = VOLUME, y = SHUCK)) + geom_point(aes(color = CLASS),size = 2) + ggtitle("Shuck versus Volume by Class"), 
             ggplot(data = mydata, aes(x = LVOLUME, y = LSHUCK)) + geom_point(aes(color = CLASS),size = 2) + ggtitle("LogShuck versus LogVolume by Class"), nrow = 1)


#Q6 Linear regression
model <- lm(LSHUCK~LVOLUME+CLASS+SEX, mydata)
summary(model)

#Q7 Analysis of residuals

r <- residuals(model)
fitt <- fitted(result)

par(mfrow = c(1,1))
hist(r, col = "red", main = "Histogram of Residuals", xlab = "Residual")
par(mfrow = c(1,1))

qqnorm(r, col = "red", pch = 20, main = "QQ Plot of Residuals")
qqline(r, col = "blue", lty = 2, lwd = 2)

skewness(r)
kurtosis(r)

#ggplot: Create an out regression object
out <- data.frame(mydata$LVOLUME,mydata$CLASS,mydata$SEX)
out <- data.frame(out,r)
colnames(out) <- c("LVOLUME","CLASS","SEX","RESIDUAL")
head(out)
ggplot(out, aes(x = LVOLUME, y = RESIDUAL)) + geom_point(aes(color = CLASS)) + labs(x = "LVOLUME", y = "Residuals")

ggplot(out, aes(x = SEX, y = RESIDUAL, fill = SEX)) + ggtitle("Residuals versus SEX") +
  geom_boxplot(aes(fill = factor(SEX))) + scale_fill_manual(values = c("red", "green", "blue"))

ggplot(out, aes(x = CLASS, y = RESIDUAL, fill = CLASS)) + ggtitle("Residuals versus CLASS") +
  geom_boxplot(aes(fill = factor(CLASS))) + scale_fill_manual(values = c("cadetblue", "blue4", "darkred", "green", "blue", "red"))


#ggplot of residuals vs LVOLUME. Color data points by CLASS.
ggplot(out, aes(x = LVOLUME,y = RESIDUAL)) + geom_point(aes(color = CLASS)) +
  labs(x = "LVOLUME", y = "Residuals") + 
  theme(legend.direction = "vertical", legend.position = "right") + ggtitle("Residuals versus LVOLUME by CLASS")

#Color data points by SEX
ggplot(out, aes(x = LVOLUME,y = model$residuals)) + geom_point(aes(color = SEX)) +
  labs(x = "LVOLUME", y = "Residuals") +
  theme(legend.direction = "vertical", legend.position = "right") + ggtitle("Residuals versus LVOLUME by SEX")


#Q8
idxi <- mydata[,1]=="I"
idxa <- mydata[,1]!="I"
max.v <- max(mydata$VOLUME) 
min.v <- min(mydata$VOLUME) 
delta <- (max.v - min.v)/100 
prop.infants <- numeric(0)
prop.adults <- numeric(0)
volume.value <- numeric(0)
total <- length(mydata[idxi,1]) # This value must be changed for adults.
totala <- length(mydata[idxa,1]) # Value changed for adults.

for (k in 1:100) {
  value <- min.v + k*delta
  volume.value[k] <- value
  prop.infants[k] <- sum(mydata$VOLUME[idxi] <= value)/total
  prop.adults[k] <- sum(mydata$VOLUME[idxa] <= value)/totala
}

#Plot infants
n.infants <- sum(prop.infants <= 0.5)
split.infants <- min.v + (n.infants + 0.5)*delta # This estimates the desired volume.
plot(volume.value, prop.infants, col = "green", main = "Proportion of Infants Not Harvested", xlab="VOLUME", ylab="Proportion of Infants", type = "l", lwd = 2) 
abline(h=0.5)
abline(v = split.infants)

#Plot adults
n.adults <- sum(prop.adults <= 0.5)
split.adults <- min.v + (n.adults + 0.5)*delta # This estimates the desired volume.
plot(volume.value, prop.adults, col = "green", main = "Proportion of Adults Not Harvested", xlab="VOLUME", ylab="Proportion of Adults", type = "l", lwd = 2) 
abline(h=0.5)
abline(v = split.adults)

#split value (infants) = 0.01642322 volume @ 50% popn infants
#split value (adults) = 0.03958566 volume @ 50% popn adults

#Q9 Part A

prop.infants <- numeric(0)
prop.adults <- numeric(0)
volume.value <- numeric(0)

total.infants <- length(mydata[idxi,1])  # This value must be changed if adults are being considered.
total.adults <- length(mydata[idxf,1])+length(mydata[idxm,1]) 

for (k in 1:100) {
  value <- min.v + k*delta
  volume.value[k] <- value
  prop.infants[k] <- sum(mydata$VOLUME[idxi] <= value)/total.infants
  prop.adults[k] <- (sum(mydata$VOLUME[idxf] <= value)+sum(mydata$VOLUME[idxm] <= value))/total.adults
}

difference <- (1-prop.infants)-(1-prop.adults) #

#plot (1) 1-prop.adults vs volume.value
ggplot(mydata, aes(x = volume.value)) + ggtitle("Adult Harvest Proportions") +
  geom_line(aes(y = (prop.adults), color = "prop.adults"), size = 1.1) + 
  geom_line(aes(y = (1 - prop.adults), color = "1 - prop.adults"), size = 1.1) + 
  geom_hline(yintercept=0.5, linetype="dotted") +
  geom_vline(xintercept=split.adults, linetype="dotted") +
  theme(legend.title=element_blank()) + 
  ylab("Proportion Harvested")

#plot (2) 1-prop.infants vs volume.value
ggplot(mydata, aes(x = volume.value)) + ggtitle("Infant Harvest Proportions") +
  geom_line(aes(y = (prop.infants), color = "prop.infants"), size = 1.1) +  
  geom_line(aes(y = (1 - prop.infants), color = "1 - prop.infants"), size = 1.1) +
  geom_hline(yintercept=0.5, linetype="dotted") +
  geom_vline(xintercept=split.infants, linetype="dotted") +
  theme(legend.title=element_blank()) +
  ylab("Proportion Harvested")

#plot (2) difference (prop.infants-prop.adults) vs volume.value
ggplot(mydata, aes(x = volume.value)) + ggtitle("Difference in Harvest Proportions") +
  geom_line(aes(y = (difference), color = "Difference"), size = 1.1) + 
  theme(legend.title=element_blank()) +
  ylab("Difference Between Infants and Adults Harvested")

#Q9 Part B ROC curve: 1-prop.adults vs 1-prop.infants
plot(1-prop.infants,1-prop.adults, col = "blue", lwd = 2, type = "l",
     main = "ROC curve of adult and infant harvest proportions", ylab = "Adult harvest proportion",
     xlab = "Infant harvest proportion")
abline(a=0, b=1, col = "maroon", lty = 2, lwd = 2)

#Identify the largest infant
max(mydata$VOLUME[mydata$SEX == "I"]) # [1] 0.0485
#smallest volume.value that corresponds to a harvest of zero infants
min(volume.value[(1 - prop.infants) == 0]) # 0.04915275, value can be passed to the ROC curve
which.max(1 - prop.infants == 0) # The 48th element in (1 - prop.infants) is the first zero
#add cross-hairs into plot
abline(h=0.47, lty =2)# value of y-xis intercept with x=0.04915275 
abline(h=0.3256484, lty =2)# 
abline(v = 0.04915275, lty = 2)
#Proportion of adults harvested at the volume.value threshold (zero infants harvested)
(1 - prop.adults)[48] # 0.3256484

#Q10 Minimizing harvesting of age-classes A1 and A2
cutoff <- 0.035 # this cutoff value works.
index.A1 <- (mydata$CLASS=="A1")
indexi <- index.A1 & idxi
sum(mydata[indexi,11] >= cutoff)/sum(index.A1)# [1] 0
index.A2 <- (mydata$CLASS=="A2")
indexi <- index.A2 & idxi
sum(mydata[indexi,11] >= cutoff)/sum(index.A2)# [1] 0
index.A3 <- (mydata[,10]=="A3")
indexi <- index.A3 & idxi
sum(mydata[indexi,11] >= cutoff)/sum(index.A3)# [1] 0.04545455
index.A4 <- (mydata[,10]=="A4")
indexi <- index.A4 & idxi
sum(mydata[indexi,11] >= cutoff)/sum(index.A4)# [1] 0.03296703
index.A5 <- (mydata[,10]=="A5")
indexi <- index.A5 & idxi
sum(mydata[indexi,11] >= cutoff)/sum(index.A5)# [1] 0.02857143
index.A6 <- (mydata[,10]=="A6")
indexi <- index.A6 & idxi
sum(mydata[indexi,11] >= cutoff)/sum(index.A6)# [1] 0.05714286











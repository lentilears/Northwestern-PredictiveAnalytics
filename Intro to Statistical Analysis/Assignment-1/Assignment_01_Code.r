# Assignment 1 401-DL-58
# read the comma-delimited text file creating a data frame object in R
# create the data frame
require(moments)
require(ggplot2)
#1) Read in abalone.csv file
abalone <- read.csv("abalone2.csv", sep="")
# examine the structure of the data frame
str(abalone)
# look at the first few records of the data frame
head(abalone)
# look at the last few records of the data frame
tail(abalone)
# look at descriptive statistics 
summary(abalone)

#Q1(a) and (b) Use sample() and read and write data 
set.seed(123)
mydata <- abalone[sample(1:4141, 500),]
head(mydata)
write.csv(mydata, file="mydata.csv")
mydata <- read.csv("mydata.csv", sep=",")

#Q2 Check mydata using str() and use plot matrix of variables
head(mydata)
tail(mydata)
str(mydata)
summary(mydata) 
plot(mydata[,1:8])

#Q3 Determine the proportion of infant, female and male abalone in mydata
p_infants <- sum(abalone[,1] == "I")/length(abalone[,1]) # proportion of infants in abalone data
p_infants
p_females <- sum(abalone[,1] == "F")/length(abalone[,1]) # proportion of females in abalone data
p_females
p_males <- sum(abalone[,1] == "M")/length(abalone[,1]) # proportion of males in abalone data
p_males

p_infants+p_females+p_males#check proportion equals 1

p_infants2 <- sum(mydata[,1] == "I")/length(mydata[,1]) # proportion of infants in the sample mydata
p_infants2
p_females2 <- sum(mydata[,1] == "F")/length(mydata[,1]) # proportion of females in the sample mydata
p_females2
p_males2 <- sum(mydata[,1] == "M")/length(mydata[,1]) # proportion of males in the sample mydata
p_males2
p_infants2+p_females2+p_males2#check proportion equals 1

#perform proportion test
prop.test(sum(mydata[,1]=="I"), nrow(mydata), p = p_infants, conf.level = 0.95, correct = FALSE)
prop.test(sum(mydata[,1]=="F"), nrow(mydata), p = p_females, conf.level = 0.95, correct = FALSE)
prop.test(sum(mydata[,1]=="M"), nrow(mydata), p = p_males, conf.level = 0.95, correct = FALSE)

#Q4) Create VOLUME variable by multiplying LENGTH*DIAM*HEIGHT (I limited result to 4 places of decimal)
VOLUME <- (mydata[,2]*mydata[,3]*mydata[,4])
length(VOLUME)
mydata <- data.frame(mydata, VOLUME)
str(mydata)#check VOLUME was added to mydata

#plot WHOLE versus VOLUME
plot(mydata[,5], mydata[,11], ann=FALSE)
title(main="Whole weight abalone versus Volume of abalone", xlab="WHOLE WEGHT ABALONE (grams)", ylab="VOLUME OF ABALONE (cubic mm)")
abline(v=1.4, col="blue"); abline(h=0.06, col="blue")#produces x and y blue lines

#Q5) Create a new variable DENSITY by dividing WHOLE by VOLUME
DENSITY <- mydata[,5]/mydata[,11]
mydata <- data.frame(mydata, DENSITY)

#Create 3 x 3 matrix of nine boxplots
par(mfrow = c(3,3))
boxplot(mydata[mydata[,1]=="F", 11], col = "red", main = "Female Volume", ylab="Frequency", ylim = c(0,0.1) )
boxplot(mydata[mydata[,1]=="I", 11], col = "green", main = "Infant Volume", ylim = c(0,0.1))
boxplot(mydata[mydata[,1]=="M", 11], col = "blue", main = "Male Volume", ylim = c(0,0.1))
boxplot(mydata[mydata[,1]=="F", 5], col = "red", main = "Female Whole wt.", ylab="Frequency", ylim = c(0,2.6) )
boxplot(mydata[mydata[,1]=="I", 5], col = "green", main = "Infant Whole wt.", ylim = c(0,2.6))
boxplot(mydata[mydata[,1]=="M", 5], col = "blue", main = "Male Whole wt.", ylim = c(0,2.6))
boxplot(mydata[mydata[,1]=="F", 12], col = "red", main = "Female Density", ylab="Frequency", ylim = c(0,60.0) )
boxplot(mydata[mydata[,1]=="I", 12], col = "green", main = "Infant Density", ylim = c(0,60.0))
boxplot(mydata[mydata[,1]=="M", 12], col = "blue", main = "Male Density", ylim = c(0,60.0))
par(mfrow = c(1,1))

#Q6 Present a matrix of Q-Q plots for density differentiated by sex
par(mfrow = c(1,3))
qqnorm(mydata[mydata[,1]=="F",12], ylab = "Sample Quantiles of Density", main = "Q-Q Plot of Density for Females", col = "red")
qqline(mydata[mydata[,1]=="F",12], col = "green")

qqnorm(mydata[mydata[,1]=="I",12], ylab = "Sample Quantiles of Density", main = "Q-Q Plot of Density for Infants", col = "red")
qqline(mydata[mydata[,1]=="I",12], col = "green")

qqnorm(mydata[mydata[,1]=="M",12], ylab = "Sample Quantiles of Density", main = "Q-Q Plot of Density for Males", col = "red")
qqline(mydata[mydata[,1]=="M",12], col = "green")
par(mfrow = c(1,1))

#Q7 Investigate VOLUME, WHOLE, DENSITY against RINGS differentiated by SEX using ggplot
require(ggplot2)
library(gridExtra)

grid.arrange(ggplot(data = mydata, aes(x = RINGS, y = VOLUME)) + geom_point(aes(color = SEX),size = 2) + ggtitle("Rings versus Volume by Sex"),
  ggplot(data = mydata, aes(x = RINGS, y = WHOLE)) + geom_point(aes(color = SEX),size = 2) + ggtitle("Rings versus Whole wt by Sex"),
  ggplot(data = mydata, aes(x = RINGS, y = DENSITY)) + geom_point(aes(color = SEX),size = 2) + ggtitle("Rings versus Density by Sex"), nrow = 1)

#Q8
# Plot of count per SEX, by CLASS
x <- table(mydata$SEX, mydata$CLASS)
x
out <- as.data.frame(x)
out
colnames(out) <- c("Sex", "Class", "Count")
ggplot(data=out ,aes(x=Class, y=Count, group=Sex, colour = Sex))+geom_line()+geom_point(size=4)+ ggtitle("Sample Counts of Different Sexes versus Class")

#calculation of proportions
# Create a data frame of the SEX-CLASS table
out <- data.frame(table(mydata$SEX, mydata$CLASS))
out
# Use aggregate() to define "y" - a data frame to determine the CLASS totals
y <- aggregate(out$Freq, by=list(x$Var2), FUN = sum)
y

# Appends "proportion" to "out" - equal to the proportion of SEX-CLASS
# member per total CLASS membership:
out$proportion <- out$Freq / y[match(out$Var2, y$Group.1), "x"]
out
colnames(out) <- c("Sex", "Class", "Freq", "Proportion")
out
ggplot(data=out ,aes(x=Class, y=Proportion, group=Sex, colour = Sex))+geom_line()+geom_point(size=4)+ ggtitle("Proportion of Different Sexes versus Class")


#Q9 Analyze Volume and Whole differentiated by Class using ggplot 
library(gridExtra)
# Volume versus Class
ggplot(mydata, aes(x = CLASS, y = VOLUME, fill = CLASS)) +
  geom_boxplot(aes(fill = factor(CLASS))) +
  scale_fill_manual(values = c("cadetblue", "blue4", "darkred", "green", "blue", "red"))

# Whole versus Class
ggplot(mydata, aes(x = CLASS, y = WHOLE, fill = CLASS)) +
  geom_boxplot(aes(fill = factor(CLASS))) +
  scale_fill_manual(values = c("cadetblue", "blue4", "darkred", "green", "blue", "red"))


#Q10a ggplot of WHOLE for each combination of SEX and age CLASS
out <- aggregate(WHOLE~SEX+CLASS, data=mydata,mean) 
ggplot(data=out ,aes(x=CLASS, y=WHOLE, group=SEX, colour = SEX))+geom_line()+geom_point(size=4)+
  ggtitle("Mean Whole weights versus Age Class for Three Sexes")

#Q10b ggplot of DENSITY for each combination of SEX and age CLASS
out <- aggregate(DENSITY~SEX+CLASS, data=mydata,mean) 
ggplot(data=out ,aes(x=CLASS, y=DENSITY, group=SEX, colour = SEX))+geom_line()+geom_point(size=4)+
  ggtitle("Mean Densities versus Age Class for Three Sexes")


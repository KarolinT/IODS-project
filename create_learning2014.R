#Karolin Toompere, 06.11.2020
#Data wrangling week 2

#1
#2 Read the full learning2014 data

  lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
  
  str(lrn14)
  dim(lrn14)

  #183 observations and 60 variables. integer variables, except
  #gender that is factor "F", "M"

#3 Create an analysis dataset with the variables gender, age,
# attitude, deep, stra, surf and points by combining questions
#in the learning2014 data, 
  lrn14$attitude <- lrn14$Attitude/10
  
  #scale all combination variables to original scales
  deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
  surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
  strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
  
  library(dplyr)
  deep_columns <- select(lrn14, one_of(deep_questions))
  lrn14$deep <- rowMeans(deep_columns)
  
  surface_columns <- select(lrn14, one_of(surface_questions))
  lrn14$surf <- rowMeans(surface_columns)
  
  strategic_columns <- select(lrn14, one_of(strategic_questions))
  lrn14$stra <- rowMeans(strategic_columns)
  
  #keep only necessary variables
  keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
  learning2014 <- select(lrn14, one_of(keep_columns))
  
  #change names to lowercase
  colnames(learning2014)[2] <- "age"
   colnames(learning2014)[7] <- "points"
 
  #keep only if points >0
  learning2014 <- filter(learning2014, points>0)
  
  dim(learning2014)
  #166 obs, 7 var
  
#4  Save the analysis dataset to the ???dataÿ folder, 
    #using for example write.csv() or write.table() functions.
  
  ?write.csv
  write.table(learning2014, file = "learning2014.csv", row.names = TRUE, sep=";")
  
  #demonstrate that you can also read the data again
  demonstrate=read.table("learning2014.csv", header= TRUE, sep=";")
  
  dim(demonstrate)
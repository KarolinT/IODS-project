#Karolin Toompere, 12.11.2020
#Data wrangling week 3

#Data:
#P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.
#The data are from two identical questionaires related 
#to secondary school student alcohol comsumption in 
#Portugal

#Some students have answered both, but no id is available
#use list of variables to identify 
library(dplyr)
setwd("Z:/IODS-project/data")

student_mat <- read.table("student-mat.csv", sep=";", header=TRUE)
student_por <- read.table("student-por.csv", sep=";", header=TRUE)

str(student_mat)
dim(student_mat)

str(student_por)
dim(student_por)


join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")


#inner_join()
#return all rows from x where there are matching values 
#in y, and all columns from x and y. 
#If there are multiple matches between x and y, 
#all combination of the matches are returned.

math_por <- inner_join(student_mat, student_por, by = join_by, suffix=c(".math", ".por"))
dim(math_por)
glimpse(math_por)

#Choose or rename variables from a tbl. 
#select() keeps only the variables you mention;
#rename() keeps all variables.

alc <- select(math_por, one_of(join_by))
glimpse(alc)
dim(alc)

notjoined_columns <- colnames(student_mat)[!colnames(student_mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

#mutate changes the dataset alc. Create average of Dalc and Walc
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

# glimpse at the new combined data
dim(alc)

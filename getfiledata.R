#====================
# function to read a CSV file and return a dataframe
# input: name of a CSV file. 
#   File has named columns for; 
#   1) Total number of observations ('all)
#   2) date of observation on month/day format: mm/dd
#   3) total positives so far
#   4) total fatalities so far
#   other columns dropped.
# returns: dataframe with observations
getFile<-function(fname)
{
  df<-read.csv(fname,stringsAsFactors=F) # need factors as strings
  cols<-length(colnames(df))
  if (cols != 8){ #side-effects. eesh. sorry
    flog.warn(paste("csv file doesn't have 8 columns:", fname,"column count:",cols, "col names:",colnames(df)))
    return()
  }
  #df<- within(df,rm("Daily_fatalities","positive","positive_percent","mortality_rate"))
  alltests<-as.integer(df$All_tests) #total tests to date
  df$All_tests<-alltests #not sure why only this is a string?
  df$Pos_today<-as.integer(df$Pos_today )
  df$test_increase<-as.integer(df$test_increase) #this day's test
  #reformat Date factor as Date string
  df$Date<-as.Date(df$Date,"%Y-%m-%d")
  head(df,10)
  return (df)
}

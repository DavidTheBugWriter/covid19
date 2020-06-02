  # https://www.datacamp.com/community/tutorials/r-web-scraping-rvest
  library('xml2')
  library('rvest')
  library('stringr')
  

  scrape<-function()
    {
      govurl<-'https://gov.uk/guidance/coronavirus-covid-19-information-for-the-public'
      
      #try a non-greedy match as only want date from string
      #pat_alldate<-"^As of 9am (on)* (.*?),.*"
      pat_alldate<-"^As of (9am|9 am) (on )*(.*?), .*"
      pat_dieddate<-"^As of 5pm on (.*?), .* tested positive .*? ([0-9,]+) .*."
      
      covid_data_html <- read_html(govurl) #turn page to xml
      covid_xml<-html_nodes(covid_data_html, '#number-of-cases-and-deaths') 
      
      all_tests_raw_text<-html_text(xml_siblings(covid_xml)[2])
      deaths_raw_text<-html_text(xml_siblings(covid_xml)[4])
      
      all_text<-str_match(all_tests_raw_text,pat_alldate)
      death_text<-str_match(deaths_raw_text,pat_dieddate)
      
      #grab table
      table_raw<-xml_siblings(covid_xml)[5]
      table<- table_raw %>% html_table
      
      alltests<- table[[1]]$X2[3] #total tests to this date
      teststoday<-table[[1]]$X2[2] #tests done on one day
      pos_tests<-table[[1]]$X4[3] #total virus positives to this date
      positivetoday<-table[[1]]$X4[2]
      death<- table[[1]]$X5[3]
      
      dater<-all_text[4]
      # sanity check
      if (NA %in% dater){
      flog.error("scraper failed with one or more NA terms in 'all_text', please check")
        return(NA)
      }
      
      scraped<-data.frame(
        report_date=as.Date(dater,"%d %B"),
        alltests=as.integer(gsub(",","",alltests)),
        teststoday=as.integer(gsub(",","",teststoday)),
        pos_tested=as.integer(gsub(",","",pos_tests)),
        pos_today=as.integer(gsub(",","",positivetoday)),
        died_date=as.Date(death_text[2],"%d %B"),
        died=as.integer(gsub(",","",death))
      )
      return(scraped)
    }
  
  scr<-scrape()
  scr
  
  
  # https://www.datacamp.com/community/tutorials/r-web-scraping-rvest
  library('xml2')
  library('rvest')
  library('stringr')
  

  scrape<-function()
    {
      govurl<-'https://gov.uk/guidance/coronavirus-covid-19-information-for-the-public'
      
      #try a non-greedy match as only want date from string
      pat_alldate<-"^As of 9am (.*?),.*"
      
      pat_dieddate<-"^As of 5pm on (.*?), .* tested positive .*? ([0-9,]+) .*."
      
      covid_data_html <- read_html(govurl) #turn page to xml
      covid_xml<-html_nodes(covid_data_html, '#number-of-cases-and-deaths') 
      
      all_tests_raw_text<-html_text(xml_siblings(covid_xml)[3])
      deaths_raw_text<-html_text(xml_siblings(covid_xml)[5])
      
      all_text<-str_match(all_tests_raw_text,pat_alldate)
      death_text<-str_match(deaths_raw_text,pat_dieddate)
      
      #grab table
      table_raw<-xml_siblings(covid_xml)[6]
      table<- table_raw %>% html_table
      
      tests<- table[[1]]$X2
      ppl_tested<- table[[1]]$X3
      pos_tests<-table[[1]]$X4
      death<-tests<- table[[1]]$X5
      
      # sanity check
      if (NA %in% all_text){
      flog.error("scraper failed with one or more NA terms in 'All_text', please check")
        return(NA)
      }
      
      scrape<-data.frame(
        report_date=as.Date(all_text[2],"%d %B"),
        tested=gsub(",","",gsub(",","",ppl_tested[3])),
        daily_tests=as.integer(gsub(",","",ppl_tested[2])),
        pos_tested=as.integer(gsub(",","",pos_tests[3])),
        died_date=as.Date(death_text[2],"%d %B"),
        died=as.integer(gsub(",","",death[3]))
      )
      return(scrape)
    }
  
  scr<-scrape()
  scr
  
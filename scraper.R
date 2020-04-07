  # https://www.datacamp.com/community/tutorials/r-web-scraping-rvest
  library('xml2')
  library('rvest')
  library('stringr')

  rm(scr)
  
    scrape<-function()
    {
      govurl<-'https://gov.uk/guidance/coronavirus-covid-19-information-for-the-public'
      
      pat_all<-"^As of 9am on (.*), ([0-9,]+) .* with ([0-9,]+) .* on (.*). Some"
      pat_pos<-"^([0-9,]+) people .* of whom ([0-9,]+) tested positive."
      pat_died<-"^As of 5pm on (.*), .* coronavirus, ([0-9,]+) have died."
      
      covid_data_html <- read_html(govurl) #turn page to xml
      covid_xml<-html_nodes(covid_data_html, '#number-of-cases-and-deaths') 
      
      all_tests_raw_text<-html_text(xml_siblings(covid_xml)[3])
      positive_raw_text<-html_text(xml_siblings(covid_xml)[4])
      deaths_raw_text<-html_text(xml_siblings(covid_xml)[5])
      
      all_text<-str_match(all_tests_raw_text,pat_all)
      positive_text<-str_match(positive_raw_text,pat_pos)
      death_text<-str_match(deaths_raw_text,pat_died)
      
      # sanity check
      if (NA %in% all_text){
      flog.error("scraper failed with one or more NA terms, please check")   
      }
      
      scrape<-data.frame(
        report_date=as.Date(all_text[2],"%d %B"),
        tested=as.integer(gsub(",","",positive_text[2])),
        tests_on=data.frame(number=gsub(",","",all_text[4]),date=as.Date(all_text[5],"%d %B")),
        pos_tested=as.integer(gsub(",","",positive_text[3])),
        died_date=as.Date(death_text[2],"%d %B"),
        died=as.integer(gsub(",","",death_text[3]))
      )
      return(scrape)
    }
  
  scr<-scrape()
  scr
  
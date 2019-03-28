# plumber.R
library(xml2)
mine <- source("mining.R")

# mongo "mongodb+srv://cluster0-gyaih.mongodb.net/test" --username admin

#* Return emails in a website
#* @param url The website link
#* @post /email
function(url){
  # https://www.rondahayneslaw.com/
  find_emails <- function(url){
    landing_page <- read_html(url)
    all_links <- html_nodes(landing_page, "a")
    email_locations <- str_which(all_links, "mailto")
    email_links <- all_links[email_locations]
    #emails <- html_text(email_links)
    emails <- html_attr(email_links, "href")
    only_email <- function(email){
      str_sub(email,8,-1)
    }
    emails <- lapply(emails, only_email)
    return(emails)
  }
  find_emails(url)
}

#* Return the precedents around a term 
#* @param term Legal Search Term like Defamation or DUI
#* @param database Pick Free.Law or Case.Law
#* @post /research
function(term,database){
  search_case(term, database)
}

#* Return an list a cases related to a questions
#* @param question A legal questions like "Can I Get Sued From A Facebook Post"
#* @post /question
function(question){
  answers <- c("Answer1", "Answer2","Answer3")
  answers
}

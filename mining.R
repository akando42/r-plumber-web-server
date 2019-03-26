library(httr)
library(tidyverse)
library(tidytext)
library(wordcloud2)
library(R.utils)
library(XML)
library(stringr)

library(ggplot2)

search_case <- function(phrase, database){
  case_law_url <- "https://api.case.law/v1/"
  free_law_url <- "https://www.courtlistener.com/api/rest/v3/"
  get_response <- function(request_url){
    response <- GET(request_url) 
    response_content <- content(response, "parsed")
    response_content$results
  }
  if(database == "case_law"){
    request_url <- paste0(case_law_url, "citations?search=", phrase)  
    return(get_response(request_url))
  } else {
    request_url <- paste0(free_law_url, "search/?q=", phrase)
    return(get_response(request_url))
  }
}

get_case_html <-function(case_response){
  free_law_url <- "https://www.courtlistener.com/api/rest/v3"
  case_number <- case_response$id
  snippet <- case_response$snippet
  opinion_url <- paste0(free_law_url,"/opinions/", case_number)
  opinion_response <- GET(opinion_url)
  opinion_content <- content(opinion_response,"parsed")
  results <- opinion_content
  return(results$html)
}

# text > paragraph > words > words ranking
# >
# topics: 
#   topic1: [word1, word, word3],
#   topic2: [word1, word, word3],
#   topic3: [word1, word, word3],

mine_case_text <- function(case_html){
  ## Turn html into Pure Text
  html2txt <- function(html_content){
    # Read and parse HTML file
    doc.html = htmlTreeParse(html_content, useInternal=TRUE)
    
    # Extract all the paragraphs (HTML tag is p, starting at
    # the root of the document). Unlist flattens the list to
    # create a character vector.
    doc.text = unlist(xpathApply(doc.html, '//p', xmlValue))
    
    # Replace all by spaces
    doc.text = gsub('\n', ' ', doc.text)
    
    # Join all the elements of the character vector into a single
    # character string, separated by spaces
    #doc.text = paste(doc.text, collapse = ' ')
    return(doc.text)
  }
  
  case_text <- html2txt(case_html)
  
  ## Turn text into words
  text2words <- function(case_text){
    case_df <- tibble(case_text)
    word_df <- unnest_tokens(case_df, word, case_text)
    words <- anti_join(word_df, stop_words)
    dplyr::count(words, word, sort=TRUE)
    return(words)
  }
  
  word_df <- text2words(case_text)

  ## find keywords
  plot <- word_df %>%
    dplyr::count(word, sort = TRUE) %>%
    filter(n > 20) %>%
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n)) +
    geom_col() +
    xlab(NULL) +
    coord_flip()
  
    # library(ggplot2)
    # tidy_twilio %>%
    #   count(word, sort = TRUE) %>%
    #   filter(n > 100) %>%
    #   mutate(word = reorder(word, n)) %>%
    #   ggplot(aes(word, n)) +
    #   geom_col() +
    #   xlab(NULL) +
    #   coord_flip()
  
  return(plot)
}

index_case <- function(case){
  
}

get_answer <- function(question){
  # parse content of question
  
  
  # question keywords
  
  
  # query case based on keywords
  
  
  # return suggested cases.
  
}





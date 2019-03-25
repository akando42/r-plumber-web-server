library(httr)

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


######### 
# Text Analysis Book
library(janeaustenr)
library(stringr)
library(dplyr)

# Getting the data from janeaustinr package
original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(), 
         chapter= cumsum(str_detect(text, regex("^chapter [\\divxlc]", 
                                                ignore_case = TRUE)))) %>%
  ungroup()

tidy_books <- original_books %>%
  unnest_tokens(word, text)

tidy_books <- tidy_books %>%
  anti_join(stop_words)

tidy_books %>%
  count(word, sort = TRUE)

library(ggplot2)
tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

#########
# Getting company filling and analyse 
library(R.utils)
library(edgar)

twilio_8k_items <- get8KItems(cik.no =  0001447669, filing.year=2019)
twilio_biz_des <- getBusinDescr(cik.no = 0001447669, filing.year = 2019)

twilio_text <- readLines("Business descriptions text/CopyOfCopyOf1447669_10-K_2019-03-01_0001047469-19-000807.txt")
twilio_lines <- countLines("Business descriptions text/CopyOfCopyOf1447669_10-K_2019-03-01_0001047469-19-000807.txt")
text_df <- tibble(line = 1:twilio_lines, text = twilio_text)

tidy_twilio <- text_df %>%
  #mutate(linenumber = row_number(), ignore_case = TRUE)
  unnest_tokens(word, text)

tidy_twilio <- tidy_twilio %>%
  anti_join(stop_words)

tidy_twilio %>%
  count(word, sort=TRUE)

library(ggplot2)
tidy_twilio %>%
  count(word, sort = TRUE) %>%
  filter(n > 100) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


library(dplyr)
library(janeaustenr)

book_words <- austen_books() %>%
  unnest_tokens(word, text) %>%
  count(book,word,sort=TRUE)

book_words

book_words %>%
  bind_tf_idf(word, book, n) %>%
  arrange(desc(tf_idf))
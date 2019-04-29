install.packages(c(
	"plumber", 
	"httr",
	"tidyverse", 
	"tidytext",
	"rvest",
	"ggplot2"
	), 
	repos = "http://cran.us.r-project.org"
)

library(plumber)
r <- plumb("app.R") 
landing<- PlumberStatic$new("./files/static/")
r$mount("/",landing)
r$run(port=7777)

# library(httr)
# library(tidyverse)
# library(tidytext)
# library(wordcloud2)
# library(R.utils)
# library(XML)
# library(stringr)
# library(ggplot2)

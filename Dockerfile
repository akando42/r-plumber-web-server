FROM trestletech/plumber
MAINTAINER Docker User <troydo42@gmail.com>
COPY * /app/
WORKDIR /myapp
RUN R -e "setwd('~/app');install.packages(c('httr','rvest')); library(plumber);veritasServer <- plumb('app.R');veritasServer$run(port=7777)"
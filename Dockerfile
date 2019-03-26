FROM trestletech/plumber
MAINTAINER Docker User <troydo42@gmail.com>
COPY * /app/
WORKDIR /myapp
RUN R -e "install.packages(c('httr','rvest'))"
CMD ["library(plumber)"]
CMD ["veritasServer <- plumb("app.R")"]
CMD ["veritasServer$run(port=7777)"]
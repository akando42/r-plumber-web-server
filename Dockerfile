FROM trestletech/plumber
MAINTAINER Docker User <troydo42@gmail.com>

RUN R -e "install.packages(c('httr', 'tidyverse','tidytext', 'stringr', 'wordcloud2','XML','R.utils','ggplot2'))"
COPY * /app/
WORKDIR /app/
CMD ["r <- plumb("app.R"]")
CMD ["r$run(port=8000)"]
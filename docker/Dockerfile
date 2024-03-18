FROM debian:bullseye
RUN apt-get update && apt-get install -y postgresql-client postgresql-server-dev-13 r-base wget unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN R -e "install.packages('DBI', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('RPostgres', repos='http://cran.rstudio.com/')"
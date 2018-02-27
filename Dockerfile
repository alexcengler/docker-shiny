FROM rocker/shiny:latest
MAINTAINER Alex Engler

## Update and install git:
RUN apt-get update && apt-get install -y git

## Install Secure Sockets Layer (SSL) from OpenSSL
RUN apt-get install -y libssl-dev &&  \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/ && \ 
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds


## Install R Packages for Shiny app:
RUN sudo R -e "install.packages(c('caret','tidyverse','RColorBrewer','scales'), repos='http://cran.us.r-project.org')"

## Install R Packages for R ggplot2 theming:
RUN sudo R -e "install.packages(c('extrafont'))"


## Copy Shiny application into Docker container
COPY app.R /srv/shiny-server/app.R

## Copy Shiny Configuration into Docker container
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /srv/shiny-server/shiny-server.sh

## Copy data into Docker container
COPY data/solvency_measures.csv /srv/shiny-server/data/solvency_measures.csv
COPY data/summary.csv /srv/shiny-server/data/summary.csv
COPY text/option.csv /srv/shiny-server/text/option.csv

## Copy CSS styling and ggplot theming into Docker container
COPY www/bootstrap.css /srv/shiny-server/www/bootstrap.css
COPY urban_institute_themes/urban_theme_mac.R /srv/shiny-server/urban_institute_themes/urban_theme_mac.R


EXPOSE 3838
EXPOSE 80

CMD ["/usr/bin/shiny-server.sh"]
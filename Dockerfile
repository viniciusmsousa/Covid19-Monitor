FROM openanalytics/r-base

MAINTAINER Vinicius Sousa "vinisousa04@gmail.com" 

RUN apt-get update -qq && apt-get -y install \
  libxml2-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libsasl2-dev \
  libgdal-dev \
  libudunits2-dev 

RUN apt-get update -qq && apt-get install -y libgit2-dev

# Changing Work Dir
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

RUN R -e 'install.packages("remotes")'
COPY . /usr/src/app/
RUN R -e 'remotes::install_local()'
EXPOSE 3838
CMD  ["R", "-e", "options('shiny.port'=3838,shiny.host='0.0.0.0');covid19::run_app()"]
library(tidyverse)
library(magrittr) #not being use right now
library(stringr)

raw.data <- read.csv('C:\\Users\\Brian\\Desktop\\GradClasses\\Spring18\\607\\assignments\\week4Assignment.csv', head=TRUE, stringsAsFactors=FALSE, na.strings='') %>%
  rename(company=X, status=X.1) %>%
  filter(status!='') %>%
  na.locf() %>%
  gather('dest', 'count', 3:7) %>%
  spread('status', 'count') %>%
  map(~str_replace_all(., '\\.', ' ') %>% 
        type.convert(.)
      ) %>%
  as.tibble() 

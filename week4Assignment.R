library(tidyverse)
library(zoo)
library(magrittr) #not being use right now
library(stringr)

wide.data <- read.csv('C:\\Users\\Brian\\Desktop\\GradClasses\\Spring18\\607\\assignments\\week4Assignment.csv', head=TRUE, stringsAsFactors=FALSE, na.strings='') %>%
  rename(company=X, status=X.1) %>%
  filter(status!='') %>%
  na.locf() %>%
  gather('dest', 'count', 3:7) %>%
  spread('status', 'count') %>%
  map(~str_replace_all(., '\\.', ' ') %>% 
        type.convert(.)
      ) %>%
  as.tibble() 


# on time comparison ------------------------------------------------------
wide.data %>%
  mutate(prop=`on time`/(`on time` + delayed)) %>%
  ggplot() + 
  geom_histogram(aes(x=dest, y=prop, fill=company), stat='identity', position='dodge') + 
  labs(y='Proportion of On Time Flights', x='Destination', fill='Company', 
       title='Comparison of Rate of on Time Arrivals') +
  coord_flip() +
  guides(fill=guide_legend(reverse=TRUE))
# on time comparison ------------------------------------------------------  


# company comparison ------------------------------------------------------
wide.data %>%
  group_by(company) %>%
  summarise(`on time`=sum(`on time`), 
            propotion=sum(`on time`) / (sum(delayed) + sum(`on time`))
           )

wide.data %>%
  count(company, wt=delayed + `on time`)
# company comparison ------------------------------------------------------


# final summary -----------------------------------------------------------
wide.data %>%
  group_by(company) %>%
  summarise(delayed=sum(delayed),
            `on time`=sum(`on time`),
            total=sum(delayed) + sum(`on time`),
            propotion=sum(`on time`) / (sum(delayed) + sum(`on time`))
  )
# final summary -----------------------------------------------------------




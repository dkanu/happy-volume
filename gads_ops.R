
#imports
imports <- c('rio','dplyr')
invisible(lapply(imports, require, character.only = T))

#read_file
working_dir_var <- "~/Documents/R Scripts/google ads ops"
csv_input <- 'gads_data_studio_in.csv'

#set working dir; read data
setwd(working_dir_var)
ga_in <- import(csv_input)


#vars
conv.col <- 'Conversions'
cost.col <- 'Cost'
cost_per_conv.col <- 'Cost / conv.'

#export1 - Search Term Ops
search_term_ops <- 
  ga_in %>% arrange(desc(get(conv.col)))

get_search_term_ops <- function(i, conv.col_ = conv.col){
  o <- import(i) %>%
    arrange(desc(get(conv.col_)))
  name.out <- toString(format(Sys.time(), "%Y-%m-%d"))
  dir.create(name.out)
  name.out <- toString(sprintf('%s/search_terms_ops.csv',
                               name.out))
  export(o, name.out)
}

#export2 - Spend, No Conversions
spend_no_conv <-
  ga_in %>% filter(get(conv.col) == 0) %>%
  arrange(desc(get(cost.col)))

get_spend_no_conv <- function(i, conv.col_ = conv.col, 
                              cost.col_ = cost.col,  
                              max_conv_ = 0)
  {
  o <- import(i) %>% filter(get(conv.col_) <= max_conv_) %>%
    filter(get(cost.col_) > 0) %>%
    arrange(desc(get(cost.col_)))
  
  name.out <- toString(format(Sys.time(), "%Y-%m-%d"))
  name.out <- toString(sprintf('%s/spend_no_conv.csv',
                               name.out))
  export(o, name.out)
}

#export3 - Best Keywords
best_keywords <-
  ga_in %>% filter(get(conv.col) > 0) %>%
  arrange((get(cost_per_conv.col)))

get_best_keywords <- function(i, 
                              conv.col_ = conv.col, 
                              cost_per_conv.col_ = cost_per_conv.col,
                              min_conv_=0)
  {
  o <- import(i) %>% filter(get(conv.col_) > min_conv_) %>%
    arrange((get(cost_per_conv.col_)))
  name.out <- toString(format(Sys.time(), "%Y-%m-%d"))
  
  name.out <- toString(sprintf('%s/best_kw.csv',
                               name.out))
  export(o, name.out)
}

#Unit Tests - todo(@dkanu - fix this later)
#identical(search_term_ops, get_search_term_ops(csv_input))
#identical(spend_no_conv, get_spend_no_conv(csv_input))
#identical(best_keywords, get_best_keywords(csv_input))

#ArgParser
args <- commandArgs(trailingOnly = T)
#args_list <- as.list(args)
#print(args[1])

get_search_term_ops((args[1]))
get_spend_no_conv((args[1]))
get_best_keywords((args[1]))

# To Run as Command Prompt Program:
## Rscript gads_ops.r gads_data_studio_in.csv

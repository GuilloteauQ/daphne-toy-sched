library(tidyverse)

args = commandArgs(trailingOnly=TRUE)

n = length(args)
files = args[1:(n-2)]
policy = args[n-1]
outname = args[n]

get_df <- function(filename) {
  results = str_extract_all(filename, "\\d+")
  read_csv(filename, col_names=c("time")) %>%
    mutate(nb_threads = as.numeric(results[[1]][length(results[[1]])]))
}

files %>%
  map_df(get_df) %>%
  mutate(
    policy = policy
  ) %>%
  write_csv(outname)


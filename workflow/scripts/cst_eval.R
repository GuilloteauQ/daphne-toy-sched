library(tidyverse)

args = commandArgs(trailingOnly=TRUE)

n = length(args)
files = args[1:(n-1)]
outname = args[n]

get_df <- function(filename) {
  results = str_extract_all(filename, "\\d+")
  nb_threads = as.numeric(results[[1]][2])
  task_size  = as.numeric(results[[1]][1])
  read_csv(filename, col_names=c("time")) %>%
    mutate(
      nb_threads = nb_threads,
      task_size = task_size
    )
}

plot <- files %>%
  map_df(get_df) %>%
  group_by(task_size, nb_threads) %>%
  summarize(
    mean = mean(time),
    bar = 2 * sd(time) / sqrt(n())
  ) %>%
  ggplot(aes(x = task_size, y = mean, color = factor(nb_threads))) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin = mean - bar, ymax = mean + bar), width=0.2) +
  xlab("Task Size") +
  ylab("Time [s]") +
  ylim(0, NA) +
  ggtitle("Impact of task size on performance") +
  scale_color_discrete(name = "Nb of Threads") +
  theme_bw() +
  theme(legend.position = "bottom")
ggsave(plot = plot, outname)


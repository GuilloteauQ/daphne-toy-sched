library(tidyverse)

args = commandArgs(trailingOnly=TRUE)

n = length(args)
files = args[1:(n-1)]
outname = args[n]


plot <- files %>%
  map_df(read_csv) %>%
  group_by(policy, nb_threads) %>%
  summarize(
    mean = mean(time),
    bar = 2 * sd(time) / sqrt(n())
  ) %>%
  ggplot(aes(x = nb_threads, y = mean, color = policy)) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin = mean - bar, ymax = mean + bar), width=0.2) +
  xlab("Number of Threads") +
  ylab("Time [s]") +
  ylim(0, NA) +
  ggtitle("Scaling of each scheduling policy") +
  theme_bw() +
  theme(legend.position = "bottom")

ggsave(plot = plot, outname)

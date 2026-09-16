obj$condition_cluster <- paste(obj$cluster, stia_5$condition, sep="_")

tab <- table(obj$sample_id, obj$condition_cluster)

library(splitstackshape)

# Convert counts to proportions per sample
prop_tab <- prop.table(tab, margin = 1)

# Convert to tidy data frame
df_prop <- as.data.frame(prop_tab)
colnames(df_prop) <- c("sample", "cluster_condition", "proportion")
df_prop <- cSplit(df_prop, splitCols = "cluster_condition", sep="_")
df_prop <- df_prop %>% filter(proportion > 0.00001)


# Filter for a specific cluster of interest
df_prop_apod <- df_prop %>% filter(cluster_condition_1 == "MF")

summary_data <- df_prop_apod %>%
  dplyr::group_by(cluster_condition_2) %>%
  dplyr::summarise(
    Mean = mean(proportion),
    SD = sd(proportion)
  )

summary_data %>% 
ggplot( aes(x = cluster_condition_2, y = Mean)) +
  geom_bar(stat = "identity", color = "black", width = 0.85, fill = "lightgrey" ) +               # Bars
  geom_errorbar(aes(ymin = Mean - SD, ymax = Mean + SD), width = 0.2, size = 0.8) +        # Error bars
  geom_jitter(data = df_prop_apod, aes(x = cluster_condition_2, y = proportion), width = 0.15,         # Points
              color = "black", size = 3, alpha = 1) +
   theme(
      panel.background = element_blank(),      
      plot.background = element_blank(),        
      panel.grid.major = element_blank(),      
      panel.grid.minor = element_blank(),      
      axis.line = element_line(color = "black"), 
    plot.margin = margin(t = 5, r = 5, b = -2, l = 5)
      ) +scale_y_continuous(expand = c(0, 0)) +
coord_cartesian(ylim = c(0, max(summary_data$Mean + summary_data$SD))*1.3)

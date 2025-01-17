summarize_clusters <- function(data, cluster_labels) {
  data$Cluster <- cluster_labels
  library(dplyr)
  summary <- data %>%
    group_by(Cluster) %>%
    summarise(
      AvgAge = mean(Age, na.rm = TRUE),
      AvgIncome = mean(Income, na.rm = TRUE),
      AvgSpend = mean(MonthlySpend, na.rm = TRUE),
      AvgSavings = mean(SavingsBalance, na.rm = TRUE),
      Transactions = mean(TransactionsPerMonth, na.rm = TRUE),
      Count = n()
    )
  return(summary)
}

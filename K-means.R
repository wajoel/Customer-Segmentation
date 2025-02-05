dev.off()

# Load required libraries
library(tidyverse)
library(cluster)   # For clustering metrics
library(factoextra) # For visualization
library(ggplot2)
library(gridExtra)

# Load dataset
data <- read.csv("./rawSegdata.csv")

# Remove CustgomerID (not needed for clusterin)
data <- data %>% select(-CustomerID)

# Convert Gender to numeric (Male = 1, Female = 0)
data$Gender <- as.numeric(data$Gender == "Male")

# Scale numeric variables (Age, Income, Spending Score)
scaled_data <- data %>% mutate(across(everything(), scale))

# Check summary
summary(scaled_data)

# Function to compute WCSS
wcss <- function(k) {
  kmeans(scaled_data, centers = k, nstart = 25)$tot.withinss
}

# Compute WCSS for k = 1 to 10
k_values <- 1:10
wcss_values <- map_dbl(k_values, wcss)

# Plot Elbow Method with enhanced visualization
elbow_plot <- ggplot(data.frame(k_values, wcss_values), aes(x = k_values, y = wcss_values)) +
  geom_point(size = 4, color = "blue") +
  geom_line(color = "red", linetype = "dashed", size = 1) +
  labs(title = "Elbow Method for Optimal K", x = "Number of Clusters K", y = "Within-Cluster Sum of Squares (WCSS)") +
  theme_minimal(base_family = "Times New Roman") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

# Function to compute Silhouette Score
sil_score <- function(k) {
  km <- kmeans(scaled_data, centers = k, nstart = 25)
  ss <- silhouette(km$cluster, dist(scaled_data))
  mean(ss[, 3])
}

sil_values <- map_dbl(2:10, sil_score)

# Plot Silhouette Scores with enhanced visualization
sil_plot <- ggplot(data.frame(K = 2:10, Score = sil_values), aes(x = K, y = Score)) +
  geom_point(size = 4, color = "blue") +
  geom_line(color = "red", linetype = "dashed", size = 1) +
  labs(title = "Silhouette Score for K-Means Clustering", x = "Number of Clusters K", y = "Silhouette Score") +
  theme_minimal(base_family = "Times New Roman") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

# Compute Gap Statistic
gap_stat <- clusGap(scaled_data, FUN = kmeans, K.max = 10, B = 50)

# Plot Gap Statistic
fviz_gap_stat(gap_stat) + theme_minimal(base_family = "Times New Roman") +  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

# Set seed for reproducibility
set.seed(123)
k_final <- kmeans(scaled_data, centers = 4, nstart = 25)

# Add cluster labels to the original dataset
data$Cluster <- as.factor(k_final$cluster)

# Cluster summary
cluster_summary <- data %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean))

# Display enhanced plots
grid.arrange(elbow_plot, sil_plot, nrow = 1)




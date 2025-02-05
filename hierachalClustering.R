dev.off()

# Load required libraries
library(tidyverse)
library(cluster)   # For clustering metrics
library(factoextra) # For advanced visualization
library(dendextend) # For enhanced dendrograms
library(ggplot2)
library(gridExtra)

# Function to preprocess data
preprocess_data <- function(file_path) {
  data <- read.csv(file_path) %>% select(-CustomerID)
  data$Gender <- as.numeric(data$Gender == "Male")
  scaled_data <- data %>% mutate(across(everything(), scale))
  return(list(original = data, scaled = scaled_data))
}

# Function to perform hierarchical clustering
perform_hclust <- function(scaled_data, k = 4) {
  dist_matrix <- dist(scaled_data, method = "euclidean")
  hc <- hclust(dist_matrix, method = "ward.D")
  clusters <- cutree(hc, k = k)
  return(list(hc = hc, clusters = clusters))
}

# Function to plot dendrogram
plot_dendrogram <- function(hc, k = 4) {
  par(family = "Times New Roman", mar = c(5, 5, 5, 5))
  dend <- as.dendrogram(hc) %>%
    set("branches_k_color", k = k) %>%
    set("branches_lwd", 2) %>%
    set("labels_cex", 0.8)
  plot(dend, main = "Hierarchical Clustering Dendrogram", cex.main = 1.5)
}

# Function to determine optimal clusters
plot_optimal_clusters <- function(scaled_data) {
  p1 <- fviz_nbclust(scaled_data, FUN = hcut, method = "wss") +
    theme(text = element_text(family = "Times New Roman"))
  p2 <- fviz_nbclust(scaled_data, FUN = hcut, method = "silhouette") +
    theme(text = element_text(family = "Times New Roman"))
  grid.arrange(p1, p2, nrow = 1)
}

# Function to visualize clusters
plot_clusters <- function(scaled_data, clusters) {
  fviz_cluster(list(data = scaled_data, cluster = clusters), 
               geom = "point", ellipse.type = "norm", 
               main = "Customer Segmentation (Hierarchical Clustering)") +
    theme(text = element_text(family = "Times New Roman"))
}

# Load and preprocess data
data_info <- preprocess_data("./rawSegdata.csv")
data <- data_info$original
scaled_data <- data_info$scaled

# Perform clustering
hclust_results <- perform_hclust(scaled_data, k = 4)
hc <- hclust_results$hc
clusters <- hclust_results$clusters

data$Cluster <- as.factor(clusters)

# Display cluster summary
cluster_summary <- data %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean))

# Plot results
plot_dendrogram(hc, k = 4)
plot_optimal_clusters(scaled_data)
plot_clusters(scaled_data, clusters)







# Load required libraries
library(tidyverse)
library(dbscan)    # For DBSCAN clustering
library(factoextra) # For visualization
library(cluster)   # For silhouette analysis
library(ggplot2)
library(gridExtra)

# Function to preprocess data
preprocess_data <- function(file_path) {
  data <- read.csv(file_path) %>% select(-CustomerID)
  data$Gender <- as.numeric(data$Gender == "Male")
  scaled_data <- data %>% mutate(across(everything(), scale))
  return(list(original = data, scaled = scaled_data))
}

# Function to fit DBSCAN model
fit_dbscan <- function(scaled_data, eps, minPts) {
  dbscan_model <- dbscan(scaled_data, eps = eps, minPts = minPts)
  return(dbscan_model)
}

compute_silhouette <- function(data, scaled_data) {
  valid_indices <- data$Cluster != 0  # Exclude noise points
  valid_clusters <- as.numeric(as.character(data$Cluster[valid_indices]))  # Convert factor to numeric
  
  if (length(unique(valid_clusters)) > 1) {
    silhouette_score <- silhouette(valid_clusters, dist(scaled_data[valid_indices, ]))
    return(mean(silhouette_score[, 3]))
  } else {
    return(NA)
  }
}


# Function to visualize clusters
plot_clusters <- function(scaled_data, clusters) {
  fviz_cluster(list(data = scaled_data, cluster = clusters), 
               geom = "point", ellipse.type = "convex", 
               main = "Customer Segmentation (DBSCAN)") +
    theme(text = element_text(family = "Times New Roman"))
}

# Load and preprocess data
data_info <- preprocess_data("./rawSegdata.csv")
data <- data_info$original
scaled_data <- data_info$scaled

# Fit DBSCAN model (parameters should be tuned)
dbscan_model <- fit_dbscan(scaled_data, eps = 0.5, minPts = 5)

# Assign cluster labels to the dataset
data$Cluster <- as.factor(dbscan_model$cluster)

# Display cluster summary
cluster_summary <- data %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean))

# Compute silhouette score
silhouette_mean <- compute_silhouette(data, scaled_data)
print(paste("Average Silhouette Score:", silhouette_mean))

# Plot results
plot_clusters(scaled_data, data$Cluster)

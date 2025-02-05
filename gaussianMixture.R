# Load required libraries
library(tidyverse)
library(mclust)    # For Gaussian Mixture Model (GMM)
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

# Function to fit GMM and get optimal clusters
fit_gmm <- function(scaled_data) {
  gmm_model <- Mclust(scaled_data)
  return(gmm_model)
}

# Function to plot GMM results
plot_gmm_results <- function(gmm_model) {
  par(family = "Times New Roman")
  plot(gmm_model, what = "BIC", main = "BIC Scores for GMM")
  plot(gmm_model, what = "density", main = "Density of Cluster Probabilities")
}

# Function to compute silhouette score
compute_silhouette <- function(data, scaled_data) {
  silhouette_score <- silhouette(as.numeric(data$Cluster), dist(scaled_data))
  return(mean(silhouette_score[, 3]))
}

# Function to visualize clusters
plot_clusters <- function(scaled_data, clusters) {
  fviz_cluster(list(data = scaled_data, cluster = clusters), 
               geom = "point", ellipse.type = "norm", 
               main = "Customer Segmentation (GMM)") +
    theme(text = element_text(family = "Times New Roman"))
}

# Load and preprocess data
data_info <- preprocess_data("./rawSegdata.csv")
data <- data_info$original
scaled_data <- data_info$scaled

# Fit GMM model
gmm_model <- fit_gmm(scaled_data)

# Optimal number of clusters
optimal_k <- gmm_model$G
print(paste("Optimal number of clusters:", optimal_k))

# Assign cluster labels to the dataset
data$Cluster <- as.factor(predict(gmm_model)$classification)

# Display cluster summary
cluster_summary <- data %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean))

# Compute silhouette score
silhouette_mean <- compute_silhouette(data, scaled_data)
print(paste("Average Silhouette Score:", silhouette_mean))

# Plot results
plot_gmm_results(gmm_model)
plot_clusters(scaled_data, data$Cluster)

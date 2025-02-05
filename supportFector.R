dev.off()

# Load required libraries
library(tidyverse)
library(dbscan)    # For DBSCAN clustering
library(factoextra) # For visualization
library(cluster)   # For silhouette analysis
library(ggplot2)
library(gridExtra)
library(rpart)      # For Decision Trees (CART)
library(rpart.plot) # For Decision Tree visualization
library(randomForest) # For Random Forests
library(nnet)       # For Neural Networks
library(e1071)      # For Support Vector Machines (SVM)

# Function to fit DBSCAN model
fit_dbscan <- function(scaled_data, eps, minPts) {
  dbscan_model <- dbscan(scaled_data, eps = eps, minPts = minPts)
  return(dbscan_model)
}

# Function to compute silhouette score
compute_silhouette <- function(data, scaled_data) {
  valid_clusters <- as.numeric(as.character(data$Cluster[data$Cluster != 0]))  # Convert factor to numeric
  if (length(unique(valid_clusters)) > 1) {
    silhouette_score <- silhouette(valid_clusters, dist(scaled_data[data$Cluster != 0, ]))
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

# Function to train Decision Tree (CART)
fit_decision_tree <- function(data) {
  tree_model <- rpart(Cluster ~ ., data = data, method = "class")
  return(tree_model)
}

# Function to visualize Decision Tree
plot_decision_tree <- function(tree_model) {
  rpart.plot(tree_model, main = "Decision Tree for Cluster Classification",
             type = 2, extra = 104, under = TRUE, cex = 0.8)
}

# Function to train Random Forest model
fit_random_forest <- function(data) {
  rf_model <- randomForest(Cluster ~ ., data = data, ntree = 500, mtry = sqrt(ncol(data) - 1), importance = TRUE)
  return(rf_model)
}

# Function to visualize feature importance
plot_feature_importance <- function(rf_model) {
  importance_df <- as.data.frame(importance(rf_model))
  importance_df$Feature <- rownames(importance_df)
  ggplot(importance_df, aes(x = reorder(Feature, MeanDecreaseGini), y = MeanDecreaseGini)) +
    geom_col(fill = "steelblue") +
    coord_flip() +
    labs(title = "Feature Importance (Random Forest)", x = "Features", y = "Mean Decrease in Gini") +
    theme_minimal()
}

# Function to train Neural Network model
fit_neural_network <- function(data, size = 5, decay = 0.01, maxit = 200) {
  nn_model <- nnet(Cluster ~ ., data = data, size = size, decay = decay, maxit = maxit, linout = FALSE)
  return(nn_model)
}

# Function to train SVM model
fit_svm <- function(data) {
  svm_model <- svm(Cluster ~ ., data = data, kernel = "radial", cost = 1, gamma = 0.1)
  return(svm_model)
}

# Function to plot SVM decision boundary
plot_svm_decision_boundary <- function(data, svm_model) {
  ggplot(data, aes(x = data[[1]], y = data[[2]], color = Cluster)) +
    geom_point() +
    labs(title = "SVM Decision Boundary", x = "Feature 1", y = "Feature 2") +
    theme_minimal()
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

# Train and visualize Decision Tree
if (length(unique(data$Cluster)) > 1) {
  tree_model <- fit_decision_tree(data)
  plot_decision_tree(tree_model)
} else {
  print("Decision Tree not applicable due to a single cluster.")
}

# Train and visualize Random Forest model
if (length(unique(data$Cluster)) > 1) {
  rf_model <- fit_random_forest(data)
  plot_feature_importance(rf_model)
} else {
  print("Random Forest not applicable due to a single cluster.")
}

# Train Neural Network model
if (length(unique(data$Cluster)) > 1) {
  nn_model <- fit_neural_network(data)
  print(nn_model)
} else {
  print("Neural Network not applicable due to a single cluster.")
}

# Train and visualize SVM model
if (length(unique(data$Cluster)) > 1) {
  svm_model <- fit_svm(data)
  plot_svm_decision_boundary(data, svm_model)
} else {
  print("SVM not applicable due to a single cluster.")
}

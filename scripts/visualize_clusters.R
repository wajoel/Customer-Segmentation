
visualize_clusters <- function(data, cluster_labels) {
  library(factoextra)
  fviz_cluster(list(data = data, cluster = cluster_labels),
               geom = "point", ellipse.type = "norm",
               main = "Cluster Visualization")
}

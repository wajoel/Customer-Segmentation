perform_hierarchical_clustering <- function(data) {
  dist_matrix <- dist(data)
  hclust_result <- hclust(dist_matrix, method = "ward.D2")
  return(hclust_result)
}

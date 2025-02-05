perform_dbscan <- function(data, eps = 0.5, minPts = 5) {
  library(dbscan)
  dbscan_result <- dbscan(data, eps = eps, minPts = minPts)
  return(dbscan_result$cluster)
}

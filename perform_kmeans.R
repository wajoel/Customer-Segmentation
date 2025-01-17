perform_kmeans <- function(data, k) {
  set.seed(123)
  kmeans_result <- kmeans(data, centers = k, nstart = 25)
  return(kmeans_result)
}

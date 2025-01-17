elbow_method <- function(data, max_k = 10) {
  wss <- sapply(1:max_k, function(k) {
    kmeans(data, centers = k, nstart = 10)$tot.withinss
  })
  plot(1:max_k, wss, type = "b", pch = 19, frame = FALSE,
       xlab = "Number of Clusters",
       ylab = "Within Sum of Squares",
       main = "Elbow Method for Optimal Clusters")
}

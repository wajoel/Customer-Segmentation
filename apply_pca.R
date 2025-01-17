apply_pca <- function(data, n_components = 2) {
  pca_result <- prcomp(data, scale. = TRUE)
  return(data.frame(pca_result$x[, 1:n_components]))
}

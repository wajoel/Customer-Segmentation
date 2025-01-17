normalize_data <- function(data, columns) {
  data[columns] <- lapply(data[columns], function(x) (x - min(x)) / (max(x) - min(x)))
  return(data)
}

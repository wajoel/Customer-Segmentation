encode_categorical <- function(data, cols_to_encode) {
  for (col in cols_to_encode) {
    data[[col]] <- as.numeric(factor(data[[col]], levels = unique(data[[col]])))
  }
  return(data)
}

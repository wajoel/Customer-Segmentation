save_processed_data <- function(data, file_path) {
  write.csv(data, file_path, row.names = FALSE)
  message("Data saved to: ", file_path)
}

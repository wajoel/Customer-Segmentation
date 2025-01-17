load_data <- function(file_path) {
  if (file.exists(file_path)) {
    return(read.csv(file_path))
  } else {
    stop("File not found!")
  }
}

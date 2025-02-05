# Function to preprocess data
preprocess_data <- function(file_path) {
  data <- read.csv(file_path) %>% select(-CustomerID)
  data$Gender <- as.numeric(data$Gender == "Male")
  scaled_data <- data %>% mutate(across(everything(), scale))
  return(list(original = data, scaled = scaled_data))
}
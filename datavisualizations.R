# Function to create a histogram with density plot
draw_histogram <- function(data, column_name) {
  # Set up the font to Times New Roman
  library(ggplot2)
  library(ggthemes)
  library(showtext)
  font_add(family = "Times New Roman", regular = "times.ttf")
  showtext_auto()
  
  # Ensure the column exists in the data
  if (!column_name %in% names(data)) {
    stop("Column not found in dataset")
  }
  
  # Create histogram
  hist(data[[column_name]], 
       prob = TRUE,  # Use probability density instead of frequency
       breaks = 30, 
       col = "#69b3a2", 
       border = "black", 
       main = paste("Distribution of", column_name), 
       xlab = column_name, 
       ylab = "Density",
       family = "Times New Roman")
  
  # Add density plot
  lines(density(data[[column_name]]), col = "red", lwd = 2)
}

# Function to create a density plot based on generic column names
draw_density_plot <- function(data, column_name, group_column) {
  # Set up the font
  font_add(family = "Times New Roman", regular = "times.ttf")
  showtext_auto()
  
  # Check required columns
  if (!(column_name %in% names(data) && group_column %in% names(data))) {
    stop("Required columns not found in dataset")
  }
  
  ggplot(data, aes(x = .data[[column_name]], fill = .data[[group_column]])) +
    geom_density(alpha = 0.6) +
    theme_minimal(base_family = "Times New Roman") +
    scale_fill_manual(values = c("#E69F00", "#56B4E9")) +
    labs(title = paste("Density Plot of", column_name, "by", group_column),
         x = column_name,
         y = "Density") +  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
}

# Function to create a scatter plot based on generic column names
draw_scatter_plot <- function(data, x_column, y_column, color_column) {
  # Set up the font
  font_add(family = "Times New Roman", regular = "times.ttf")
  showtext_auto()
  
  # Check required columns
  if (!(x_column %in% names(data) && y_column %in% names(data) && color_column %in% names(data))) {
    stop("Required columns not found in dataset")
  }
  
  ggplot(data, aes(x = .data[[x_column]], y = .data[[y_column]], color = .data[[color_column]])) +
    geom_point(size = 3, alpha = 0.8) +
    scale_color_gradient(low = "blue", high = "red") +
    theme_classic(base_family = "Times New Roman") +
    labs(title = paste(x_column, "vs.", y_column),
         x = x_column,
         y = y_column) +  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
}

# Function to create a box plot based on generic column names
draw_boxplot <- function(data, x_column, y_column) {
  # Set up the font
  font_add(family = "Times New Roman", regular = "times.ttf")
  showtext_auto() 
  
  # Check required columns
  if (!(x_column %in% names(data) && y_column %in% names(data))) {
    stop("Required columns not found in dataset")
  }
  
  ggplot(data, aes(x = .data[[x_column]], y = .data[[y_column]], fill = .data[[x_column]])) +
    geom_boxplot(outlier.color = "red", outlier.shape = 8) +
    theme_bw(base_family = "Times New Roman") +
    scale_fill_manual(values = c("#E69F00", "#56B4E9")) +
    labs(title = paste("Boxplot of", y_column, "by", x_column),
         x = x_column,
         y = y_column) +  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
}

# Example usage:
data <- read.csv("./rawSegdata.csv")
head(data)
draw_histogram(data, "Income")
draw_density_plot(data, "spendingScore", "Gender")
scatter <- draw_scatter_plot(data, "Age", "Income", "spendingScore");scatter
box <- draw_boxplot(data, "Gender", "spendingScore");box

# # Save histogram plot (for base R)
# png(file.path("./outputs", "histogram.png"), width = 800, height = 600, res = 300)
# draw_histogram(data, "Income")






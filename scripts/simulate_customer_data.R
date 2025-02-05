simulate_customer_data <- function(n = 1000) {
  set.seed(123)
  data <- data.frame(
    CustomerID = 1:n,
    Age = sample(18:70, n, replace = TRUE),
    Gender = sample(c("Male", "Female"), n, replace = TRUE),
    Income = round(rnorm(n, mean = 50000, sd = 20000), 0),
    MonthlySpend = round(rnorm(n, mean = 1500, sd = 800), 0),
    TransactionsPerMonth = sample(1:50, n, replace = TRUE),
    SavingsBalance = round(runif(n, 1000, 100000), 0),
    CreditCardUsage = sample(c("High", "Medium", "Low"), n, replace = TRUE),
    LoanHistory = sample(c("Good", "Average", "Bad"), n, replace = TRUE),
    Tenure = sample(1:30, n, replace = TRUE)
  )
  return(data)
}

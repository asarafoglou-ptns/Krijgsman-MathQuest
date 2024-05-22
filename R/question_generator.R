# Generate a random math question (2 numbers and an operator)
# based on the selected grade

question_generator <- function(grade) {
  # Create numerical range for each grade
  num_range <- switch(as.character(grade),  # Convert to character for switch
                      '2' = 1:20,
                      '3' = 1:50,
                      '4' = 1:100,
                      '5' = 1:1000,
                      '6' = 1:2000)  
  
  # Generate random numbers based on the num_range
  num1 <- sample(num_range, 1)
  num2 <- sample(num_range, 1)
  
  # Assign operators based on grade
  operator <- switch(as.character(grade),  # Convert to character for switch
                     '2' = sample(c("+", "-"), 1),
                     '3' = sample(c("+", "-", "*"), 1),
                     '4' = sample(c("+", "-", "*", "/"), 1),
                     '5' = sample(c("+", "-", "*", "/"), 1),
                     '6' = sample(c("+", "-", "*", "/"), 1))
  
  # Loop to generate division sums until a whole number answer is obtained
  while (operator == "/" && num1 %% num2 != 0) {
    num1 <- sample(num_range, 1)
    num2 <- sample(num_range, 1)
  }
  
  if (operator == "/") {
    result <- num1 %/% num2  # Make sure it's integer division
  } else {
    result <- eval(parse(text = paste(num1, operator, num2)))
  }
  
  # Question text
  text <- paste("What is", num1, operator, num2, "?")
  
  # Create list 
  list(text = text, answer = result, correct = FALSE)
}
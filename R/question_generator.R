# Separate question generator functions per operator

# Addition question generator
addition_question <- function(grade) {
  num1 <- switch(grade,
                 '2' = sample(1:20, 1),
                 '3' = sample(1:50, 1),
                 '4' = sample(1:100, 1),
                 '5' = sample(1:1000, 1),
                 '6' = sample(1:2000, 1))
  
  num2 <- switch(grade,
                 '2' = sample(1:20, 1),
                 '3' = sample(1:50, 1),
                 '4' = sample(1:100, 1),
                 '5' = sample(1:1000, 1),
                 '6' = sample(1:2000, 1))
  
  # Result
  result <- num1 + num2
  
  # Question text
  text <- paste("What is", num1, "+", num2, "?")

  # Create list 
  list(text = text, answer = result, correct = FALSE)
}

# Subtraction question generator
subtraction_question <- function(grade) {
  num1 <- switch(grade,
                 '2' = sample(1:20, 1),
                 '3' = sample(1:50, 1),
                 '4' = sample(1:100, 1),
                 '5' = sample(1:1000, 1),
                 '6' = sample(1:2000, 1))
  
  num2 <- switch(grade,
                 '2' = sample(1:20, 1),
                 '3' = sample(1:50, 1),
                 '4' = sample(1:100, 1),
                 '5' = sample(1:1000, 1),
                 '6' = sample(1:2000, 1))
  
  # Swap num1 and num2 if result would be negative
  if (num2 > num1) {
    temp <- num2
    num2 <- num1
    num1 <- temp
  }
  
  # Result
  result <- num1 - num2
  
  # Question text
  text <- paste("What is", num1, "-", num2, "?")
  
  # Create list 
  list(text = text, answer = result, correct = FALSE)
}

# Multiplication question generator
multiplication_question <- function(grade) {
  num1 <- switch(grade,
                      '3' = sample(1:10, 1),
                      '4' = sample(1:20, 1),
                      '5' = sample(1:10, 1) * 10,
                      '6' = sample(1:10, 1) * 100)  
  
  num2 <- switch(grade,
                 '3' = sample(1:10, 1),
                 '4' = sample(1:20, 1),
                 '5' = sample(1:20, 1),
                 '6' = sample(1:20, 1))  
  
  # Result
  result <- num1 * num2
  
  # Question text
  text <- paste("What is", num1, "*", num2, "?")
  
  # Create list 
  list(text = text, answer = result, correct = FALSE)
}

# Division question generator
division_question <- function(grade) {
  # A / B = C => A = B * C
  
  # B
  num2 <- switch(grade,
                 '4' = sample(1:10, 1),
                 '5' = sample(2:20, 1) * 10,
                 '6' = sample(2:20, 1) * 100)
  
  # C
  result <- switch(grade,
                 '4' = sample(1:10, 1),
                 '5' = sample(1:20, 1),
                 '6' = sample(1:20, 1))
  
  # A = B * C
  num1 <- num2 * result
  
  # Question text
  text <- paste("What is", num1, "/", num2, "?")
  
  # Create list 
  list(text = text, answer = result, correct = FALSE)
}


# Generate a random math question (2 numbers and an operator) based on the selected grade

question_generator <- function(grade) {
  # Convert to character for switch
  grade <- as.character(grade)
  
  # Assign operators based on grade
  operator <- switch(grade,  
                     '2' = sample(c("+", "-"), 1),
                     '3' = sample(c("+", "-", "*"), 1),
                     '4' = sample(c("+", "-", "*", "/"), 1),
                     '5' = sample(c("+", "-", "*", "/"), 1),
                     '6' = sample(c("+", "-", "*", "/"), 1))
  
  # Generate question with the operator functions
  question <- switch(operator,
         '+' = addition_question(grade),
         '-' = subtraction_question(grade),
         '*' = multiplication_question(grade),
         '/' = division_question(grade))
  
  question
}
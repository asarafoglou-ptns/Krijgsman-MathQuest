question_picker <- function(questions, correct_questions) {
  reactive({
    # Filter the dataframe to include only rows where correct is FALSE
    correct <- correct_questions()
    
    if (length(correct) > 0) {
      incorrect_questions <- questions()[-correct, ]
    } else {
      incorrect_questions <- questions()
    }
    
    # Check if there are any incorrect questions
    if (nrow(incorrect_questions) > 0) {
      # Pick a random row from the filtered dataframe
      random_index <- sample(nrow(incorrect_questions), 1)
      random_question <- incorrect_questions[random_index, ]
    } else {
      random_question <- NULL
    }  
    
    random_question
  })
}

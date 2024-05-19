source("R/question_generator.R")
source("R/quiz_generator.R")
source("R/question_picker.R")
source("R/calculator.R")

# Create personalized server to define number of questions for the quiz
create_server <- function(question_count, name) {
  
  ## Define server logic
  server <- function(input, output, session) {
    # Generate  questions for quiz
    questions <- quiz_generator(input, question_count)
    
    # Store correct questions
    correct_questions <- shiny::reactiveVal(integer(0))
    
    # Call question_picker function to get current question
    current_question <- question_picker(questions, correct_questions)
    
    # User name available for UI
    output$name <- shiny::renderText(name)
    
    # Display the question
    output$question <- shiny::renderText({
      question <- current_question()
      
      if (!is.null(question)) {
        return(question$text)
      } else {
        return(NULL)
      }
    })
    
    # Check the user's answer and provide feedback
    shiny::observeEvent(input$submit, {
      shiny::req(input$answer)
      question <- current_question()
      correct_answer <- input$answer == question$answer
      
      # Correct answer
      if (correct_answer) {
        output$feedback <- shiny::renderText({
          paste("Well done", name, "! Your answer is correct.")
        })
      } else {
        # Incorrect question
        output$feedback <- shiny::renderText({
          paste("Incorrect. The correct answer is",
                question$answer,
                ".")
        })
      }
      
      # Enable 'Next question' button after submitting the answer
      shiny::updateActionButton(session, "next_question", disabled = FALSE)
    })
    
    # Generate next question when 'Next question' button is clicked
    shiny::observeEvent(input$next_question, {
      shiny::req(input$next_question)
      
      question <- current_question()
      correct_answer <- input$answer == question$answer
      
      if (correct_answer) {
        question_index <- which(questions()$text == question$text)
        correct_questions(c(correct_questions(), question_index))
      }
      
      # Reset feedback and answer input
      output$feedback <- shiny::renderText({
        NULL
      })
      shiny::updateNumericInput(session, "answer", value = NA)
      
      # Disable 'Next question' button after all questions are completed
      new_question <- current_question()
      
      if (is.null(new_question)) {
        output$feedback <- shiny::renderText({
          "You completed the quiz!"
        })
        shiny::updateActionButton(session, "next_question", disabled = TRUE)
      }
    })
    
    observeCalculator(input, output)
    
    # Show grade information modal when 'i' button is clicked
    shiny::observeEvent(input$show_grade_info, {
      shiny::showModal(
        shiny::modalDialog(
          title = "Grade Information",
          shiny::p(
            "Not sure what grade to choose to embark on the right adventure?"
          ),
          shiny::p("Choose the corresponding grade to your age:"),
          shiny::tags$ul(
            shiny::p(tags$li("Second-grade: Age 7-8")),
            shiny::p(tags$li("Third-grade: Age 8-9")),
            shiny::p(tags$li("Fourth-grade: Age 9-10")),
            shiny::p(tags$li("Fifth-grade: Age 10-11")),
            shiny::p(tags$li("Sixth-grade: Age 11-12"))
          ),
          footer = shiny::tagList(shiny::actionButton("close_info", "Close"))
        )
      )
    })
    
    # Close grade information modal when 'Close' button is clicked
    shiny::observeEvent(input$close_info, {
      shiny::removeModal()
    })
    
    # Reactive variable to track correct answers
    shiny::observe({
      progress_value <- length(correct_questions()) / nrow(questions()) * 100
      shinyWidgets::updateProgressBar(session, "progress", value = progress_value)
    })
  }
}
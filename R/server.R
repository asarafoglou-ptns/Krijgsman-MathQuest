source("R/question_generator.R")
source("R/quiz_generator.R")
source("R/question_picker.R")
source("R/calculator.R")

# Add extra function around the server function to allow arguments when using the runMathQuest function
create_server <- function(question_count, name) {
  
  # Define server logic
  server <- function(input, output, session) {
    
    # User name available for UI
    output$name <- shiny::renderText(name)
    
    # Generate questions for quiz
    questions <- quiz_generator(input, question_count)
    
    # Store questions that were correctly answered
    correct_questions <- shiny::reactiveVal(integer(0))

    # Store questions that were incorrect at least once
    incorrect_questions <- shiny::reactiveVal(integer(0))
    
    # Store correct questions on first try
    first_try_correct_questions <- shiny::reactiveVal(integer(0))
    
    # Store total number of incorrect attempts
    incorrect_attempts <- shiny::reactiveVal(0)
    
    # Save submitted answer to prevent changing the answer after
    current_answer <- shiny::reactiveVal(0) 
    
    # User has made 5 or more mistakes
    game_over <- shiny::reactiveVal(FALSE)
    
    # Store attempt count
    current_attempt <- shiny::reactiveVal(0)
    
    # Call question_picker function to get current question
    current_question <- question_picker(questions, current_attempt, correct_questions, game_over)
    
    # Disable grade selection after "Select" button is clicked
    shiny::observeEvent(input$select, {
      shiny::updateActionButton(session, "select", disabled = TRUE)
      shinyjs::disable("grade")
    })
    
    # Reactive value for when quiz is finished
    output$finished <- shiny::renderText({
      if (is.null(current_question())) {
        'TRUE'
      } else {
        'FALSE'
      }
    })
    shiny::outputOptions(output, "finished", suspendWhenHidden = FALSE)
    
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
      question_index <- which(questions()$text == question$text)
      correct_answer <- input$answer == question$answer
      current_answer(input$answer)
      
      # Correct answer
      if (correct_answer) {
        output$feedback <- shiny::renderText({
          paste("Well done", name, "! Your answer is correct.")
        })
        
        # If correct on first attempt save the question
        if (!(question_index %in% incorrect_questions())) {
          first_try_correct_questions(c(first_try_correct_questions(), question_index))
        }
        # Incorrect question
      } else {
        incorrect_questions(c(incorrect_questions(), question_index))
        incorrect_attempts(incorrect_attempts() + 1)
        
        output$feedback <- shiny::renderText({
          paste("Incorrect. The correct answer is", question$answer, ".")
        })
        
        # When 5 or more mistakes are made
        if (incorrect_attempts() >= 5) {
          output$feedback <- shiny::renderText({
            "Game over! You have made 5 mistakes. Click 'Show Results' to see how you did."
          })
          shiny::updateActionButton(session, "next_question", disabled = TRUE)
          shiny::updateActionButton(session, "submit", disabled = TRUE)
          shinyjs::disable("answer")
          game_over(TRUE) # End the game by setting current question to NULL
        }
      }
      
      # Disable 'Submit' button and Next Question' button 
      shiny::updateActionButton(session, "submit", disabled = TRUE)
      shiny::updateActionButton(session, "next_question", disabled = FALSE)
    })
    
    # Generate next question when 'Next question' button is clicked
    shiny::observeEvent(input$next_question, {
      shiny::req(input$next_question)
      
      question <- current_question()
      correct_answer <- current_answer() == question$answer
      
      if (correct_answer) {
        question_index <- which(questions()$text == question$text)
        correct_questions(c(correct_questions(), question_index))
      }
      
      current_attempt(current_attempt() + 1)
      
      output$feedback <- shiny::renderText({
        NULL
      })
      
      # Reset feedback and answer input
      shiny::updateNumericInput(session, "answer", value = NA)
      shiny::updateActionButton(session, "next_question", disabled = TRUE)
      
      # Make submit button available again
      shiny::updateActionButton(session, "submit", disabled = FALSE)

      # Disable 'Next question' button after all questions are completed
      question <- current_question()
      
      if (is.null(question)) {
        output$feedback <- shiny::renderText({
          "You completed the quiz! Click 'Show Results' to see your results below."
        })
      }
    })
    
    # Call calculator function when 'Calculator' is clicked
    calculator(input, output)
    
    # Show grade information modal when 'i' button is clicked
    shiny::observeEvent(input$show_grade_info, {
      shiny::showModal(
        shiny::modalDialog(
          title = "Grade Information",
          shiny::p("Not sure what grade to choose to embark on the right adventure?"),
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
    
    # Update progress/health bar so it decreases with each correctly answered question
    shiny::observe({
      incorrect_answers <- question_count - length(correct_questions())
      progress_value <- incorrect_answers / question_count * 100
      shinyWidgets::updateProgressBar(session, "progress", value = progress_value)
      
      if (progress_value == 0) {
        shinyjs::runjs('$("#monster_image").attr("src", "/static/slain_monster.png");')
    } else {
      shinyjs::runjs('$("#monster_image").attr("src", "/static/monster.png");')
    }
  })
  
    # Plot overall score and score by operator when 'Result' button is clicked
    shiny::observeEvent(input$plot_result, {
      
      # Calculate overall score
      overall_score <- length(first_try_correct_questions()) / question_count * 100
      
      # Calculate score by operator
      operators <- c("+", "-", "*", "/")
      scores <- numeric(length(operators))
      for (i in seq_along(operators)) {
        operator_questions <- questions()[grepl(paste("\\", operators[i], sep=""), questions()$text), ]
        
        # Skip calculation if no questions available for the operator
        if (nrow(operator_questions) == 0) {
          next
        }
        
        # Operator correct
        operator_correct <- first_try_correct_questions()[first_try_correct_questions() %in% which(grepl(paste("\\", operators[i], sep=""), questions()$text))]
        # Percentage correct per operator
        scores[i] <- length(operator_correct) / nrow(operator_questions) * 100
      }
      
      # Create combined data frame for plotting
      plot_data <- data.frame(
        category = c("Overall", operators),
        score = c(overall_score, scores)
      )
      
      # Plot overall score and score by operator
      output$combined_plot <- shiny::renderPlot({
        ggplot2::ggplot(plot_data, aes(x = category, y = score, fill = category)) +
          ggplot2::geom_bar(stat = "identity", position = "dodge") +
          ggplot2::labs(title = "Overall and Operator Scores", y = "% Correct") +
          ggplot2::theme_minimal() +
          ggplot2::scale_fill_manual(values = c("Overall" = "#005AFD", "+" = "#FF1093", "-" = "#50C878", "*" = "#5C01BC", "/" = "#FFCF02")) +
          ggplot2::geom_text(aes(label = round(score, 1)), vjust = -0.5, size = 5) +
          ggplot2::theme(
            panel.background = element_rect(fill = "#FFA07b", color = NA),          # Plot background
            plot.background = element_rect(fill = "#FFA07b", color = NA),           # Outer plot background
            legend.background = element_rect(fill = "#FFA07b"),                     # Legend background
            legend.box.background = element_rect(fill = "#FFA07b"),                 # Legend box background
            panel.grid.major = element_blank(),                                     # Remove major grid lines
            panel.grid.minor = element_blank(),                                     # Remove minor grid lines
            axis.line = element_line(color = "black"),                              # Axis lines
            axis.text = element_text(size = 16, color = "black"),                   # Font size for axis text
            axis.title.x = element_text(size = 14, color = "black", face = "bold"), # Font size for x-axis title
            axis.title.y = element_text(size = 14, color = "black", face = "bold"), # Font size for y-axis title
            plot.title = element_text(size = 20, face = "bold", hjust = 0.5)        # Title size, bold, and centered
            )
      }, bg = "transparent")
  })
  }
}

# Libraries needed to run the Shiny app
library(shiny)
library(shinyWidgets)

# Sourcing the functions needed
source("R/server.R")
source("R/ui.R")

########################### Shiny Math Quest app ###########################

# Function to run the application
#' @title runMathQuest
#' 
#' @description Math Quest is a fun and playful quiz app that allows elementary school children (grade 4 through grade 8) to practice different parts of math, such as addition, subtraction, multiplication, and division. The app generates math questions adapted to the selected school grade level. The application incorporates gamification and learning strategies to promote and make learning more fun for students and optimize their enjoyment to achieve the best results.
#'
#' @usage runMathQuest(name, question_count)  
#' @param name string. A string containing a name to personalize the UI input.
#' @param question_count numeric. Number of questions the user wants the quiz to contain.
#' 
#' @examples
#' # Run Math Quest quiz with 15 questions
#' runMathQuest(name = "Bruny", question_count = 15)
#' 
#' # Run Math Quest quiz with 25 questions and different name
#' runMathQuest(name = "Ruben", question_count = 25)
#' 
#' 
#' @export
runMathQuest <- function(name, question_count) {
  shiny::shinyApp(ui = ui, 
                  server = create_server(question_count, name))
}

# Run app
runMathQuest(name = "Bruny", question_count = 2)


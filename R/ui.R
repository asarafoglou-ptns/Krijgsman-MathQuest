# Adding resource path for images
shiny::addResourcePath("static", "R/www")

# Define UI for application
ui <- shiny::fluidPage(
  shiny::tags$head(
    shiny::tags$style(
      shiny::HTML(
        "
        /* Add orange box around instructions */
        .instruction_box {
          padding: 10px;
          background-color: #FFA07b;
          color: #000000;
          border-radius: 10px;
          display: inline-block;
          text-align: left;
        }
        /* Add orange box to select grade */
        .grade_box {
          padding: 10px;
          background-color: #FFA07b;
          color: #000000;
          border-radius: 10px;
          display: inline-block;
          text-align: left;
        }
        /* Add info icon next to select button */
        .grade_info_icon {
          cursor: pointer;
          margin-left: 5px;
          color: blue;
        }
        /* Add extra space between rows */
        .row_spacing {
          margin-bottom: 20px;
        }
        /* Set background color */
        body {
          background-color: #C3E0EA;
        }
        /* Style modal dialog */
        .modal-content {
          color: #000000;
          border-radius: 10px;
        }
        /* Set color for modal header and footer */
        .modal-header, .modal-footer {
          background-color: #FFA07b;
        }
        /* Set color for modal body */
        .modal-body {
          background-color: #C3E0EA; 
        }

        /* Style input fields */
        .numeric-input, .select-input, .text-output {
          margin-bottom: 15px;
        }
        
        /* Change the background color behind the progress bar */
        .progress {
        background-color: #FF3333;
        }

        /* Change the color of the progress bar */
        .progress-bar {
          background-color: #9AF764;
        }
        
        /* Change font size and position of question and answer */
        .question {
          font-size: 24px;
          font-weight: bold;
          margin-top: 20px;
        }
        "
      )
    )
  ),
  
  # Include shinyjs
  shinyjs::useShinyjs(),
  
  # Application title panel contains fluid row to add images to the header
  shiny::titlePanel(
    shiny::div(
      shiny::fluidRow(
        shiny::column(2, shiny::img(src = "/static/header1.png", height = 120, width = 160)),
        shiny::column(8, shiny::h1(shiny::tags$b("Math Quest"), align = "center")),
        shiny::column(2, shiny::img(src = "/static/header2.png", height = 120, width = 160))
      )
    )
  ),
  
  # Add absolute panel to display monster image in the right-bottom of the page
  shiny::absolutePanel(
    bottom = "10px",
    right = "20px",
    shiny::img(id = "monster_image", src = "/static/monster.png", height = 500, width = 350)
  ),
  
  shiny::fluidRow(
    shiny::column(width = 4,
                  shiny::div(
                    class = "instruction_box",
                    shiny::h3("Instructions"),
                    shiny::p("Welcome to Math Quest,", shiny::textOutput("name", inline = TRUE), "!"),
                    shiny::p("1. Please choose your", shiny::tags$b('grade'), "to start your adventure."),
                    shiny::p("2. Solve the math problems you encounter to defeat the monster."),
                    shiny::p("3. Each correct answer brings you closer to victory."),
                    shiny::p("4. Enter your answer and hit", shiny::tags$b('Submit'), "."),
                    shiny::p("5. Click on the", shiny::tags$b('Calculator'), "to open it if needed."),
                    shiny::p("6. Progress your quest by clicking", shiny::tags$b('Next Question'),"."),
                    shiny::p("7. Check your results by clicking", shiny::tags$b('Plot'),"."),
                    shiny::p("Are you ready to conquer the Math Quest? Good luck!"),
                    shiny::br()
                  )
    ),
    
    shiny::column(width = 4,
                  shiny::div(
                    shiny::conditionalPanel(
                      condition = "output.finished == 'FALSE'",
                      shiny::div(class = "question", shiny::textOutput("question")),
                      shiny::numericInput("answer", label = shiny::tags$div("Enter your answer:"), value = NULL),
                      shiny::actionButton("submit", "Submit"),
                      shiny::div(class = "row_spacing")
                    ),
                    shiny::textOutput("feedback"),
                    shiny::div(class = "row_spacing"),
                    conditionalPanel(
                      condition = "output.finished == 'FALSE'",
                      actionButton("next_question", "Next Question", disabled = TRUE)
                    ),
                    conditionalPanel(
                      condition = "output.finished == 'TRUE'",
                      actionButton("plot_result", "Plot")
                    ),
                    shiny::br()
                  )
    ),
    
    # Third column to display the progress bar above the monster image
    shiny::column(width = 4,
                  shinyWidgets::progressBar(id = "progress", value = 0))
  ),
  
  shiny::fluidRow(
    shiny::div(class = "row_spacing"),
    shiny::column(width = 6,
                  shiny::div(class = "grade_box",
                             shiny::selectInput("grade", "Select your grade:",
                                                choices = c("Second grade",
                                                            "Third grade",
                                                            "Fourth grade",
                                                            "Fifth grade",
                                                            "Sixth grade"),
                                                selected = "Second grade"),
                             shiny::actionButton("select", "Select"),
                             
                             shiny::actionButton("show_grade_info", icon("info-circle"), style = "color:blue;"),
                             shiny::br()
                  )
    )
  ),
  
  shiny::fluidRow(
    shiny::div(class = "row_spacing"),
    shiny::column(width = 6,
                  shiny::actionButton("calculator_button", "Calculator")
    )
  ),
  
  # Row with columns for plots
  shiny::fluidRow(
    shiny::column(width = 6, plotOutput("score_plot")),
    shiny::column(width = 6, plotOutput("operator_plot"))
  )
)
  
# Adding resource path for images
shiny::addResourcePath("static", "R/www")

# Define UI for application
ui <- shiny::fluidPage(
  shiny::tags$head(
    # Make changes to the UI with CSS:
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
        border-radius: 10px.
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
        margin-bottom: 15px.
      }

      /* Change the color of the progress bar */
      .progress-bar {
        background-color: #EDC8FF;
      }
  "
      )
    ), ),
  
  # Application title panel contains fluid row to add images to the header
  shiny::titlePanel(shiny::div(
    shiny::fluidRow(
      shiny::column(2, shiny::img(src = "/static/header1.png", height = 120,width = 160)),
      shiny::column(8, shiny::h1(shiny::tags$b("Math Quest"), align = "center")),
      shiny::column(2, shiny::img(src = "/static/header2.png", height = 120, width = 160))
    )
  )),
  
  # Main UI layout with input and output definitions
  # First row
  shiny::fluidRow(
    # First column with instructions
    shiny::column(width = 6,
                  shiny::div(
                    class = "instruction_box",
                    shiny::h3("Instructions"),
                    shiny::p("Welcome to Math Quest,", shiny::textOutput("name", inline = TRUE), "!"),
                    shiny::p("1. Please choose your", shiny::tags$b('grade'), "to start your adventure."),
                    shiny::p("2. Solve the math problems you encounter."),
                    shiny::p("3. Enter your answer and hit", shiny::tags$b('Submit'), "."),
                    shiny::p("4. Click on the", shiny::tags$b('Calculator'), "to open it if needed."),
                    shiny::p("5. Progress your quest by clicking", shiny::tags$b('Next Question'),"."),
                    shiny::p("6. Check your results after 15 questions by clicking", shiny::tags$b('Plot'),"."),
                    shiny::p("Are you ready to conquer the Math Quest? Good luck!"),
                    shiny::br()
                  )
    ),
    
    # Second column with progress bar + question + answer field + submit button
    shiny::column(width = 4,
                  shinyWidgets::progressBar(id = "progress", value = 0),
                  shiny::textOutput("question"),
                  shiny::numericInput("answer", "Enter your answer:", value = NULL),
                  shiny::actionButton("submit", "Submit"),
                  shiny::br()
    )
  ),
  
  # Second row
  shiny::fluidRow(
    # Adding extra space between the two rows
    shiny::div(class = "row_spacing"),
    # First column with select input + select button + info icon
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
                             
                             # 'i' button to show grade information
                             shiny::actionButton("show_grade_info", icon("info-circle"), style = "color:blue;"),
                             shiny::br()
                  )
    ),
    
    # Second column with feedback and next question button
    shiny::column(width = 6,
                  shiny::textOutput("feedback"),
                  shiny::actionButton("next_question", "Next question", disabled = TRUE),
                  shiny::br()
    ),
  ),
  
  # Third row with calculator button
  shiny::fluidRow(
    # Adding extra space between the two rows
    shiny::div(class = "row_spacing"),
    shiny::column(width = 6,
                  shiny::actionButton("calculator_button", "Calculator")
    )
  )
)
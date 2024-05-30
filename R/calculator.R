# Calculator function that appears when the action button 'Calculator' is clicked.
# It takes 2 numbers and a operator and outputs the result.

calculator <- function(input, output) {
  
  # Open calculator modal
  shiny::observeEvent(input$calculator_button, {
    shiny::showModal(
      shiny::modalDialog(
        title = "Calculator",
          shiny::fluidRow(
            # Create two columns to display the calculator input and the image next to each other
            shiny::column(6,
              shiny::div(
                style = "display: flex; flex-direction: column; align-items: center;",
                shiny::numericInput("num1_calc", "Number 1:", value = NULL),
                shiny::selectInput("operator_calc", "Operator:",
                             choices = c("+", "-", "*", "/")),
                shiny::numericInput("num2_calc", "Number 2:", value = NULL),
                shiny::textOutput("calc_result"))),
            
            # Add image
            shiny::column(6,
              shiny::img(src = "www/calculator.png", height = "200px", width = "160px"))
            ),
        
        # Action buttons in the footer
        footer = shiny::tagList(
              shiny::actionButton("calculate", "Calculate"),
              shiny::actionButton("close_calculator", "Close")
        ),
        
        easyClose = TRUE
      )
    )
  })
  
  # Perform calculation and display result
  shiny::observeEvent(input$calculate, {
    shiny::req(input$num1_calc, input$num2_calc, input$operator_calc)
    result <- switch(input$operator_calc,
                     "+" = input$num1_calc + input$num2_calc,
                     "-" = input$num1_calc - input$num2_calc,
                     "*" = input$num1_calc * input$num2_calc,
                     "/" = input$num1_calc / input$num2_calc)
    
    # Output result
    output$calc_result <- shiny::renderText({
      paste("Result:", result)
    })
  })
  
  # Close calculator modal
  shiny::observeEvent(input$close_calculator, {
    # Remove the result output
    output$calc_result <- NULL
    shiny::removeModal()
  })
}

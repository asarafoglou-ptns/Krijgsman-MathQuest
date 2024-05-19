observeCalculator <- function(input, output) {
  # Open calculator modal
  shiny::observeEvent(input$calculator_button, {
    shiny::showModal(
      shiny::modalDialog(
        title = "Calculator",
        shiny::div(
          style = "display: flex; flex-direction: column;",
          shiny::numericInput("num1_calc", "Number 1:", value = NULL),
          shiny::selectInput(
            "operator_calc",
            "Operator:",
            choices = c("+", "-", "*", "/")
          ),
          shiny::numericInput("num2_calc", "Number 2:", value = NULL),
          shiny::textOutput("calc_result")
        ),
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
    result <- switch(
      input$operator_calc,
      "+" = input$num1_calc + input$num2_calc,
      "-" = input$num1_calc - input$num2_calc,
      "*" = input$num1_calc * input$num2_calc,
      "/" = input$num1_calc / input$num2_calc
    )
    output$calc_result <- shiny::renderText({
      paste("Result:", result)
    })
  })
  
  # Close calculator modal
  shiny::observeEvent(input$close_calculator, {
    shiny::removeModal()
  })
}
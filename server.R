#########################
# LIBRARIES
library(shiny)



#########################
# THE SHINY SERVER

shinyServer(
    function(input, output) {

        # all three UI data elements use the same "plotting" function, with
        # the same parameters, but take advantage of different return values.
        # I put "plotting function" in parenthesis, because the function computes
        # several statistical metrics, as well as outputting a plot. The stats
        # are returned in a list.

        # Defining the pac() function as a shortcut, syntactic suger, to the
        # main global function, along with all parameters pre-specified, makes
        # code maintenance simpler given that all three elements use the
        # exact same function and parameters, but select a different return value.

        pac <- function() {  plot_and_computation(   data = fbdf,
                                                     yvar = {input$measurement},
                                                     xvar = {input$feature},
                                                     taster = {input$taster}
                                                 )
                          }

        # the main plot
        output$plot1 <- renderPlot({ pac() }, width = 410)  # no return value used, just renders the output of the base R plot() function

        # stats table
        output$stats1 <- renderTable({ pac()$stats }, include.rownames = FALSE)

        # rawdata table
        output$rawdata1 <- renderTable({ pac()$rawdata }, include.rownames = TRUE)
    }
)

# beware of where the uiOutput() is written, i.e. it's inside the Layout, not mainPanel
# also, the radioButtons() is written within the server, not ui
# see https://www.r-bloggers.com/tutorial-build-webapp-in-r-using-shiny/amp/#top

### Conditional Panel : Example 2 ###

# In the following example we are using the income.csv file. Firstly we ask for which variable the user wants to work with and save the data in ‘a’ using reactive( ). 
# Then we using **uiOutput** we insert a widget asking for whether the user wants the summary or to view the data or the histogram. 
# Based on the option selected by the user we create **conditional panels** for summary, viewing the data and plotting the histogram.

library(shiny)

income = read.csv("income.csv", stringsAsFactors = FALSE)

ui = fluidPage(titlePanel(em("Conditional panels")),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      "Choice1",
                      "Select the variable",
                      choices = colnames(income)[3:16],
                      selected = "Y2008"
                    ),
                    uiOutput("Out1")
                  ),
                  mainPanel(
                    conditionalPanel("input.Choice2 === 'Summary'", verbatimTextOutput("Out2")),
                    conditionalPanel("input.Choice2 === 'View data'", tableOutput("Out3")),
                    conditionalPanel("input.Choice2 === 'Histogram'", plotOutput("Out4"))
                  )
                ))

server = function(input, output) {
  a = reactive({
    income[, colnames(income) == input$Choice1]
  })
  output$Out1 = renderUI({
    radioButtons(
      "Choice2",
      "What do you want to do?",
      choices = c("Summary", "View data", "Histogram"),
      selected = "Summary"
    )
  })
  output$Out2 = renderPrint({
    summary(a())
  })
  output$Out3 = renderTable({
    return(a())
  })
  output$Out4 = renderPlot({
    return(hist(a(), main  = "Histogram", xlab = input$Choice1))
  })
}
shinyApp(ui = ui, server = server)
# Uploading a file
# https://www.r-bloggers.com/tutorial-build-webapp-in-r-using-shiny/amp/#top

# In order to allow the users to upload their own datasets and do the analysis on them, **fileInput** function in UI in shiny allows users to upload their own file. 
# In **fileInput** ‘multiple = F’ denotes that only one file can be uploaded by the user and ‘accept = csv’ denotes the type of files which can be uploaded. 
# Then we ask the user whether he wants to view the head of the data or the entire dataset which is then viewed by using renderTable.

# beware of **req**, **$datapath** in the server

library(shiny)

ui = fluidPage(titlePanel("Uploading file in Shiny"),
                sidebarLayout(
                  sidebarPanel(
                    fileInput(
                      "myfile",
                      "Choose CSV File",
                      multiple = F,
                      accept = ".csv"
                    ),

                    checkboxInput("header", "Header", TRUE),

                    radioButtons(
                      "choice",
                      "Display",
                      choices = c(Head = "head",
                                  All = "all"),
                      selected = "head"
                    )
                  ),

                  mainPanel(tableOutput("contents"))

                ))

server = function(input, output) {
  output$contents = renderTable({
    req(input$myfile)

    data = read.csv(input$myfile$datapath,
                     header = input$header)

    if (input$choice == "head") {
      return(head(data))
    }
    else {
      return(data)
    }

  })
}

shinyApp(ui, server)
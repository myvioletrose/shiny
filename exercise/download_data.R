# Downloading Data
# https://www.r-bloggers.com/tutorial-build-webapp-in-r-using-shiny/amp/#top

# shiny allows the users to download the datasets. 
# This can be done by using **downloadButton in UI** and **downloadHandler in server**.
# Firstly we select the data using radioButtons and hence save the dataset using reactive( ) in server. 
# Then in the UI we create a **downloadButton** where the first argument is the inputID and the other one is the label. 
# **downloadHandler** needs two arguments: filename and content. 
# In ‘filename’ we specify by which name the file should be saved and using content we write the dataset into a csv file.

library(shiny)

ui =  fluidPage(titlePanel("Downloading the data"),
                sidebarLayout(sidebarPanel(
                  radioButtons(
                    "data",
                    "Choose a dataset to be downloaded",
                    choices = list("airquality", "iris", "sleep"),
                    selected = "airquality"
                  ),
                  downloadButton("down", label = "Download the data.")
                ),
                mainPanel()))

server = function(input, output) {

  # Reactive value for selected dataset ----
  datasetInput = reactive({
    switch(input$data,
           "airquality" = airquality,
           "iris" = iris,
           "sleep" = sleep)
  })

  # Downloadable csv of selected dataset ----
  output$down = downloadHandler(
    filename = function() {
      paste(input$data, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )

}
shinyApp(ui, server)
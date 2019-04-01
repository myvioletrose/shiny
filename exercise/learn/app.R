setwd("C:/Users/traveler/Desktop/Jim/# R/# analytics/shiny")
# watch: https://vimeo.com/rstudioinc/review/131218530/212d8a5a7a/#t=42m2s

if(!require(shiny)) {install.packages("shiny"); require(shiny)}
# HOW TO SAVE YOUR APP
# one directory with every file the app needs:
# app.R (your script which ends with a call to shinyApp())
# datasets, images, css, helper scripts, etc.
# YOU MUST USE THIS EXACT NAME (app.R); otherwise, shiny server will not recognize the script when building an app!!
# if the script is too long, you can save ui and server parts separatedly (without calling shinyApp() inside the scripts), i.e. ui.R, server.R 

###############################################################################
### build user interface - reactive inputs, outputs
ui <- fluidPage(
        sliderInput(inputId = "num",  # the inputId is very important and case sensitive
                    label = "Choose a number", 
                    value = 25, min = 1, max = 100),
        plotOutput(outputId = "hist"),
        verbatimTextOutput("stats")
        )


###############################################################################
### use the server function to assemble inputs into outputs
## create reactivity by using INPUTS to build RENDERED OUTPUTS
# rule 1: save objects to display to output$
# rule 2: build objects to display with render*()
# rule 3: use input values with input$

###################################################
################ Reactive toolkit ################
########### 6 indispensible functions ###########
###################################################

# (1) display output with render*() functions - inside the code, begin and end with {}
# (2) modularize code with reactive() - build a reactive object (reactive expression) # reactive() is actually like function, i.e. you need to call a reactive expression like a function; in addition, reactive expressions cache their values
# (3) prevent reactions with isolate(), e.g. isolate({ rnorm(input$num) })  # object will not respond to any reactive value in the code  # use isolate() to treat reactive values like normal R values
# (4) trigger code with observeEvent(), e.g. trigger code to run on server, e.g. download file, write file, save file, etc.  # check out actionButton(), observerEvent(), observe(), etc.
# (5) delay reactions with eventReactive(), e.g. a reactive expression that only responds to specific values
# (6) manage state with reactiveValues() - create a list of reactive values to manipulate programmatically  # you can usually manipulate these values with observeEvent()

# tips: code outside the server function will be run once per R session (worker), whereas code inside the server function will be run once per end user (connection). Therefore, be aware of the code put inside the reactive functions, e.g. code can be run 100 times in a min in response to any trigger

server <- function(input, output) {
        data <- reactive({ 
                rnorm(input$num)
        })  # rebuild a reactive object here
        
        output$hist <- renderPlot({
                title <- "random normal values"
                hist(data(), main = title)  # call the reactive object here
        })
        
        output$stats <- renderPrint({
                summary(data())  # call the reactive object here
        })
}


###############################################################################
# Shinyapps.io - it is a free server built and maintained by RStudio; on the other hand, you can use Shiny Server (or Shiny Server Pro for commerical use) to build your own server to host the app. It is a back end program that builds a linux web server specifically designed to host Shiny apps. Shiny Server is free and open-source
# Shinyapps.io - a server maintained by RStudio RStudio 
# free / easy to use / secure / scalable 
# account sign up
# go to shinyapps.io and then sign up

# # step 1: install and run rsconnect
# if(!require(rsconnect)) {install.packages("rsconnect"); require(rsconnect)}
# 
# 
# # step 2: authorize account
# rsconnect::setAccountInfo(name='myvioletrose',
#                           token='132A8217EE670A676D2182BD5EDC21DE',
#                           secret='Ns4Iyah9htlc0oMkrVUBniCI6tR8CIY+U4UdRLXH')
#
# # step 3: deploy
# # rsconnect::deployApp('path/to/your/app')
# # rsconnect::deployApp("C:/Users/traveler/Desktop/Jim/R/shiny")

###
shinyApp(ui = ui, server = server)







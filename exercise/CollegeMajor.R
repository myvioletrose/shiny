library(shiny)
library(tidyverse)
library(ggrepel)

# load file for data set 2
data2_url <- "https://raw.githubusercontent.com/myvioletrose/school_of_professional_studies/master/607.%20Data%20Acquisition%20and%20Management/Projects/Project2/data/grad-students.csv"

data2 <- data2_url %>% RCurl::getURL(.) %>% textConnection(.) %>% 
        read.csv(., stringsAsFactors = F, header = T)

# let's just extract, tidy several important columns to look at
d2Tidy <- data2 %>%
        dplyr::select(Major, Major_category, Grad_unemployment_rate, Grad_median) %>%
        tidyr::gather(., kpi, value, -c(Major, Major_category)) %>%
        dplyr::mutate(kpi = dplyr::case_when(kpi == "Grad_unemployment_rate" ~ "unemployment rate",
                                             kpi == "Grad_median" ~ "median salary"))
# split
d2Split <- d2Tidy %>% tidyr::spread(., kpi, value) %>% split(., .$Major_category)
assign_global_vars <- purrr::map2(letters[1:length(d2Split)], 1:length(d2Split), 
                                  function(x, y) {assign(x, d2Split[[y]], envir = .GlobalEnv)})

# list2env(d2Split, envir= .GlobalEnv)

# Define UI for miles per gallon app ----
ui <- fluidPage(
        
        # App title ----
        titlePanel("College Major Category"),
        
        # Sidebar layout with input and output definitions ----
        sidebarLayout(
                
                # Sidebar panel for inputs ----
                sidebarPanel(
                        
                        # Input: Selector for variable to plot ----
                        selectInput("category", 
                                    "Category:",
                                    c(names(d2Split))
                        )
                        
                ),
                
                # Main panel for displaying outputs ----
                mainPanel(
                        
                        # Output: Plot of the requested variable ----
                        plotOutput("salaryPlot"),
                        tableOutput("salary")
                        
                )
        )
)

# Define server logic to plot various variables ----
server <- function(input, output) {
        
        datasetInput <- reactive({
                switch(input$category,
                       'Agriculture & Natural Resources' = a,
                       'Arts' = b,
                       'Biology & Life Science' = c,
                       'Business' = d,
                       'Communications & Journalism' = e,
                       'Computers & Mathematics' = f,
                       'Education' = g,
                       'Engineering' = h,
                       'Health' = i,
                       'Humanities & Liberal Arts' = j,
                       'Industrial Arts & Consumer Services' = k,
                       'Interdisciplinary' = l,
                       'Law & Public Policy' = m,
                       'Physical Sciences' = n,
                       'Psychology & Social Work' = o,
                       'Social Science' = p
                       )
        })
        
        
        # Generate a plot of the requested variable ----
        output$salaryPlot <- renderPlot({

                ggplot(datasetInput(),
                       aes(x = reorder(Major, `median salary`), y = `median salary`)) +
                        labs(x = "College Major", y = "Median Salary ($)") +
                        # labs(x = "", y = "Median Salary ($)") +
                        geom_point(stat = "identity", color = "grey",
                                   aes(fill = factor(`median salary`))) +
                        coord_flip() +
                        geom_label_repel(aes(Major, `median salary`, fill = factor(`median salary`),
                                             # size = `unemployment rate`
                                             label = Major),
                                         size = 3, fontface = 'bold', color = 'white',
                                         box.padding = unit(0.1, "lines"),
                                         point.padding = unit(0.1, "lines"),
                                         segment.color = 'grey50', segment.size = 5,
                                         force = 2) +
                        geom_text_repel(aes(label = `median salary`),
                                # label = ifelse(`median salary` > median(`median salary`), `median salary`, '')),
                                        size = 4, color = 'red',
                                        force = 10) +
                        theme(legend.position = "none",
                              axis.text.x = element_text(angle = 30, hjust = 1),
                              plot.title = element_text(hjust = 0.5)) +
                        ggtitle(input$category)

        })
        
        # print table output
        output$salary <- renderTable({
                datasetInput() %>% dplyr::select(-Major_category) %>%
                        dplyr::mutate(`median salary` = round(`median salary`, 0),
                                      `unemployment rate` = round(`unemployment rate`, 4)) %>%
                        dplyr::arrange(desc(`median salary`))
        })
        
}

# Create Shiny app ----
shinyApp(ui, server)





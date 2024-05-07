if (!require("shiny")) install.packages("shiny")
if (!require("ggplot2")) install.packages("ggplot2")

# Load necessary libraries
library(shiny)
library(ggplot2)

# Define UI for application
ui <- fluidPage(
  titlePanel("Car Data Visualization"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      selectInput("variable", "Variable to visualize:", 
                  choices = c("Fueltype", "Category", "Gearboxtype")),
      actionButton("goButton", "Go")
    ),
    mainPanel(
      plotOutput("pieChart")
    )
  )
)

# Define server logic 
server <- function(input, output) {
  output$pieChart <- renderPlot({
    # Check if a file has been uploaded
    if (is.null(input$file)) return(NULL)
    
    # Load the uploaded CSV file
    car_data <- read.csv(input$file$datapath)
    
    # Depending on input, visualize different variables
    if (input$goButton > 0) {
      # Calculate percentages
      data <- table(car_data[[input$variable]])
      data <- prop.table(data)
      
      # Create pie chart with labels
      pie(data, main = paste("Percentage of Different", input$variable, "Types"), 
          col = rainbow(length(data)), 
          labels = paste(names(data), ": ", round(data*100, 1), "%"))
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


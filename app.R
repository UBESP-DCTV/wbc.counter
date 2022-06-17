#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
library(shinydashboard)

# Define UI ----
ui <- fluidPage(
  
    titlePanel("Field passive ASF surveillance data"),

    # use a gradient in background
    setBackgroundColor(
      color = c("#F7FBFF", "#2171B5"),
      gradient = "linear",
      direction = "bottom"
    ),  
    tags$head(tags$style('h3 {color: #2171B5}')),
    tags$head(tags$style('h1 {color: #2171B5}')),
    
  #  p('paragraph, with some ', strong('bold'), ' text.'),
    p('African swine fever (ASF) is a devastating disease resulting in high mortality in domestic
    and wild pigs, spreading fast around the world. Implementation based on EFSA opinion 2021 on Exit Strategy.'),
  
    fluidRow(

    column(9, 
       column(3, numericInput("wb_dens", 
                    h3("Wild boar density"),
                    min=0,
                    value = 1)),
      
             column(3, numericInput("area", 
                                    h3("Area"), 
                                    min=0,
                                    value = 1)),
             column(3, 
                    h3("___"),
                    helpText("Density and Area ...."))
      )),
    
    fluidRow(          
    
      column(9,
        column(3, numericInput("scr", 
                    h3("Screening phase (months)"), 
                    min=0,
                    value = 1)),
        column(3, numericInput("conf_1", 
                    h3("Confirmatory phase 1 (months)"), 
                    min=0,
                    value = 1)),
        column(3, numericInput("conf_2", 
                               h3("Confirmatory phase 2 (months)"), 
                               value = 1)),
        
        column(3,
                  h3("___"),
                  helpText("Note: help text"))
      )),
      
    hr(),
    fluidRow(     
               column(8, offset = 1, uiOutput("exit")), 
              column(8, offset = 1,
                  tags$div(class="header", checked=NA,
#                  tags$h4("Link to the reference paper:"),
                  tags$a(href="https://efsa.onlinelibrary.wiley.com/doi/10.2903/j.efsa.2021.6419",
                         "Link to the reference paper: click here!")
    ))),
    
    

    )




# Define server logic ----
server <- function(input, output) {
  output$exit=renderUI({
    
    n_wb = input$wb_dens*1000 #numero cinghiali per 1000km2
    wb_hrate = 0.9 #tasso di mortalit da caccia 90%
    wb_drate = 0.1 #tasso di mortalit naturale 10%
    n_wbh = n_wb*wb_hrate #numero di cinghiali morti per caccia/1000 km2
    n_dwb = n_wb*wb_drate #numero cinghiali morti per cause naturali/1000 km2
    p_found = 0.01 #p(trovare le carcasse)=1%
    
    n_found = n_dwb*p_found 
    
    n_found_space <- (input$area*n_found)/1000 #proporzione del numero di carcasse per i km2
    n_found_scr <- (input$scr*n_found_space)/12 #proporzione del numero di carcasse per la fase di screening
    n_found_conf1 <- (input$conf_1*(n_found_space*2))/12 #proporzione del numero di carcasse per la fase di conferma 9 mesi
    n_found_conf2 <- (input$conf_2*(n_found_space*2))/12 #proporzione del numero di carcasse per la fase di conferma 14 mesi
    
    nwbS_IA <- n_dwb*(input$area/1000) #dead wb in infected area/year
    n_carcas_IA <- nwbS_IA*wb_drate
    s1 <- (n_found_scr+n_found_conf1)/n_carcas_IA #35%
    s2 <- (n_found_scr+n_found_conf2)/n_carcas_IA #43%
    
    
    
    
    HTML(paste("&nbsp;&nbsp;&nbsp;&nbsp;<b>N found:</b>", n_found, "<p/>",
               "&nbsp;&nbsp;&nbsp;&nbsp;<b>N found confirmatory 1:</b> ", round(n_found_conf1,5), "<p/>", 
               "&nbsp;&nbsp;&nbsp;&nbsp;<b>N found confirmatory 2:</b> ", round(n_found_conf2,5), "<p/>",
               "&nbsp;&nbsp;&nbsp;&nbsp;<b>Sensitivity of the Surveillance System (s1):</b> ", round(s1,2), "<p/>",
               "&nbsp;&nbsp;&nbsp;&nbsp;<b>Sensitivity of the Surveillance System (s2):</b> ", round(s2,2), "<p/>",
               sep = ""))
    
  }) 
  
  }

# Run the app ----
shinyApp(ui = ui, server = server)
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
  
#    titlePanel("WBC counter"),
  titlePanel(title = span("WBC counter",img(src = "wbclogo.png", height = 35))
),

    # use a gradient in background
    setBackgroundColor(
      color = c("#F7FBFF", "#2171B5"),
      gradient = "linear",
      direction = "bottom"
    ),  
    tags$head(tags$style('h3 {color: #2171B5}')),
    tags$head(tags$style('h1 {color: #2171B5}')),
    tags$head(tags$style('a {color: red}')),
    
    p('African swine fever (ASF) is a devastating disease resulting in high mortality in domestic
    and wild pigs, spreading fast around the world. This tool implements two approaches based
    on EFSA Exit Strategy (2021), aimed to provide robust evidence of the absence of ASF circulation in wild boars (WBs). 
    One approach uses the WB density to estimate the number of carcasses 
      and the second estimates this from the number of WBs hunted and tested.'),
  
    fluidRow(

    column(9, 
           column(3, selectInput("approach", 
                                 h3(div("Approach"),br()),
                                 choices = list("", 
                                                "WB density" = "y", 
                                                "WB hunted" = "n"),
                                 selected = "y")),
           
           column(3, numericInput("wb_dens", 
                    #h3(HTML(paste0("Wild boar density (per km",tags$sup("2"),")"))),  
                    h3(div("Wild boar density"),
                       div(HTML(paste0("(per km",tags$sup("2"),")")))),  
                                min = 0,
                                value = 4)),
      
           column(3, numericInput("n_wbhunt2", 
                    #h3(HTML(paste0("Hunting bag (per 1000 km",tags$sup("2"),")"))),  
                    h3(div("Hunting bag"),div(HTML(paste0("(per 1000 km",tags$sup("2"),")")))),  
                  
                    min = 0, 
                    value = NA)),
           column(3,
                  h3("___"),
                  helpText("Note: choose the most appropriate approach for your country: WB density if sampling is heterogeneous during the hunting season or WB hunted if robust hunting bag data is available and collaboration with hunters is established."))
    )),
       
    
    fluidRow(          
    
      column(9,
        column(3, numericInput("scr", 
                    h3("Screening phase (months)"), 
                    min = 0,
                    value = 9)),

                column(3, numericInput("conf", 
                    h3("Confirmatory phase (months)"), 
                    min = 0,
                    value = 12)),

                column(3, numericInput("area", 
                  # h3(HTML(paste0("Area (km",tags$sup("2"),")"))),  
                   h3(div("Area"),div(HTML(paste0("(km",tags$sup("2"),")")))),  
                   
                                      min = 0,
                   value = 5302)),
        
                column(3, 
                   h3("___"),
                   helpText("Default input values correspond to WB density approach for Sardinia (Italy) data"))
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
    
    if(input$approach == "y") 
  {
    n_wb = input$wb_dens*1000 #n. WBs per 1000 km2
    n_wbhunt1 <- n_wb*0.45 #n. WBs dead during hunt in 1000km2 (45%)
    wb_natd1 <- ((n_wbhunt1*100)/90)*0.1 #n. WBs dead naturally per 1000km2
    p_found <- 0.01 #prob. to find carcasses(1%)
    c_est1 <- wb_natd1*p_found #n. WBC likely to find
    
    #PROPORZIONE SPAZIO/TEMPO
    #rapporto tempo (Screening 24 months, confirmatory 9 months)
    ttime <- input$scr+input$conf
    #rapporto spazio all infected area (5400 km2)
 
    c_est1_space <- (input$area*c_est1)/1000 # n. WBC 
    c_est1_scr <- (input$scr*c_est1_space)/12 #n. WBC screening
    c_est1_conf <- (input$conf*(c_est1_space*2))/12 # n. WBC confirm 
    tc_est1 <- c_est1_scr+c_est1_conf
  
    
    HTML(paste("&nbsp;&nbsp;&nbsp;&nbsp;<b>N. WB carcasses needed in the screening phase:</b> ", round(c_est1_scr), "<p/>", 
               "&nbsp;&nbsp;&nbsp;&nbsp;<b>N. WB carcasses needed in the confirmatory phase:</b> ", round(c_est1_conf), "<p/>",
               sep = ""))
    
  } 
     
  else {
    wb_natd2 <- ((input$n_wbhunt2*100)/90)*0.1 #n. WB dead naturally per 1000km2
    p_found <- 0.01 
    c_est2 <- wb_natd2*p_found #n. WBC in 1 year
  
  #PROPORZIONE SPAZIO/TEMPO
  #rapporto spazio all infected area (5400 km2)
  c_est2_space <- (input$area*c_est2)/1000 # n. WBC 
  c_est2_scr <- (input$scr*c_est2_space)/12 # n. WBC screening
  c_est2_conf <- (input$conf*(c_est2_space*2))/12 # n. WBC confirm 
  tc_est2 <- c_est2_scr+c_est2_conf

    HTML(paste("&nbsp;&nbsp;&nbsp;&nbsp;<b>N. WB carcasses needed in the screening phase:</b> ", round(c_est2_scr), "<p/>", 
               "&nbsp;&nbsp;&nbsp;&nbsp;<b>N. WB carcasses needed in the confirmatory phase:</b> ", round(c_est2_conf), "<p/>",
                sep = ""))
  }
      })
  }

# Run the app ----
shinyApp(ui = ui, server = server)
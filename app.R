library(shiny)
library(dplyr)  
library(RColorBrewer)
library(readr)
library(scales)
library(ggplot2)


# Set options
options(shiny.sanitize.errors = TRUE)

# Source file for Windows
# Sys.setenv(R_GSCMD = "C:\\Program Files\\gs\\gs9.20\\bin\\gswin64c.exe")
#source("https://raw.githubusercontent.com/UrbanInstitute/urban_R_theme/temp-windows/urban_ggplot_theme.R")

# source("urban_institute_themes/urban_theme_windows.R")

# Source file for Mac
source("urban_institute_themes/urban_theme_mac.R")

latoCSS <- "http://fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic"

# Load data and gather data into long form for ggplot2
solvency_measures <- read_csv("data/solvency_measures.csv", 
                              col_types = cols(
                                  calendar.year = col_integer(),
                                  variable = col_character(),
                                  trust.fund.ratio = col_double(),
                                  cost.payroll = col_double(),
                                  income.cost = col_double()
                              )) %>%
  mutate(variable = factor(variable, levels = unique(variable)))

summary <- read_csv("data/summary.csv",
                    col_types = cols(
                      `Option Number` = col_double(),
                       Option = col_character(),
                      `Insolvency Year` = col_character(),
                      `Open Group Unfunded Obligation` = col_character(),
                      `75-Year Actuarial Balance` = col_character()
                    ))

option_text <- read_csv("text/option.csv",
                        col_types = cols(
                          option = col_character(),
                          text = col_character(),
                          oguo1 = col_character(),
                          oguo2 = col_character(),
                          oguo3 = col_character(),
                          insolvency1 = col_character(),
                          insolvency2 = col_character(),
                          insolvency3 = col_character(),
                          actuarial.balance1 = col_character(),
                          actuarial.balance2 = col_character(),
                          actuarial.balance3 = col_character()
                        ))

ui <- fluidPage(

  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = latoCSS)),
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")),
  tags$head(tags$base(target = "_blank")),  
#  tags$head(tags$script(src = "pym.min.js")),
  
  theme = "shiny.css",
  
  fluidRow(
  
    column(12,
           
           p("The Social Security trustees estimate that by the mid-2030s, the 
             system will no longer be able to pay all scheduled benefits. Which 
             reforms should policymakers pursue to help balance the system? Use 
             this interactive to explore how the Social Security trust funds 
             would fare over time under different reforms."),
           
           br()
           )
  ),

  fluidRow(
    column(6, 
      selectInput(inputId = "option", 
        label = "Social Security Reform", 
        choices = c("Scheduled law and payable law" = "NULL",
                    "Bipartisan Policy Center package" = "Bipartisan Policy Center package",
                    "Annual primary insurance amount" = "Annual primary insurance amount",
                    "Basic minimum benefit" = "Basic minimum benefit",
                    "Increase benefits taxation" = "Increase benefits taxation",
                    "Cap spouse benefits" = "Cap spouse benefits",
                    "75% survivor benefit" = "75% survivor benefit",
                    "90% tax max" = "90% tax max",
                    "90% tax max and 13.4% payroll tax" = "90% tax max and 13.4% payroll tax",
                    "Chained-CPI COLA" = "Chained-CPI COLA",
                    "Reduce COLA" = "Reduce COLA",
                    "Cap COLA" = "Cap COLA", 
                    "Increase COLA" = "Increase COLA",
                    "Increase FRA" = "Increase FRA",
                    "Increase FRA & EEA" = "Increase FRA and EEA",
                    "$150,000 tax max" = "$150,000 tax max",
                    "$180,000 tax max" = "$180,000 tax max",
                    "Eliminate the tax max" = "Eliminate the tax max",
                    "13.4% payroll tax" = "13.4% payroll tax",
                    "14.4% payroll tax" = "14.4% payroll tax",
                    "15.4% payroll tax" = "15.4% payroll tax")),
      
      downloadButton('download_data', 'Download charted data'),
    
      br(),
      br(),
      br(),
      
      # Explanation of Social Security Reform
      htmlOutput("text1"),
      htmlOutput("text2"),
      htmlOutput("text3"),
      htmlOutput("text4")),
      
      br(),

    column(6,
           style = "position:relative",
           
           h4("Income-to-cost ratio"),
           plotOutput("plot1",
                      hover = hoverOpts("plot_hover1", delay = 100, delayType = "debounce")),
           uiOutput("hover_info1"))),
  
  fluidRow(
    column(6, 
           style = "position:relative",
           
           h4("Annual cost rate (cost/taxable payroll)"), 
           plotOutput("plot2",
                      hover = hoverOpts("plot_hover2", delay = 100, delayType = "debounce")),
           uiOutput("hover_info2")),
           
    column(6,
           style = "position:relative",
           
           h4("Trust fund ratio"),
           plotOutput("plot3",
                      hover = hoverOpts("plot_hover3", delay = 100, delayType = "debounce")),
           uiOutput("hover_info3"))),
  
  fluidRow(
    column(12,
           h3("Understand the Metrics"),
           HTML("<p><b>Income-to-cost ratio:</b> Measures the adequacy of current Old-Age, Survivors, and Disability Insurance trust fund income to cover current costs and benefits. The ratio is measured as total OASDI income from payroll taxes, taxation of benefits, general fund transfers, and interest divided by the total cost of scheduled OASDI benefits, administrative expenses, Railroad Retirement program benefits, and payments for vocational rehabilitation services for disabled beneficiaries.</p>"),  
           HTML("<p>When the ratio is one, the Social Security Administration spends one dollar for every dollar it collects or earns from interest. When the ratio is above one, the Social Security Administration brings in more money than it spends and the combined OASDI trust fund grows. When the ratio is below one, the Social Security Administration brings in less money than it spends and the combined OASDI trust fund shrinks.</p>"),
           HTML("<p><b>Annual cost rate (cost-to-taxable payroll ratio):</b> The ratio of the total cost of OASDI programs to all taxable earnings in the economy. The ratio is measured as the cost of scheduled OASDI benefits, administrative expenses, Railroad Retirement program benefits, and payments for vocational rehabilitation services for disabled beneficiaries relative to taxable payroll for the year. The ratio is projected to grow in coming years because the baby boomers will increase the number of beneficiaries more quickly than the growth in taxable payroll.</p>"),
           HTML("<p><b>Trust fund ratio:</b> The percentage of a year’s costs that could be covered solely with money from the combined OASDI trust fund. They are the combined OASDI trust fund asset reserves at the beginning of a year expressed as a percentage of the total cost for the year. A positive trust fund ratio means the combined OASDI trust fund was solvent in the previous year.</p>"),
           HTML("<p>Trust fund ratios are also important for assessing the long-term solvency of the combined OASDI trust fund. If the projected trust fund ratio is positive through the 75-year valuation period and is either level or increasing at the end of the period, then the trust fund is “sustainably solvent.”</p>"),
           HTML("<p><b>Insolvency year:</b> The projected year when the combined OASDI trust fund will no longer be able to pay scheduled benefits in full on a timely basis. The combined OASDI trust fund is currently expected to turn insolvent in 2034.</p>"),
           HTML("<p><b>Open group unfunded obligation:</b> A measure of the total shortfall (or surplus) of the OASDI trust fund over a valuation period in present value dollars. It is present value noninterest income over the valuation period and starting trust fund asset reserves, minus the present value total costs of the OASDI program. The measure is in present value dollars because an additional dollar saved or earned in any given year has more time to accrue interest as special public-debt obligations in the combined OASDI trust funds than an additional dollar in a later year.</p>")   
    )
  ),
  
  br(),
  
  fluidRow(
    column(6,
           h3("About the data"),
           HTML("<p>The Urban Institute’s Dynamic Simulation of Income Model (DYNASIM) projects the size and characteristics (such as financial, health, and disability status) 
                of the US population for the next 75 years. Using the best and most recent data available, it helps sort out how profound social, economic, and demographic 
                shifts will likely affect older adults and their retirement as well as taxpayers, business, and government. The model can also show how outcomes would likely 
                evolve under changes to public policies, business practices, or individual behaviors.</p>"),
           HTML("<p><a href='https://www.urban.org/node/65826'>Read the DYNASIM primer</a></p>"),
           HTML("<p><a href='https://www.urban.org/research/publication/dynamic-simulation-income-model-dynasim-overview'>Review the DYNASIM documentation</a></p>"),
           HTML("<p>Questions about DYNASIM? <a href='mailto:retirementpolicy@urban.org' target='_self'>Contact us</a>.</p>")
           
           ),
    column(6,
           h3("Project Credits"),
           HTML("<p><i>This work was funded by the US Department of Labor’s Employee Benefits Security Administration. 
                We are grateful to them and to all our funders, who make it possible for Urban Institute to advance its mission.</i></p> 
                <p><i>The views expressed are those of the authors and should not be attributed to the Urban Institute, its trustees, 
                or its funders. Funders do not determine research findings or the insights and recommendations of our experts. 
                More information on our funding principles is available <a href='https://www.urban.org/support'>here</a>. 
                Read our terms of service <a href='https://www.urban.org/terms-service'>here</a></i>.</p>"),
           
           h5("RESEARCH"),
           HTML("<div class='credit-names'><p><a href='https://www.urban.org/author/karen-e-smith'>Karen Smith</a></p></div>"),
           h5("DESIGN AND DEVELOPMENT"),
           HTML("<div class='credit-names'><p><a href='https://www.urban.org/author/aaron-r-williams'>Aaron Williams</a>, <a href='https://www.urban.org/author/jerry-ta'>Jerry Ta</a>, and <a href='https://www.urban.org/author/benjamin-chartoff'>Ben Chartoff</a></p></div>"),
           h5("EDITING"),
           HTML("<div class='credit-names'><p><a href='https://www.urban.org/author/michael-marazzi'>Michael Marazzi</a></p></div>"),
           h5("WRITING"),
           HTML("<div class='credit-names'><p><a href = 'https://www.urban.org/author/karen-e-smith'>Karen Smith</a> and <a href='https://www.urban.org/author/aaron-r-williams'>Aaron Williams</a></p></div>"),
           
           HTML("Copyright &copy; <a href='https://www.urban.org/'>Urban Institute</a> September 2017. View this project on <a href='https://github.com/urbaninstitute/dynasim-shiny1.git'>GitHub</a>.</p>")
           )
    )
  
#  tags$script(src = "activatePym.js")
)

server <- function(input, output) {

  data_subset <- reactive({
    solvency_measures %>%
      filter(variable == "Scheduled" | variable == "Payable" | variable == input$option)
  })
  
  output$plot1 <- renderPlot({ 
   
    data_subset() %>%
      ggplot(aes(x = calendar.year, y = income.cost, colour = variable)) +
        geom_hline(yintercept = 0) +
        geom_line(size = 1) +
        scale_y_continuous(limits = c(-1, 1.5)) +
        labs(x = NULL,
             y = NULL,
             caption = "DYNASIM3
                        Urban Institute") + 
        theme(plot.margin = margin(t = -5),
              axis.line = element_blank())
    
    })
  
  output$plot2 <- renderPlot({ 
    
    data_subset() %>%
      ggplot(aes(x = calendar.year, y = cost.payroll, colour = variable)) +
        geom_line(size = 1) +
        scale_y_continuous(limits = c(0, 0.31), expand = c(0, 0)) +
        labs(caption = "DYNASIM3
                        Urban Institute",
             x = NULL,
             y = NULL) + 
        theme(plot.margin = margin(t = -5))
    
  })
  
  output$plot3 <- renderPlot({ 

    data_subset() %>%
      ggplot(aes(x = calendar.year, y = trust.fund.ratio, colour = variable)) +
        geom_hline(yintercept = 0) +
        geom_line(size = 1) +
        labs(caption = "DYNASIM3
                        Urban Institute",
             x = NULL,
             y = NULL) + 
        scale_y_continuous(limits = c(-20, 5), labels = scales::percent) +
        theme(plot.margin = margin(t = -5),
              axis.line = element_blank())
    
  })
  
  # Explanation of Social Security Reform
  
  output$text1 <- renderText({
    
    as.character(
      option_text %>%
        filter(option == input$option) %>%
        select(text)
    )
  })
  
  output$text2 <- renderText({
    
    open.group.unfunded.liability <- summary %>%
      mutate(Option = ifelse(Option == "Current law scheduled", "NULL", Option)) %>%
      filter(Option == input$option) %>%
      select(`Open Group Unfunded Obligation`)
    
    as.character(
      option_text %>%
        filter(option == input$option) %>%
        mutate(text2 = paste0(oguo1, " ", as.character(open.group.unfunded.liability), oguo3)) %>%
        select(text2)
    )
  })
  
  output$text3 <- renderText({
    
    insolvency.year <- summary %>%
      mutate(Option = ifelse(Option == "Current law scheduled", "NULL", Option)) %>%
      filter(Option == input$option) %>%
      select(`Insolvency Year`)
    
    as.character(
      option_text %>%
        filter(option == input$option) %>%
        mutate(text3 = paste0(insolvency1, " ", insolvency.year, insolvency3)) %>%
        select(text3)
    )
  }) 
  
  output$text4 <- renderText({
    
    actuarial.balance <- summary %>%
      mutate(Option = ifelse(Option == "Current law scheduled", "NULL", Option)) %>%
      filter(Option == input$option) %>%
      select(`75-Year Actuarial Balance`)
  
    as.character(
      option_text %>%
        filter(option == input$option) %>%
        mutate(text4 = paste0(actuarial.balance1, " ", as.character(actuarial.balance), actuarial.balance3)) %>%
        select(text4)
    )
  })   
 
  # Chart 1
  output$hover_info1 <- renderUI({
    hover <- input$plot_hover1
    point <- nearPoints(data_subset(), hover, threshold = 20, maxpoints = 1, addDist = TRUE)
    if (nrow(point) == 0) return(NULL)
        
    left_pct <- (hover$x - hover$domain$left) / (hover$domain$right - hover$domain$left)
    top_pct <- (hover$domain$top - hover$y) / (hover$domain$top - hover$domain$bottom)
    
    left_px <- hover$range$left + left_pct * (hover$range$right - hover$range$left)
    top_px <- hover$range$top + top_pct * (hover$range$bottom - hover$range$top)
    
    style <- paste0("position:absolute; z-index:100; background-color: rgba(245, 245, 245, 0.85); ",
                    "left:", left_px - 92, "px; top:", top_px + 40, "px; cursor: crosshair;")
    
    wellPanel(
      style = style,
      p(HTML(paste0("<b> Year:  </b>", point$calendar.year,"<br/>",
                    "<b> Ratio: </b>", round(point$income.cost, 2), "<br/>"
                    )))
    )
  })
  
  # Chart 2
  output$hover_info2 <- renderUI({
    hover <- input$plot_hover2
    point <- nearPoints(data_subset(), hover, threshold = 20, maxpoints = 1, addDist = TRUE)
    if (nrow(point) == 0) return(NULL)
    
    left_pct <- (hover$x - hover$domain$left) / (hover$domain$right - hover$domain$left)
    top_pct <- (hover$domain$top - hover$y) / (hover$domain$top - hover$domain$bottom)
    
    left_px <- hover$range$left + left_pct * (hover$range$right - hover$range$left)
    top_px <- hover$range$top + top_pct * (hover$range$bottom - hover$range$top)
    
    style <- paste0("position:absolute; z-index:100; background-color: rgba(245, 245, 245, 0.85); ",
                    "left:", left_px + 15, "px; top:", top_px + 40, "px; cursor: crosshair;")
    
    wellPanel(
      style = style,
      p(HTML(paste0("<b> Year:  </b>", point$calendar.year,"<br/>",
                    "<b> Ratio: </b>", round(point$cost.payroll, 2), "<br/>"
                    )))
    )
  })
  
  # Chart 3
  output$hover_info3 <- renderUI({
    hover <- input$plot_hover3
    point <- nearPoints(data_subset(), hover, threshold = 20, maxpoints = 1, addDist = TRUE)
    if (nrow(point) == 0) return(NULL)
    
    left_pct <- (hover$x - hover$domain$left) / (hover$domain$right - hover$domain$left)
    top_pct <- (hover$domain$top - hover$y) / (hover$domain$top - hover$domain$bottom)
    
    left_px <- hover$range$left + left_pct * (hover$range$right - hover$range$left)
    top_px <- hover$range$top + top_pct * (hover$range$bottom - hover$range$top)
    
    style <- paste0("position:absolute; z-index:100; background-color: rgba(245, 245, 245, 0.85); ",
                    "left:", left_px - 92, "px; top:", top_px + 40, "px; cursor: crosshair;")
    
    wellPanel(
      style = style,
      p(HTML(paste0("<b> Year:  </b>", point$calendar.year,"<br/>",
                    "<b> Ratio: </b>", round(point$trust.fund.ratio, 2), "<br/>"
      )))
    )
  })
  
  output$download_data <- downloadHandler(
    filename = function() { ifelse(input$option == "NULL", "baselines.csv", paste0(input$option, '.csv')) },
    content = function(file) {
      write_csv(data_subset(), file)
    }
  )
  
}

shinyApp(ui = ui, server = server)

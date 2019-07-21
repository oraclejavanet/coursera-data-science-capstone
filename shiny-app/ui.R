library(shiny)
library(shinythemes)
library(dplyr)
require(markdown)
library(tm)

shinyUI(
    navbarPage("Next Word Predict",
               theme = shinytheme("spacelab"),
               tabPanel("Home",
                        fluidPage(
                            titlePanel("Home"),
                            sidebarLayout(
                                sidebarPanel(
                                    textInput("userInput",
                                              "Enter a word or phrase:",
                                              value =  "",
                                              placeholder = "Enter text here")
                                ),
                                mainPanel(
                                    h4("Input text"),
                                    verbatimTextOutput("userSentence"),
                                    br(),
                                    h4("Predicted words"),
                                    verbatimTextOutput("prediction1"),
                                    verbatimTextOutput("prediction2"),
                                    verbatimTextOutput("prediction3")
                                )
                            )
                        )
               ),
               tabPanel("About",
                        h3("About Next Word Predict"),
                        div("Motor Trend Data Analysis is an interactive
                            application that uses linear regression modeling
                            techniques to estimate fuel consumption (MPG) in 32
                            automobiles (1973-74 models) based on 11 aspects of
                            automobile design and performance. See ",
                            em("About the Data Set"),
                            br(),br(),
                            "The source code for this application can be found
                            on GitHub:",
                            br(),br(),
                            a(href = "https://github.com/oraclejavanet/developing-data-products-course-project-3/tree/master/shiny-app/",
                            "https://github.com/oraclejavanet/developing-data-products-course-project-3/tree/master/shiny-app/"))
               )
    )
)

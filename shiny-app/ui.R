# ui.R
# Author: Jeffrey M. Hunter
# Date: 28-JUL-2019
# Description: Shiny UI, Coursera Data Science Capstone Final Project
# GitHub: https://github.com/oraclejavanet/coursera-data-science-capstone

library(shiny)
library(shinythemes)
library(markdown)
library(dplyr)
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
                                              placeholder = "Enter text here"),
                                    br(),
                                    sliderInput("numPredictions", "Number of Predictions:",
                                                value = 1.0, min = 1.0, max = 3.0, step = 1.0)
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
                        br(),
                        div("Next Word Predict is a Shiny app that uses a text
                            prediction algorithm to predict the next word(s)
                            based on text entered by a user.",
                            br(),
                            br(),
                            "The predicted next word will be shown when the app
                            detects that you have finished typing one or more
                            words. When entering text, please allow a few
                            seconds for the output to appear.",
                            br(),
                            br(),
                            "Use the slider tool to select up to three next
                            word predictions. The top prediction will be
                            shown first followed by the second and third likely
                            next words.",
                            br(),
                            br(),
                            "The source code for this application can be found
                            on GitHub:",
                            br(),
                            br(),
                            img(src = "github.png"),
                            a(target = "_blank", href = "https://github.com/oraclejavanet/coursera-data-science-capstone/tree/master/shiny-app/",
                            "Next Word Predict")),
                        br(),
                        h3("About Me"),
                        br(),
                        div("My name is Jeffrey M. Hunter and I am a
                            Senior Database Administrator and Application
                            Programmer for ",
                            a(target = "_blank", href = "https://www.dbazone.com/", "The DBA Zone, Inc."),".",
                            "I am an Oracle Certified Professional, Oracle ACE
                            and Author with over 25 years of experience working
                            with Oracle, MySQL, MariaDB, MongoDB and PostgreSQL
                            database technologies.",
                            br(),
                            br(),
                            "My work includes advanced performance tuning, Java
                            and PL/SQL programming, developing highly available
                            database solutions, capacity planning, database
                            security and physical / logical database design in a
                            UNIX / Linux server environment.",
                            br(),
                            br(),
                            "My other specialties include mathematics,
                            developing statistical models, predictive analytics
                            and statistical data analysis in R, Oracle R
                            Enterprise, Oracle Data Mining and Python.",
                            br(),
                            br(),
                            img(src = "linkedin.png"),
                            a(target = "_blank", href="https://www.linkedin.com/in/oraclejavanet/", "OracleJavaNet"),
                            br(),
                            img(src = "twitter.png"),
                            a(target = "_blank", href="https://twitter.com/oraclejavanet/", "OracleJavaNet"))
               )
    )
)

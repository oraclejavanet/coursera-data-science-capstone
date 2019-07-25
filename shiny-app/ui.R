# ui.R
# Author: Jeffrey M. Hunter
# Date: 24-JUL-2019
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
                        div("Motor Trend Data Analysis is an interactive
                            application that uses linear regression modeling
                            techniques to estimate fuel consumption (MPG) in 32
                            automobiles (1973-74 models) based on 11 aspects of
                            automobile design and performance. See ",
                            em("About the Data Set"),
                            br(),br(),
                            "The source code for this application can be found
                            on GitHub:",
                            br(),
                            br(),
                            a(href = "https://github.com/oraclejavanet/developing-data-products-course-project-3/tree/master/shiny-app/",
                            "https://github.com/oraclejavanet/developing-data-products-course-project-3/tree/master/shiny-app/")),
                        h3("About Me"),
                        div("My name is Jeffrey M. Hunter and I am a
                            Senior Database Administrator and Application
                            Programmer for ",
                            a(href = "https://www.dbazone.com/", "The DBA Zone, Inc."),".",
                            "I am an Oracle Certified Professional, Oracle ACE
                            and Author with over 25 years of experience working
                            with Oracle, MySQL, MongoDB and PostgreSQL database
                            technologies.",
                            br(),
                            br(),
                            "My work includes advanced performance tuning, Java
                            and PL/SQL programming, developing high availability
                            solutions, capacity planning, database security and
                            physical / logical database design in a UNIX / Linux
                            server environment.",
                            br(),
                            br(),
                            "My other specialties include Data Analysis in R,
                            Python and Oracle R Enterprise, mathematics and
                            programming language processors in Java and C.",
                            br(),
                            br(),
                            img(src = "linkedin.png"),
                            a(href="https://www.linkedin.com/in/oraclejavanet/", "OracleJavaNet"),
                            br(),
                            img(src = "twitter.png"),
                            a(href="https://twitter.com/oraclejavanet/", "@OracleJavaNet/"))
               )
    )
)

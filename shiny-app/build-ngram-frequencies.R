# build-ngram-frequencies.R
# Author: Jeffrey M. Hunter
# Date: 27-JUL-2019
# Description: Prepare n-gram frequencies
# GitHub: https://github.com/oraclejavanet/coursera-data-science-capstone

library(tm)
library(dplyr)
library(stringi)
library(stringr)
library(quanteda)
library(data.table)

# ------------------------------------------------------------------------------
# Prepare environment
# ------------------------------------------------------------------------------

rm(list = ls(all.names = TRUE))
setwd("~/repos/coursera/data-science-specialization-github-assignments/coursera-data-science-capstone/shiny-app")

# ------------------------------------------------------------------------------
# Download, unzip and load the training data
# ------------------------------------------------------------------------------

trainURL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
trainDataFile <- "data/Coursera-SwiftKey.zip"

if (!file.exists('data')) {
    dir.create('data')
}

if (!file.exists("data/final/en_US")) {
    tempFile <- tempfile()
    download.file(trainURL, tempFile)
    unzip(tempFile, exdir = "data")
    unlink(tempFile)
    rm(tempFile)
}

# blogs
blogsFileName <- "data/final/en_US/en_US.blogs.txt"
con <- file(blogsFileName, open = "r")
blogs <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

# news
newsFileName <- "data/final/en_US/en_US.news.txt"
con <- file(newsFileName, open = "r")
news <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

# twitter
twitterFileName <- "data/final/en_US/en_US.twitter.txt"
con <- file(twitterFileName, open = "r")
twitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

print("Loaded training data")
print(paste0("Number of lines per file (blogs):     ", format(length(blogs), big.mark = ",")))
print(paste0("Number of lines per file (news):    ", format(length(news), big.mark = ",")))
print(paste0("Number of lines per file (twitter): ", format(length(twitter), big.mark = ",")))
print(paste0("Number of lines per file (total):   ", format(length(blogs) +
                                                            length(news) +
                                                            length(twitter), big.mark = ",")))

# remove variables no longer needed to free up memory
rm(con, trainURL, trainDataFile, blogsFileName, newsFileName, twitterFileName)

# ------------------------------------------------------------------------------
# Prepare the data
# ------------------------------------------------------------------------------

# set seed for reproducability
set.seed(660067)

# assign sample size
sampleSize = 0.01

# assign sample size (800K rows)
##sampleSize = 800000

# sample all three data sets
sampleBlogs <- sample(blogs, length(blogs) * sampleSize, replace = FALSE)
sampleNews <- sample(news, length(news) * sampleSize, replace = FALSE)
sampleTwitter <- sample(twitter, length(twitter) * sampleSize, replace = FALSE)

# remove all non-English characters from the sampled data
sampleBlogs <- iconv(sampleBlogs, "latin1", "ASCII", sub = "")
sampleNews <- iconv(sampleNews, "latin1", "ASCII", sub = "")
sampleTwitter <- iconv(sampleTwitter, "latin1", "ASCII", sub = "")

# remove outliers such as very long and very short articles by only including
# the IQR
removeOutliers <- function(data) {
    first <- quantile(nchar(data), 0.25)
    third <- quantile(nchar(data), 0.75)
    data <- data[nchar(data) > first]
    data <- data[nchar(data) < third]
    return(data)
}

sampleBlogs <- removeOutliers(sampleBlogs)
sampleNews <- removeOutliers(sampleNews)
sampleTwitter <- removeOutliers(sampleTwitter)

# combine all three data sets into a single data set
##sampleData <- c(sampleBlogs, sampleNews, sampleTwitter)
sampleData <- c(sampleNews, sampleTwitter)

# get number of lines and words from the sample data set
sampleDataLines <- length(sampleData)
sampleDataWords <- sum(stri_count_words(sampleData))
print("Create sample data set")
print(paste0("Number of lines:  ", format(sampleDataLines, big.mark = ",")))
print(paste0("Number of words: ", format(sampleDataWords, big.mark = ",")))

# remove variables no longer needed to free up memory
rm(blogs, news, twitter, sampleBlogs, sampleNews, sampleTwitter)
rm(removeOutliers)

# ------------------------------------------------------------------------------
# Clean the data
# ------------------------------------------------------------------------------

# load bad words file
badWordsURL <- "http://www.idevelopment.info/data/DataScience/uploads/full-list-of-bad-words_text-file_2018_07_30.zip"
badWordsFile <- "data/full-list-of-bad-words_text-file_2018_07_30.txt"
if (!file.exists('data')) {
    dir.create('data')
}
if (!file.exists(badWordsFile)) {
    tempFile <- tempfile()
    download.file(badWordsURL, tempFile)
    unzip(tempFile, exdir = "data")
    unlink(tempFile)
    rm(tempFile)
}
con <- file(badWordsFile, open = "r")
profanity <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
profanity <- iconv(profanity, "latin1", "ASCII", sub = "")
close(con)

# convert text to lowercase
sampleData <- tolower(sampleData)

# remove URL, email addresses, Twitter handles and hash tags
sampleData <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", sampleData, ignore.case = FALSE, perl = TRUE)
sampleData <- gsub("\\S+[@]\\S+", "", sampleData, ignore.case = FALSE, perl = TRUE)
sampleData <- gsub("@[^\\s]+", "", sampleData, ignore.case = FALSE, perl = TRUE)
sampleData <- gsub("#[^\\s]+", "", sampleData, ignore.case = FALSE, perl = TRUE)

# remove ordinal numbers
sampleData <- gsub("[0-9](?:st|nd|rd|th)", "", sampleData, ignore.case = FALSE, perl = TRUE)

# remove profane words
sampleData <- removeWords(sampleData, profanity)

# remove punctuation
sampleData <- gsub("[^\\p{L}'\\s]+", "", sampleData, ignore.case = FALSE, perl = TRUE)

# remove punctuation (leaving ')
sampleData <- gsub("[.\\-!]", " ", sampleData, ignore.case = FALSE, perl = TRUE)

# trim leading and trailing whitespace
sampleData <- gsub("^\\s+|\\s+$", "", sampleData)
sampleData <- stripWhitespace(sampleData)

# write sample data set to disk
sampleDataFileName <- "data/en_US.sample.txt"
con <- file(sampleDataFileName, open = "w")
writeLines(sampleData, con)
close(con)

# remove variables no longer needed to free up memory
rm(badWordsURL, badWordsFile, con, sampleDataFileName, profanity)

# ------------------------------------------------------------------------------
# Build corpus
# ------------------------------------------------------------------------------

corpus <- corpus(sampleData)

# ------------------------------------------------------------------------------
# Build n-gram frequencies
# ------------------------------------------------------------------------------

getTopThree <- function(corpus) {
    first <- !duplicated(corpus$variable)
    balance <- corpus[!first,]
    first <- corpus[first,]
    second <- !duplicated(balance$variable)
    balance2 <- balance[!second,]
    second <- balance[second,]
    third <- !duplicated(balance2$variable)
    third <- balance2[third,]
    return(rbind(first, second, third))
}

# Generate a token frequency dataframe. Do not remove stemwords because they are
# possible candidates for next word prediction.
tokenFrequency <- function(corpus, n = 1, rem_stopw = NULL) {
    corpus <- dfm(corpus, ngrams = n)
    corpus <- colSums(corpus)
    total <- sum(corpus)
    corpus <- data.frame(names(corpus),
                         corpus,
                         row.names = NULL,
                         check.rows = FALSE,
                         check.names = FALSE,
                         stringsAsFactors = FALSE
    )
    colnames(corpus) <- c("token", "n")
    corpus <- mutate(corpus, token = gsub("_", " ", token))
    corpus <- mutate(corpus, percent = corpus$n / total)
    if (n > 1) {
        corpus$outcome <- word(corpus$token, -1)
        corpus$token <- word(string = corpus$token, start = 1, end = n - 1, sep = fixed(" "))
    }
    setorder(corpus, -n)
    corpus <- getTopThree(corpus)
    return(corpus)
}

# get top 3 words to initiate the next word prediction app
startWord <- word(corpus$documents$texts, 1)  # get first word for each document
startWord <- tokenFrequency(startWord, n = 1, NULL)  # determine most popular start words
startWordPrediction <- startWord$token[1:3]  # select top 3 words to start word prediction app
saveRDS(startWordPrediction, "data/start-word-prediction-2.RData")

# bigram
bigram <- tokenFrequency(corpus, n = 2, NULL)
saveRDS(bigram, "data/bigram2.RData")
remove(bigram)

# trigram
trigram <- tokenFrequency(corpus, n = 3, NULL)
trigram <- trigram %>% filter(n > 1)
trigram$token <- NULL
trigram$n <- NULL
trigram$percent <- NULL
saveRDS(trigram, "data/trigram2.RData")
remove(trigram)

# quadgram
quadgram <- tokenFrequency(corpus, n = 4, NULL)
quadgram <- quadgram %>% filter(n > 1)
quadgram$token <- NULL
quadgram$n <- NULL
quadgram$percent <- NULL
saveRDS(quadgram, "data/quadgram2.RData")
remove(quadgram)

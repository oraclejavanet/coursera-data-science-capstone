# build-ngram-frequencies.R
# Author: Jeffrey M. Hunter
# Date: 27-JUL-2019
# Description: Prepare n-gram frequencies
# GitHub: https://github.com/oraclejavanet/coursera-data-science-capstone

library(tm)
library(stringi)

# ------------------------------------------------------------------------------
# Prepare environment
# ------------------------------------------------------------------------------

rm(list = ls(all.names = TRUE))
setwd("~/repos/coursera/github-assignments/coursera-data-science-capstone/shiny-app")

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

# remove variables no longer needed to free up memory
rm(con, trainURL, trainDataFile, blogsFileName, newsFileName, twitterFileName)

# ------------------------------------------------------------------------------
# Prepare the data
# ------------------------------------------------------------------------------

# assign sample size
sampleSize = 0.01

# set seed for reproducability
set.seed(660067)

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

# combine all three data sets into a single data set and write to disk
sampleData <- c(sampleBlogs, sampleNews, sampleTwitter)
sampleDataFileName <- "data/final/en_US/en_US.sample.txt"
con <- file(sampleDataFileName, open = "w")
writeLines(sampleData, con)
close(con)

# get number of lines and words from the sample data set
sampleDataLines <- length(sampleData)
sampleDataWords <- sum(stri_count_words(sampleData))
print("Create sample data set")
print(paste0("Number of lines: ", sampleDataLines))
print(paste0("Number of words: ", sampleDataWords))

# remove variables no longer needed to free up memory
rm(con, blogs, news, twitter, sampleBlogs, sampleNews, sampleTwitter)
rm(sampleDataFileName, removeOutliers)

# ------------------------------------------------------------------------------
# Clean the data
# ------------------------------------------------------------------------------

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

# need to refactor with addition of new words/phrase to exclude (email, twitter)...

# remove variables no longer needed to free up memory
rm(badWordsURL, badWordsFile)

# ------------------------------------------------------------------------------
# Build corpus
# ------------------------------------------------------------------------------

# need to refactor corpus to VCorpuss...

# ------------------------------------------------------------------------------
# Build n-gram frequencies
# ------------------------------------------------------------------------------

# need to refactor dfm with new optimizations...

# saveRDS(init_three_predictions, "data/first-three-predictions.RData")
# saveRDS(bigram_dfm, "data/bigram.RData")
# saveRDS(trigram_dfm, "data/trigram.RData")
# saveRDS(quadgram_dfm, "data/quadgram.RData")


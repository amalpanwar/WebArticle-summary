library(rvest) #scrap text from website
library(lexRankr) #summarizing the text
library(stringr) #cleaning the text
url <- read_html("https://softwarekeep.com/help-center/power-bi-for-mac") #fetch the web article

#passing css tag to scrap and store in a text variable
text <- url %>%
  html_nodes(".article-content") %>% # passing css tag for scrapping
  html_text()

#cleaning the text
text_clean <- gsub("\n"," ",text) %>% str_squish() #squishing the text to remove unnecessary white space

#perform google lexRank for top 10 sentences
summarize <- lexRank(text_clean,
                     docId = "create", #generate new document identifier
                     n = 10, #produce a summary containing 10 sentences or key phrases
                     continuous = TRUE) # to ensure most informative content is reatined in continuous manner

# reorder sentences sequentially
text_reorder <- order(as.integer(gsub("_","",summarize$sentenceId)))

# extract top 10 sentences
topTen <- summarize[text_reorder,]$sentence

print(topTen)

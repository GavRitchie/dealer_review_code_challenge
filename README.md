# Dealer Review Code Challenge
This is a small application that will scrape reviews for a given dealer on DealerRater.com and can analyze the reviews' sentiment.

## Setup
[Install Ruby](https://www.ruby-lang.org/en/documentation/installation/)

Navigate to the folder where you've saved `dealer_review_code_challenge` and run the following:
```
gem install bundler
bundle install
```
This will set up all packages necessary to use the code. 

## Explanation of code
There are 3 main files: `review_scraper.rb`, `review_sentiment_analyzer.rb`, and `get_overly_positive_reviews.rb`. 

`review_scraper.rb` contains the `ReviewScraper` class, which will take in a dealer name and scrape the first 5 pages of reviews for that dealer (unless the dealer is not found, in which case it will return an error). 

`review_sentiment_analyzer.rb` utilizes the [textmood gem](https://github.com/stiang/textmood) to score the reviews. This gem is useful for simple sentiment analysis. It tokenizes the text and then uses a dictionary of positive/negative words to assign a score to each word or group of words (i.e. ngram). Then, it normalizes that score based on the number of words in the review. 

`get_overly_positive_reviews.rb` contains the execution of the code challenge. It uses both of the above mentioned classes to scrape reviews for a dealer called "McKaig Chevrolet Buick", and then outputs the top 3 "most positive" reviews to the console. 

# How to execute
To see it all in action, run the following from the command line:
```
ruby get_overly_positive_reviews.rb
```

# Testing
To run the full test suite:
```
rspec
```

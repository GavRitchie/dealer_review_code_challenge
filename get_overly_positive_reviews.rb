require_relative './review_scraper'
require_relative './review_sentiment_analyzer'

DEALER = 'McKaig Chevrolet Buick'
REVIEWS_TO_PRINT = 3.freeze

review_scrape_result = ReviewScraper.scrape_reviews(DEALER)
if !review_scrape_result[:success]
  puts review_scrape_result[:errors]
else
  scores = ReviewSentimentAnalyzer.analyze(review_scrape_result[:reviews])

  most_positive_reviews = scores.sort_by { |score| -score[:score] }.first(REVIEWS_TO_PRINT)

  most_positive_reviews.each_with_index do |review, i|
    puts "#{i + 1} - #{review[:review_text]}"
  end
end

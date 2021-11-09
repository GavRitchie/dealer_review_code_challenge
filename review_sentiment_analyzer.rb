require 'textmood'
# https://github.com/stiang/textmood

class ReviewSentimentAnalyzer
  attr_reader :reviews, :mood_analyzer

  def self.analyze(reviews)
    new(reviews).analyze_reviews
  end

  def initialize(reviews)
    @reviews = reviews
    @mood_analyzer = TextMood.new(language: "en", normalize_score: true, start_ngram: 1, end_ngram: 2)
  end

  def analyze_reviews
    reviews.map { |review| score_review(review) }
  end

  private

  def score_review(review_text)
    { review_text: review_text, score: mood_analyzer.analyze(review_text) }
  end
end

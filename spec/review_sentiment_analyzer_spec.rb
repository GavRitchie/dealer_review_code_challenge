require_relative '../review_sentiment_analyzer.rb'
describe ReviewSentimentAnalyzer do
  subject(:scores) { described_class.analyze(reviews) }
  let(:good_review) { "Wow! This dealer was so awesome. I Loved my experience here."}
  let(:bad_review) { "Boo. I hated going to this dealership" }
  let(:neutral_review) { "This dealer was ok" }
  let(:reviews) { [good_review, bad_review, neutral_review] }

  it 'correctly scores review sentiment' do
    expect(scores.sort_by { |score| -score[:score] }.map { |s| s[:review_text] }).to eq([good_review, neutral_review, bad_review])
  end
end

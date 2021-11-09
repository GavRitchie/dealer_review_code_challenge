require_relative '../review_scraper.rb'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

describe ReviewScraper do
  subject(:result) { described_class.scrape_reviews(dealer_name) }
  let(:dealer_name) { 'Quality Quidditch Supplies' }
  let(:stubbed_response) do
    [{
      "dealerName" => dealer_name,
      "dealerId" => 12345
    }].to_json
  end
  let(:stubbed_http_body) { File.read("spec/fixtures/mock_review_page.html") }

  before do
    stub_request(:get, URI.encode("#{ReviewScraper::DEALER_SEARCH_URL}#{dealer_name}")).
      to_return(status: 200, body: stubbed_response)
    stub_request(:get, "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_95.0.4638").
      to_return(status: 200)
    Watir::Browser.any_instance.stub(:goto)
    Watir::Browser.any_instance.stub(:html).and_return(stubbed_http_body)
    described_class.any_instance.stub(:user_agent).and_return('Fake User Agent')
  end

  it 'parses the webpage correctly' do
    expect(result[:success]).to be true
    expect(result[:reviews] & ['This Dealer is AMAZING', 'This Dealer is TERRIBLE']).not_to be_empty
  end

  context 'cannot find the specified dealer' do
    let(:stubbed_response) {[]}
    it 'returns an invalid result' do
      expect(result[:success]).to be false
      expect(result[:errors]).not_to be_empty
    end
  end
end

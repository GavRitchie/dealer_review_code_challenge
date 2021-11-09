require 'watir'
require 'webdrivers'
require 'nokogiri'
require 'open-uri'

class ReviewScraper
  PAGES_TO_SCRAPE = 5.freeze
  DEALER_SEARCH_URL = "https://www.dealerrater.com/json/dealer/dealersearch?MaxItems=1&term="
  REFERER = "https://www.dealerrater.com/?__optnav=1"
  attr_reader :dealer_name, :errors

  def self.scrape_reviews(dealer_name)
    new(dealer_name).scrape_reviews
  end

  def initialize(dealer_name)
    @dealer_name = dealer_name
    @errors = []
  end

  def scrape_reviews
    return { success: false, errors: errors } unless valid?
    all_reviews = (1..PAGES_TO_SCRAPE).flat_map do |i|
      contents = scrape_page(i)
      contents.map { |content| content.children.to_s }
    end
    return { success: true, reviews: all_reviews }
  ensure
    browser.close
  end

  private

  def scrape_page(page_number)
    url = "#{dealer_url}/page#{page_number}"
    browser.goto(url)
    parsed_page = Nokogiri::HTML(browser.html)
    parsed_page.xpath("//p[contains(@class, 'review-content')]")
  end

  def valid?
    validate_dealer_name
    errors.empty?
  end

  def browser
    @browser ||= Watir::Browser.new
  end

  def user_agent
    @user_agent ||= browser.driver.execute_script("return navigator.userAgent;")
  end

  def dealer_url
    @dealer_url ||= begin
      dealer_id = dealer_search_results.first['dealerId']
      dealer_name = dealer_search_results.first['dealerName']
      dashed_dealer_name = dealer_name.gsub(/[^a-z0-9\s]/i, '').gsub(/\s+/, '-')
      "https://www.dealerrater.com/dealer/#{dashed_dealer_name}-dealer-reviews-#{dealer_id}"
    end
  end

  def dealer_search_results
    @dealer_search_results ||= begin
      uri = URI("#{DEALER_SEARCH_URL}#{dealer_name}")
      body = uri.read(
        "User-Agent" => user_agent,
        "Referer" => REFERER
      )
      JSON.parse(body)
    end
  end

  def validate_dealer_name
    if dealer_search_results.empty?
      errors << "Could not find dealer #{dealer_name}"
    end
  end
end

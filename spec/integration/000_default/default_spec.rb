# frozen_string_literal: true

require_relative "../spec_helper"
require "capybara/rspec"
require "selenium-webdriver"

Capybara.configure do |config|
  config.run_server = false
  config.app_host = "http://demo.i.trombik.org"
  config.server_host = "172.16.100.254"
end

# see https://docs.travis-ci.com/user/chrome#capybara
Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu])
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = :chrome
Capybara.javascript_driver = :chrome

feature "Shows the top page" do
  describe "/" do
    it "returns the top page" do
      visit "/"

      expect(page).to have_content("Makers Guesthouse Portal")
    end
  end
end

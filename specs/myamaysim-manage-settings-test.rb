require "selenium-webdriver"
require "rspec"
require "./pages/MyAmaysimLoginPage"
require "./pages/ManageSettingsPage"


describe 'MyAmaysim Manage Settings (Call Forwarding)' do
	before(:all) do
		Selenium::WebDriver::Chrome.driver_path = "driver/chromedriver"
		
		@driver = Selenium::WebDriver.for :chrome

		@driver.manage.timeouts.implicit_wait = 10 # Implicit wait (10 seconds)

		@wait = Selenium::WebDriver::Wait.new(timeout: 20) # Explicit wait (20 seconds)

		@driver.navigate.to "https://www.amaysim.com.au/my-account/login"
		
		my_amasym_login_page = MyAmaysimLoginPage.new(@driver, @wait)

		my_amasym_login_page.login
	end
	
	after(:all) do
		@driver.quit
	end

	it 'should enable Call Forwarding' do
		manage_settings_page = ManageSettingsPage.new(@driver, @wait)

		manage_settings_page.visit

		manage_settings_page.disable_call_forwarding_if_needed

		is_call_forwarding_enabled = manage_settings_page.enable_call_forwarding

		expect(is_call_forwarding_enabled).to eq(true)
	end

	it 'should disable Call Forwarding' do
		manage_settings_page = ManageSettingsPage.new(@driver, @wait)

		manage_settings_page.visit

		manage_settings_page.enable_call_forwarding_if_needed

		is_call_forwarding_disabled = manage_settings_page.disable_call_forwarding

		expect(is_call_forwarding_disabled).to eq(true)
	end

	it 'should NOT enable Call Forwarding with invalid Australian phone number' do
		manage_settings_page = ManageSettingsPage.new(@driver, @wait)

		manage_settings_page.visit

		manage_settings_page.disable_call_forwarding_if_needed

		message = manage_settings_page.try_to_enable_call_forwarding_with_invalid_number

		expectedMessage = "Please enter your phone number in the following format: 0412 345 678 or 02 1234 5678"

		expect(message).to eq(expectedMessage)
	end
end

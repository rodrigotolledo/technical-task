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

	it 'should be able to enable Call Forwarding' do
		manage_settings_page = ManageSettingsPage.new(@driver, @wait)

		manage_settings_page.visit

		manage_settings_page.disable_call_forwarding_if_needed

		manage_settings_page.enable_call_forwarding
	end

	xit 'should be able to disable Call Forwarding' do

	end

	xit 'should NOT be able to enable Call Forwarding with invalid Australian number' do

	end

end






require "selenium-webdriver"

Selenium::WebDriver::Chrome.driver_path = "driver/chromedriver"

$driver = Selenium::WebDriver.for :chrome

# Implicit wait (10 seconds)
$driver.manage.timeouts.implicit_wait = 10

# Explicit wait (20 seconds)
$wait = Selenium::WebDriver::Wait.new(timeout: 20)

# Refactor this and move to other place
def is_call_forwarding_enabled()
	call_forwarding_status = $wait.until { $driver.find_element(css: '#settings_call_forwarding .setting-option-value-text').text }
	return call_forwarding_status
end

$driver.navigate.to "https://www.amaysim.com.au/my-account/login"

amaysim_number = $wait.until { $driver.find_element(id: 'mobile_number') }
amaysim_number.send_keys "0468827174"

amaysim_password = $wait.until { $driver.find_element(id: 'password') }
amaysim_password.send_keys "theHoff34"

submit_button = $wait.until { $driver.find_element(name: 'commit') }
submit_button.submit

# Make sure login was successful (wait till Logout link is found)
$wait.until { $driver.find_element(class: 'logout-link') }

$driver.navigate.to "https://www.amaysim.com.au/my-account/my-amaysim/settings"

sleep 3 # Replace by better approach

if(is_call_forwarding_enabled() == "No")
	puts "[Call Forwarding is currently DISABLED]"

	# Using execute_script because Selenium wasn't able to click on element using default click() method
	$driver.execute_script('document.getElementById("edit_settings_call_forwarding").click()')

	confirm_call_forwarding = $wait.until { $driver.find_element(link_text: 'Confirm') } # Review how reliable this one is.
	sleep 3 # Replace by better approach
	confirm_call_forwarding.click

	forward_calls_to_number = $wait.until { $driver.find_element(id: 'my_amaysim2_setting_call_divert_number') }
	forward_calls_to_number.clear
	forward_calls_to_number.send_keys "0412345678"

	submit_button = $wait.until { $driver.find_element(name: 'commit') } # refactor, this has been declared already
	submit_button.submit

	$wait.until { $driver.find_element(css: '.form_info_popup.reveal-modal.padding-none.open').displayed? }

	puts ">>>>>>>>>>>> Call Forwarding is now ENABLED <<<<<<<<<<<<<<"
	# TODO
	# assert is_call_forwarding_enabled() == "Yes"

else (is_call_forwarding_enabled == "Yes")
	puts "[Call Forwarding is currently ENABLED]"

	# Using execute_script because Selenium wasn't able to click on element using default click() method
	$driver.execute_script('document.getElementById("edit_settings_call_forwarding").click()')

	confirm_call_forwarding = $wait.until { $driver.find_element(link_text: 'Confirm') } # Review how reliable this one is.
	sleep 3 # Replace by better approach
	confirm_call_forwarding.click

	sleep 5 # Replace by better approach

	# Using execute_script because Selenium wasn't able to click on element using default click() method
	$driver.execute_script('document.getElementById("my_amaysim2_setting_call_divert_false").click()')

	submit_button = $wait.until { $driver.find_element(name: 'commit') } # Refactor, this has been declared already
	sleep 5 # Replace by better approach
	submit_button.submit

	$wait.until { $driver.find_element(css: '.form_info_popup.reveal-modal.padding-none.open').displayed? }

	puts ">>>>>>>>>>>> Call Forwarding is now DISABLED <<<<<<<<<<<<<<"
	# TODO
	# assert is_call_forwarding_enabled() == "No"
end

$driver.quit
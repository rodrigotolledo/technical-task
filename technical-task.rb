require "selenium-webdriver"

# Refactor this and move to other place
def is_call_forwarding_enabled()
	call_forwarding_status = $driver.find_element(css: '#settings_call_forwarding .setting-option-value-text').text
	return call_forwarding_status
end

Selenium::WebDriver::Chrome.driver_path = "driver/chromedriver"

$driver = Selenium::WebDriver.for :chrome

$driver.navigate.to "https://www.amaysim.com.au/my-account/login"

amaysim_number = $driver.find_element(id: 'mobile_number')
amaysim_number.send_keys "0468827174"

sleep 1

amaysim_password = $driver.find_element(id: 'password')
amaysim_password.send_keys "theHoff34"

sleep 1

submit_button = $driver.find_element(name: 'commit')
submit_button.submit

sleep 2

$driver.navigate.to "https://www.amaysim.com.au/my-account/my-amaysim/settings"

sleep 3

if(is_call_forwarding_enabled() == "No")
	puts ">>>>>>>>>>>> Call Forwarding is currently DISABLED <<<<<<<<<<<<<<"

	# Using execute_script because Selenium wasn't able to click on element using default click() method
	$driver.execute_script('document.getElementById("edit_settings_call_forwarding").click()')

	sleep 5

	confirm_call_forwarding = $driver.find_element(link_text: 'Confirm')
	confirm_call_forwarding.click

	sleep 3

	forward_calls_to_number = $driver.find_element(id: 'my_amaysim2_setting_call_divert_number')
	forward_calls_to_number.send_keys "0431535569"

	sleep 3

	submit_button = $driver.find_element(name: 'commit') # refactor, this has been declared already
	submit_button.submit

	# TODO
	# assert status was changed
end

if (is_call_forwarding_enabled == "Yes")
	puts ">>>>>>>>>>>> Call Forwarding is currently ENABLED <<<<<<<<<<<<<<"

	# Using execute_script because Selenium wasn't able to click on element using default click() method
	$driver.execute_script('document.getElementById("edit_settings_call_forwarding").click()')

	sleep 8

	confirm_call_forwarding = $driver.find_element(link_text: 'Confirm')
	confirm_call_forwarding.click

	sleep 5

	# Using execute_script because Selenium wasn't able to click on element using default click() method
	$driver.execute_script('document.getElementById("my_amaysim2_setting_call_divert_false").click()')

	sleep 1

	submit_button = $driver.find_element(name: 'commit') # refactor, this has been declared already
	submit_button.submit

	# TODO
	# assert status was changed
end
	
puts ">>>>>>>>>>>> FINISHED <<<<<<<<<<<<<<"

driver.quit
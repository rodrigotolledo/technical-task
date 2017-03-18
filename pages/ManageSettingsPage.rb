require "selenium-webdriver"

class ManageSettingsPage

	attr_accessor :driver
	attr_accessor :wait

	def initialize(driver, wait)
		@driver = driver
		@wait = wait
	end

	def visit
		@driver.navigate.to "https://www.amaysim.com.au/my-account/my-amaysim/settings"

		sleep 3 # Replace by wait.until
	end

	def call_forwarding_status
		@wait.until { @driver.find_element(css: '#settings_call_forwarding .setting-option-value-text').text }
	end

	def confirm_call_forwarding
		@wait.until { @driver.find_element(link_text: 'Confirm') } # Review how reliable this one is.
	end

	def submit_button
		@wait.until { @driver.find_element(name: 'commit') } # Refactor, this has been declared already
	end

	def wait_for_call_forward_success_modal
		@wait.until { @driver.find_element(css: '.form_info_popup.reveal-modal.padding-none.open').displayed? }
	end

	def forward_calls_to_number
		@wait.until { @driver.find_element(id: 'my_amaysim2_setting_call_divert_number') }
	end

	def is_call_forwarding_enabled()
		return call_forwarding_status
	end

	def disable_call_forwarding_if_needed
		if (is_call_forwarding_enabled == "Yes")
			puts "[Call Forwarding is currently ENABLED]"

			# Using execute_script because Selenium wasn't able to click on element using default click() method
			@driver.execute_script('document.getElementById("edit_settings_call_forwarding").click()')

			sleep 7 # Replace by wait.until
			confirm_call_forwarding.click

			sleep 5 # Replace by wait.until

			# Using execute_script because Selenium wasn't able to click on element using default click() method
			@driver.execute_script('document.getElementById("my_amaysim2_setting_call_divert_false").click()')

			sleep 5 # Replace by wait.until
			submit_button.submit

			wait_for_call_forward_success_modal

			puts ">>>>>>>>>>>> Call Forwarding is now DISABLED <<<<<<<<<<<<<<"
		end
	end

	def enable_call_forwarding
		puts "[Call Forwarding is currently DISABLED]"

		# Using execute_script because Selenium wasn't able to click on element using default click() method
		@driver.execute_script('document.getElementById("edit_settings_call_forwarding").click()')

		sleep 7 # Replace by wait.until
		confirm_call_forwarding.click

		forward_calls_to_number.clear
		forward_calls_to_number.send_keys "0412345678"

		submit_button.submit

		wait_for_call_forward_success_modal

		puts ">>>>>>>>>>>> Call Forwarding is now ENABLED <<<<<<<<<<<<<<"
	end

end
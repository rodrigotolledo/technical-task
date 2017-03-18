require "selenium-webdriver"

class MyAmaysimLoginPage

	attr_accessor :driver
	attr_accessor :wait

	def initialize(driver, wait)
		@driver = driver
		@wait = wait
	end

	def numberInput
		@wait.until { @driver.find_element(id: 'mobile_number') }
	end

	def passwordInput
		@wait.until { @driver.find_element(id: 'password') }
	end

	def submitButton
		@wait.until { @driver.find_element(name: 'commit') }
	end

	def login
		numberInput.send_keys "0468827174"
		
		passwordInput.send_keys "theHoff34"
		
		submitButton.submit

		@wait.until { @driver.find_element(class: 'logout-link') } # Make sure login was successful (wait till Logout link is present)
	end

end
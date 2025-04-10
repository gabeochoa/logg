

all:
	swift bundler run

sim: 
	swift bundler run --platform iOSSimulator --simulator "iPhone 16"

output: 
	swift bundler bundle -o . -c release -u

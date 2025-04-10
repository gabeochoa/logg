
all:
	swift run

clean:
	swift package clean


ios: 
	swift build --arch arm64 -Xswiftc -sdk -Xswiftc \
		/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk \
		-Xswiftc -target -Xswiftc arm64-apple-ios14.0


.PHONY: clean

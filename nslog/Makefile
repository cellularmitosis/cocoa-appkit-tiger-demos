run: build_tiger_g3
	open NSLogDemo/build/Release/NSlogDemo.app
.PHONY: run

build_tiger_g3:
	cd NSLogDemo && xcodebuild -configuration Release build SDKROOT="macosx10.4" ARCHS="ppc"
.PHONY: build

clean:
	cd NSLogDemo && xcodebuild clean
.PHONY: clean

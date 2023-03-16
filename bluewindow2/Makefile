demo=BlueWindowDemo2

run: build_tiger_g3
	open $(demo)/build/Release/$(demo).app
.PHONY: run

build_tiger_g3:
	cd $(demo) && xcodebuild -configuration Release build SDKROOT="macosx10.4" ARCHS="ppc"
.PHONY: build_tiger_g3

clean:
	cd $(demo) && xcodebuild clean
.PHONY: clean

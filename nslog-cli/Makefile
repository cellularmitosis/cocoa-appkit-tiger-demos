demo=NSLogCLIDemo

run: build_tiger_g3
	./$(demo)/build/Release/$(demo)
.PHONY: run

build_tiger_g3:
	cd $(demo) && xcodebuild -configuration Release build SDKROOT="macosx10.4" ARCHS="ppc"
.PHONY: build

clean:
	cd $(demo) && xcodebuild clean
.PHONY: clean

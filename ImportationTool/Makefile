# Flex binaries must be in your PATH ; otherwise you can set the FLEX_SDK_BIN
# variable to your flex bin directory (with an ending slash)


SWF_SOURCES=$(shell find -E src -regex '.*(mxml|as|css)')

all: swf

swf: bin/ImportationTool.swf

bin/ImportationTool.swf: $(SWF_SOURCES)
	$(FLEX_SDK_BIN)amxmlc -load-config+=src/conf.xml -output bin/ImportationTool.swf -- src/ImportationTool.mxml

# sets the current directory as adl's root directory
run: swf
	$(FLEX_SDK_BIN)adl src/app.xml .

package: src/cert.pfx src/app.xml bin/ImportationTool.swf
	$(FLEX_SDK_BIN)adt -package -storetype pkcs12 -keystore src/cert.pfx bin/ImportationTool.air src/app.xml bin/ImportationTool.swf

clean:
	rm bin/ImportationTool.swf bin/ImportationTool.air > /dev/null 2>&1

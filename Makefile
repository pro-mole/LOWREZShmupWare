#A simple Makefile to create our package

EXECNAME=FLASHMUP
VERSION=0.2
PACKNAME=$(EXECNAME)-$(VERSION).love

all: $(PACKNAME)

$(PACKNAME): *.lua */*.lua assets
	zip -9 -q -r $(PACKNAME) *.lua */*.lua assets
	
run: *.lua assets
	love ./

clean:
	rm -f *.love
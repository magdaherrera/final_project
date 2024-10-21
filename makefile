install:
	cd lambda-layers && $(MAKE)
clean:
	cd lambda-layers && $(MAKE) clean && cd ../app-python && $(MAKE) clean

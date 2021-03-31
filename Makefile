.PHONY: run
run:
	cp utf/* .;                                         \
	./vpl_evaluate.sh

.PHONY: mrproper
mrproper:
	rm -f vpl_execution vpl_test 
	rm -f *.cases
	rm -f *.h_ *.cpp_ *.hpp_
	rm -f *.h *.cpp *.hpp
	rm -f *.cpp.save
	rm -f .vpl_tester
	rm -f *.sh
	rm -f tui/tests.h
	rm -f tcs/extract.conf
	rm -f tcs/tests.h
	rm -rf tcs/xml
	rm -f *.txt
	
.SILENT: test
test:
	cd tcs;                                         \
	mv main.tcs main.cpp;                           \
	doxygen config.doxy;                            \
	python3 parser.py;                              \
	python3 test_creator.py;                        \
	mv main.cpp main.tcs;                           \
	pyclean .;                                      \
	echo "Test file 'tcs/tests.h' was created!"
	
.PHONY: requirements
requirements:
	sudo apt install python3
	sudo apt install doxygen
	sudo apt install python3-lxml


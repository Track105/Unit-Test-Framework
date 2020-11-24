.PHONY: run
run:
	mv tcs/main.cpp tcs/main.cpp.temp;                  \
	cp utf/* .;                                         \
	./vpl_evaluate.sh;                                  \
	mv tcs/main.cpp.temp tcs/main.cpp

.PHONY: mrproper
mrproper:
	rm -f vpl_execution vpl_test 
	rm -f *.cases
	rm -f *.h_ *.cpp_ *.hpp_
	rm -f *.h *.cpp *.hpp
	rm -f *.cpp.save
	rm -f .vpl_tester
	rm -f *.sh
	rm -f gui/tests.h
	rm -f tcs/extract.conf
	rm -f tcs/tests.h
	rm -rf tcs/xml
	
.SILENT: test
test:
	printf "How do you want to create the tests? (automatic/manually): "
	read mode;                                          \
	if [ $$mode = "automatic" ]; then                   \
		cd tcs;                                         \
		if [ ! dpkg -s doxygen >/dev/null 2>&1 ]; then  \
			sudo apt-get install doxygen;               \
		fi;                                             \
		doxygen config.doxy;                            \
		python3 parser.py;                              \
		python3 test_creator.py;                        \
		echo "Test file 'tcs/tests.h' was created!";    \
	elif [ $$mode = "manually" ]; then                  \
		cd gui;                                         \
		./createTests.sh;                               \
		echo "Test file 'gui/tests.h' was created!";    \
	else                                                \
		echo "Invalid command! Stop!";                  \
	fi


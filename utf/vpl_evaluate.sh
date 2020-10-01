#!/bin/bash

. common_script.sh

if [ "$SECONDS" = "" ] ; then
	export SECONDS=20
fi
if [ "$VPL_GRADEMIN" = "" ] ; then
	export VPL_GRADEMIN=0
	export VPL_GRADEMAX=10
fi

#exist run script?
if [ ! -s vpl_run.sh ] ; then
	echo "I'm sorry, but I haven't a default action to evaluate the type of submitted files"
else

	mv vpl_evaluate.cpp vpl_evaluate.cpp_
    mv functions.h functions.h_
    mv structures.h structures.h_
    mv tests.h tests.h_
	
	get_source_files cpp h hpp
	
	for file in $SOURCE_FILES
	do
	    line=`zgrep -nE "^\s*int\s+main\s*()\s*" $file | cut -f1 -d:`
	    if [[ ! -z $line ]]
	    then
	        main_file="$file"
	        main_line="$line"
	        break
	    fi
	done
	
	mv vpl_evaluate.cpp_ vpl_evaluate.cpp
    mv functions.h_ functions.h
    mv structures.h_ structures.h
    mv tests.h_ tests.h
	
	let prev_line_main=$main_line-1
	head -n $prev_line_main $main_file > a.txt
	cp vpl_evaluate.cpp saved_vpl_evaluate.cpp
	cat a.txt > vpl_evaluate.cpp
	cat saved_vpl_evaluate.cpp >> vpl_evaluate.cpp
	rm -f saved_vpl_evaluate.cpp
	rm -f a.txt

	#avoid conflict with C++ compilation
	./vpl_run.sh

	mv vpl_evaluate.cpp vpl_evaluate.cpp.save
	#Prepare run
	if [ -f vpl_execution ] ; then
		mv vpl_execution vpl_test
		if [ -f vpl_evaluate.cases ] ; then
			mv vpl_evaluate.cases evaluate.cases
		else
			echo "Error need file 'vpl_evaluate.cases' to make an evaluation"
			exit 1
		fi
		#Add constants to vpl_evaluate.cpp
		echo "const float VPL_GRADEMIN=$VPL_GRADEMIN;" >vpl_evaluate.cpp
		echo "const float VPL_GRADEMAX=$VPL_GRADEMAX;" >>vpl_evaluate.cpp
		let VPL_MAXTIME=VPL_MAXTIME-$SECONDS-1;
		echo "const int VPL_MAXTIME=$VPL_MAXTIME;" >>vpl_evaluate.cpp
		cat vpl_evaluate.cpp.save >> vpl_evaluate.cpp
		check_program g++
		g++ -std=c++17 vpl_evaluate.cpp -g -lm -lutil -o .vpl_tester
		mv functions.h functions.h_
		mv tests.h tests.h_
		mv structures.h structures.h_
		mv vpl_evaluate.cpp vpl_evaluate.cpp_
		if [ ! -f .vpl_tester ] ; then
			echo "Error compiling evaluation program"
		else
			echo "#!/bin/bash" >> vpl_execution
			echo "./.vpl_tester" >> vpl_execution
		fi
	else
		echo "#!/bin/bash" >> vpl_execution
		echo "echo" >> vpl_execution
		echo "echo '<|--'" >> vpl_execution
		echo "echo '-$VPL_COMPILATIONFAILED'" >> vpl_execution
		if [ -f vpl_wexecution ] ; then
			echo "echo '======================'" >> vpl_execution
			echo "echo 'It seems you are trying to test a program with a graphic user interface'" >> vpl_execution
		fi
		echo "echo '--|>'" >> vpl_execution		
		echo "echo" >> vpl_execution		
		echo "echo 'Grade :=>>$VPL_GRADEMIN'" >> vpl_execution
	fi
    
    chmod +x vpl_execution
fi








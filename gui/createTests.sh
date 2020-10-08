#!/bin/bash

COMMAND="description"
classes=()
attributes=()
methods=()
functions=()
attributes_sigs=()
methods_sigs=()
functions_sigs=()

rm -f tests.h
touch tests.h

function menu_creater {
	whiptail --title "Framework Menu" --menu "Choose an option" --cancel-button "Exit" 25 90 16 \
				"<-- Back" "Return to previous step." \
				"Add Class" "Define the name of the class you want to test." \
				"Add Attribute" "Define the name of the attribute you want to test." \
				"Add Method" "Define the name of the method or signatures you want to test." \
				"Add Function" "Define the name of the function you want to test." \
				"Create Test" "Create a unit test for classes/functions that you defined." \
				3>&1 1>&2 2>out.txt
	MENU=$(cat out.txt)	
	rm out.txt	
}

function add_class {
	CLASS_NAME=$(whiptail --inputbox "Enter the class name" 8 39 --title "Add Class" 3>&1 1>&2 2>&3)
	if [ -z "$CLASS_NAME" ]; then
		COMMAND="utf"
		return 0
	fi
	classes+=("$CLASS_NAME")
	echo 'CLASS('$CLASS_NAME');' >> tests.h
	whiptail --title "Add Class" --msgbox "Class "$CLASS_NAME" was added successfully!" 8 78
}

function add_attribute {
	whiptail --title "Add Attribute" --menu "Choose an option" --cancel-button "Exit" 25 90 16 \
		"Register            " "Register attribute you want to test." \
		"Signature        " "Register a type for attribute you want to check." \
		3>&1 1>&2 2>out.txt
	MENU=$(cat out.txt)
	rm out.txt
	case $MENU in
		"Register            ")
			ATTRIBUTE_NAME=$(whiptail --inputbox "Enter the attribute name" 8 39 --title "Add Attribute" 3>&1 1>&2 2>&3)
			attributes+=("$ATTRIBUTE_NAME")
			if [ -z "$ATTRIBUTE_NAME" ]; then
				COMMAND="utf"
				return 0
			fi
			echo 'CHECK_CLASS_ATTRIBUTE('$ATTRIBUTE_NAME');' >> tests.h
			whiptail --title "Add Attribute" --msgbox "Attribute "$ATTRIBUTE_NAME" was added successfully!" 8 78
			COMMAND="utf"
			;;
		"Signature        ")
			if [ "${#attributes[@]}" -eq 0 ]; then
				whiptail --title "Attribute Signature" --msgbox "No attributes found!" 8 78
				return 0
			fi
			whiplist_args=''
			for ((i = 0 ; i < ${#attributes[@]} ; i++ )); do
				whiplist_args=$whiplist_args' '${attributes[$i]}' Select_Attribute_'${attributes[$i]}' OFF '
			done
			whiptail --title "Attribute Signature" --radiolist "Select an attribute" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
			ATTRIBUTE_NAME=$(cat out.txt)
			rm out.txt
			if [ -z "$ATTRIBUTE_NAME" ]; then
				COMMAND="utf"
				return 0
			fi
			ATTRIBUTE_TYPE=$(whiptail --inputbox "Enter the type of attribute "$ATTRIBUTE_NAME 8 65 --title "Attribute Signature" 3>&1 1>&2 2>&3)
			if [ -z "$ATTRIBUTE_TYPE" ]; then
				COMMAND="utf"
				return 0
			fi
			TEMPLATE_POSTFIX=$(whiptail --inputbox "Enter an identifier for attribute "$ATTRIBUTE_NAME". REMEMBER IT!" 8 65 --title "Attribute Signature" 3>&1 1>&2 2>&3)
			if [ -z "$TEMPLATE_POSTFIX" ]; then
				COMMAND="utf"
				return 0
			fi
			attributes_sigs+=("$TEMPLATE_POSTFIX")
			echo 'CHECK_CLASS_ATTRIBUTE_SIGNATURE('$ATTRIBUTE_NAME', '$ATTRIBUTE_TYPE' T::*, '$TEMPLATE_POSTFIX');' >> tests.h	
			whiptail --title "Register Signature" --msgbox "Signature for attribute "$ATTRIBUTE_NAME" was added successfully!" 8 78
			COMMAND="utf"
			;;
		*)
			COMMAND="utf"
			;;
	esac
}

function add_method {
	whiptail --title "Add Method" --menu "Choose an option" --cancel-button "Exit" 25 90 16 \
		"Register        " "Register method you want to test." \
		"Signature        " "Register a signature for method you want to check." \
		3>&1 1>&2 2>out.txt
	MENU=$(cat out.txt)
	rm out.txt
	case $MENU in
		"Register        ")
			METHOD_NAME=$(whiptail --inputbox "Enter the method name" 8 39 --title "Register Method" 3>&1 1>&2 2>&3)
			methods+=("$METHOD_NAME")
			if [ -z "$METHOD_NAME" ]; then
				COMMAND="utf"
				return 0
			fi
			echo 'CHECK_CLASS_METHOD('$METHOD_NAME');' >> tests.h
			whiptail --title "Register Method" --msgbox "Method "$METHOD_NAME" was added successfully!" 8 78
			;;
		"Signature        ")
			if [ "${#methods[@]}" -eq 0 ]; then
				whiptail --title "Method Signature" --msgbox "No methods found!" 8 78
				return 0
			fi
			whiplist_args=''
			for ((i = 0 ; i < ${#methods[@]} ; i++ )); do
				whiplist_args=$whiplist_args' '${methods[$i]}' Select_Method_'${methods[$i]}' OFF '
			done
			whiptail --title "Method Signature" --radiolist "Select a method" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
			METHOD_NAME=$(cat out.txt)
			rm out.txt
			if [ -z "$METHOD_NAME" ]; then
				COMMAND="utf"
				return 0
			fi
			RETURN_VALUE=$(whiptail --inputbox "Enter the return type of method "$METHOD_NAME 8 65 --title "Method Signature" 3>&1 1>&2 2>&3)
			if [ -z "$RETURN_VALUE" ]; then
				COMMAND="utf"
				return 0
			fi
			TEMPLATE_POSTFIX=$(whiptail --inputbox "Enter an identifier for method "$METHOD_NAME". REMEMBER IT!" 8 65 --title "Method Signature" 3>&1 1>&2 2>&3)
			if [ -z "$TEMPLATE_POSTFIX" ]; then
				COMMAND="utf"
				return 0
			fi
			methods_sigs+=("$TEMPLATE_POSTFIX")
			NR_INPUT_PARAMETERS=$(whiptail --inputbox "How many parameters method "$METHOD_NAME" has?" 8 65 --title "Method Signature" 3>&1 1>&2 2>&3)
			if [ -z "$NR_INPUT_PARAMETERS" ]; then
				COMMAND="utf"
				return 0
			fi
			ALL_PARAMETERS=""
			for ((i = 1 ; i <= $NR_INPUT_PARAMETERS ; i++ )); do
				PARAMETER=$(whiptail --inputbox "Enter the type of parameter "$i 8 65 --title "Method Signature" 3>&1 1>&2 2>&3)
				if [ -z "$PARAMETER" ]; then
					COMMAND="utf"
					return 0
				fi
				if [ $i == $NR_INPUT_PARAMETERS ]; then
					ALL_PARAMETERS=$ALL_PARAMETERS$PARAMETER
				else
					ALL_PARAMETERS=$ALL_PARAMETERS$PARAMETER','
				fi
			done
			echo 'CHECK_CLASS_METHOD_SIGNATURE('$METHOD_NAME', '$RETURN_VALUE'(T::*)('$ALL_PARAMETERS'), '$TEMPLATE_POSTFIX');' >> tests.h	
			whiptail --title "Register Signature" --msgbox "Signature for method "$METHOD_NAME" was added successfully!" 8 78
			COMMAND="utf"
			;;
		*)
			COMMAND="utf"
			;;
	esac
}

function add_function {
	whiptail --title "Add Function" --menu "Choose an option" --cancel-button "Exit" 25 90 16 \
		"Register        " "Register function you want to test." \
		"Signature        " "Register a signature for function you want to check." \
		3>&1 1>&2 2>out.txt
	MENU=$(cat out.txt)
	rm out.txt
	case $MENU in
		"Register        ")
			FUNCTION_NAME=$(whiptail --inputbox "Enter the function name" 8 39 --title "Register Function" 3>&1 1>&2 2>&3)
			functions+=("$FUNCTION_NAME")
			if [ -z "$FUNCTION_NAME" ]; then
				COMMAND="utf"
				return 0
			fi
			echo 'CHECK_FUNCTION('$FUNCTION_NAME');' >> tests.h
			whiptail --title "Register FUNCTION" --msgbox "Function "$FUNCTION_NAME" was added successfully!" 8 78
			;;
		"Signature        ")
			if [ "${#functions[@]}" -eq 0 ]; then
				whiptail --title "Function Signature" --msgbox "No functions found!" 8 78
				return 0
			fi
			whiplist_args=''
			for ((i = 0 ; i < ${#functions[@]} ; i++ )); do
				whiplist_args=$whiplist_args' '${functions[$i]}' Select_Function_'${functions[$i]}' OFF '
			done
			whiptail --title "Function Signature" --radiolist "Select a function" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
			FUNCTION_NAME=$(cat out.txt)
			rm out.txt
			if [ -z "$FUNCTION_NAME" ]; then
				COMMAND="utf"
				return 0
			fi
			RETURN_VALUE=$(whiptail --inputbox "Enter the return type of function "$METHOD_NAME 8 65 --title "Function Signature" 3>&1 1>&2 2>&3)
			if [ -z "$RETURN_VALUE" ]; then
				COMMAND="utf"
				return 0
			fi
			TEMPLATE_POSTFIX=$(whiptail --inputbox "Enter an identifier for function "$FUNCTION_NAME". REMEMBER IT!" 8 65 --title "Function Signature" 3>&1 1>&2 2>&3)
			if [ -z "$TEMPLATE_POSTFIX" ]; then
				COMMAND="utf"
				return 0
			fi
			functions_sigs+=("$TEMPLATE_POSTFIX")
			NR_INPUT_PARAMETERS=$(whiptail --inputbox "How many parameters function "$FUNCTION_NAME" has?" 8 65 --title "Function Signature" 3>&1 1>&2 2>&3)
			if [ -z "$NR_INPUT_PARAMETERS" ]; then
				COMMAND="utf"
				return 0
			fi
			ALL_PARAMETERS=""
			for ((i = 1 ; i <= $NR_INPUT_PARAMETERS ; i++ )); do
				PARAMETER=$(whiptail --inputbox "Enter the type of parameter "$i 8 65 --title "Function Signature" 3>&1 1>&2 2>&3)
				if [ -z "$PARAMETER" ]; then
					COMMAND="utf"
					return 0
				fi
				if [ $i == $NR_INPUT_PARAMETERS ]; then
					ALL_PARAMETERS=$ALL_PARAMETERS$PARAMETER
				else
					ALL_PARAMETERS=$ALL_PARAMETERS$PARAMETER','
				fi
			done
			echo 'CHECK_FUNCTION_SIGNATURE('$FUNCTION_NAME', '$RETURN_VALUE'(T::*)('$ALL_PARAMETERS'), '$TEMPLATE_POSTFIX');' >> tests.h	
			whiptail --title "Register Signature" --msgbox "Signature for function "$FUNCTION_NAME" was added successfully!" 8 78
			COMMAND="utf"
			;;
		*)
			COMMAND="utf"
			;;
	esac
}

function create_test {
	SUITE_NAME=$(whiptail --inputbox "Enter the suite name" 8 39 --title "Create Test" 3>&1 1>&2 2>&3)
	if [ -z "$SUITE_NAME" ]; then
		COMMAND="utf"
		return 0
	fi
	TEST_NAME=$(whiptail --inputbox "Enter the test name" 8 39 --title "Create Test" 3>&1 1>&2 2>&3)
	if [ -z "$TEST_NAME" ]; then
		COMMAND="utf"
		return 0
	fi
	echo "TEST("$SUITE_NAME", "$TEST_NAME") {" > create_test_tmp.txt
	while true; do
		whiptail --title "Create Test" --menu "Choose an option" --cancel-button "Exit" 25 90 16 \
			"Assert Function" "Test if function exists." \
			"Assert Function Sig" "Test if function has a given signature." \
			"Assert Class" "Test if class exists." \
			"Assert Class Attribute" "Test if class attribute exists." \
			"Assert Class Attribute Sig" "Test if class attribute has a given type." \
			"Assert Class Method" "Test if class method exists." \
			"Assert Class Method Sig" "Test if class method has a given signature." \
			"Assert Class Constructor" "Test if class constructor exists and has a given signature." \
			"Save & Exit" "Save test and return to main menu" \
			3>&1 1>&2 2>out.txt
		MENU=$(cat out.txt)
		rm out.txt
		case $MENU in
			"Assert Function")
				if [ "${#functions[@]}" -eq 0 ]; then
					whiptail --title "Assert Function" --msgbox "No functions found!" 8 78
					continue
				fi
				whiplist_args=''
				for ((i = 0 ; i < ${#functions[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${functions[$i]}' Select_Function_'${functions[$i]}' OFF '
				done
				whiptail --title "Assert Function" --radiolist "Select a function" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				FUNCTION_NAME=$(cat out.txt)
				if [ -z "$FUNCTION_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				MESSAGE=$(whiptail --inputbox "Enter a message if the test fails" 8 39 --title "Assert Function" 3>&1 1>&2 2>&3)
				if [ -z "$MESSAGE" ]; then
					COMMAND="utf"
					continue
				fi
				echo "    ASSERT_FUNCTION("$FUNCTION_NAME", "'"'$MESSAGE'"'") BEGIN {" >> create_test_tmp.txt
				echo "        /* code */" >> create_test_tmp.txt
				echo "    } END" >> create_test_tmp.txt
				whiptail --title "Create Test" --msgbox "Assert for function "$FUNCTION_NAME" was added successfully!" 8 78
				;;
			"Assert Function Sig")
				if [ "${#functions[@]}" -eq 0 ]; then
					whiptail --title "Assert Function Sig" --msgbox "No functions found!" 8 78
					continue
				fi
				whiplist_args=''
				for ((i = 0 ; i < ${#functions[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${functions[$i]}' Select_Function_'${functions[$i]}' OFF '
				done
				whiptail --title "Assert Function" --radiolist "Select a function" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				FUNCTION_NAME=$(cat out.txt)
				if [ -z "$FUNCTION_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				if [ "${#functions_sigs[@]}" -eq 0 ]; then
					whiptail --title "Assert Function Sig" --msgbox "No signatures for functions found!" 8 78
					continue
				fi
				whiplist_args=''
				for ((i = 0 ; i < ${#functions_sigs[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${functions_sigs[$i]}' - OFF '
				done
				whiptail --title "Assert Function Sig" --radiolist "Select a signature for a function. Do you remember them? :)" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				SIGNATURE_NAME=$(cat out.txt)
				if [ -z "$SIGNATURE_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				MESSAGE=$(whiptail --inputbox "Enter a message if the test fails" 8 39 --title "Assert Function Sig" 3>&1 1>&2 2>&3)
				if [ -z "$MESSAGE" ]; then
					COMMAND="utf"
					continue
				fi
				echo "    ASSERT_FUNCTION_SIGNATURE("$FUNCTION_NAME", "$SIGNATURE_NAME", "'"'$MESSAGE'"'") BEGIN {" >> create_test_tmp.txt
				echo "        /* code */" >> create_test_tmp.txt
				echo "    } END" >> create_test_tmp.txt
				whiptail --title "Create Test" --msgbox "Assert signature for function "$FUNCTION_NAME" was added successfully!" 8 78
				;;
			"Assert Class")
				if [ "${#classes[@]}" -eq 0 ]; then
					whiptail --title "Assert Class" --msgbox "No classes found!" 8 78
					continue
				fi
				whiplist_args=''
				for ((i = 0 ; i < ${#classes[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${classes[$i]}' Select_Class_'${classes[$i]}' OFF '
				done
				whiptail --title "Assert Class" --radiolist "Select a class" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				CLASS_NAME=$(cat out.txt)
				if [ -z "$CLASS_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				MESSAGE=$(whiptail --inputbox "Enter a message if the test fails" 8 39 --title "Assert Class" 3>&1 1>&2 2>&3)
				if [ -z "$MESSAGE" ]; then
					COMMAND="utf"
					continue
				fi
				echo "    ASSERT_CLASS("$CLASS_NAME", "'"'$MESSAGE'"'") BEGIN {" >> create_test_tmp.txt
				echo "        /* code */" >> create_test_tmp.txt
				echo "    } END" >> create_test_tmp.txt
				whiptail --title "Create Test" --msgbox "Assert for class "$CLASS_NAME" was added successfully!" 8 78
				;;
			"Assert Class Attribute")
				if [ "${#classes[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Attribute" --msgbox "No classes found!" 8 78
					continue
				fi
				if [ "${#attributes[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Attribute" --msgbox "No attributes found!" 8 78
					continue
				fi
				whiplist_args=''
				for ((i = 0 ; i < ${#classes[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${classes[$i]}' Select_Class_'${classes[$i]}' OFF '
				done
				whiptail --title "Assert Class Attribute" --radiolist "Select a class" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				CLASS_NAME=$(cat out.txt)
				if [ -z "$CLASS_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				whiplist_args=''
				for ((i = 0 ; i < ${#attributes[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${attributes[$i]}' Select_Attribute_'${attributes[$i]}' OFF '
				done
				whiptail --title "Assert Class Attribute" --radiolist "Select an attribute" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				ATTRIBUTE_NAME=$(cat out.txt)
				if [ -z "$ATTRIBUTE_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				MESSAGE=$(whiptail --inputbox "Enter a message if the test fails" 8 39 --title "Assert Class Attribute" 3>&1 1>&2 2>&3)
				if [ -z "$MESSAGE" ]; then
					COMMAND="utf"
					continue
				fi
				echo "    ASSERT_CLASS_ATTRIBUTE("$CLASS_NAME", "$ATTRIBUTE_NAME", "'"'$MESSAGE'"'") BEGIN {" >> create_test_tmp.txt
				echo "        /* code */" >> create_test_tmp.txt
				echo "    } END" >> create_test_tmp.txt
				whiptail --title "Create Test" --msgbox "Assert for class "$CLASS_NAME" for attribute "$ATTRIBUTE_NAME" was added successfully!" 8 78
				;;
			"Assert Class Attribute Sig")
				if [ "${#classes[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Attribute Sig" --msgbox "No classes found!" 8 78
					continue
				fi
				if [ "${#attributes[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Attribute Sig" --msgbox "No attributes found!" 8 78
					continue
				fi
				if [ "${#attributes_sigs[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Attribute Sig" --msgbox "No attributes signatures found!" 8 78
					continue
				fi
				whiplist_args=''
				for ((i = 0 ; i < ${#classes[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${classes[$i]}' Select_Class_'${classes[$i]}' OFF '
				done
				whiptail --title "Assert Class Attribute Sig" --radiolist "Select a class" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				CLASS_NAME=$(cat out.txt)
				if [ -z "$CLASS_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				whiplist_args=''
				for ((i = 0 ; i < ${#attributes[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${attributes[$i]}' Select_Attribute_'${attributes[$i]}' OFF '
				done
				whiptail --title "Assert Class Attribute Sig" --radiolist "Select an attribute" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				ATTRIBUTE_NAME=$(cat out.txt)
				if [ -z "$ATTRIBUTE_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				whiplist_args=''
				for ((i = 0 ; i < ${#attributes_sigs[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${attributes_sigs[$i]}' - OFF '
				done
				whiptail --title "Assert Class Attributes Sig" --radiolist "Select a type for attribute. Do you remember them? :)" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				SIGNATURE_NAME=$(cat out.txt)
				if [ -z "$SIGNATURE_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				MESSAGE=$(whiptail --inputbox "Enter a message if the test fails" 8 39 --title "Assert Class Attribute Sig" 3>&1 1>&2 2>&3)
				if [ -z "$MESSAGE" ]; then
					COMMAND="utf"
					continue
				fi
				echo "    ASSERT_CLASS_ATTRIBUTE_SIGNATURE("$CLASS_NAME", "$ATTRIBUTE_NAME", "$SIGNATURE_NAME", "'"'$MESSAGE'"'") BEGIN {" >> create_test_tmp.txt
				echo "        /* code */" >> create_test_tmp.txt
				echo "    } END" >> create_test_tmp.txt
				whiptail --title "Create Test" --msgbox "Assert signature for attribute "$ATTRIBUTE_NAME" in class "$CLASS_NAME" was added successfully!" 8 78
				;;
			"Assert Class Method")
				if [ "${#classes[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Method" --msgbox "No classes found!" 8 78
					continue
				fi
				if [ "${#methods[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Method" --msgbox "No methods found!" 8 78
					continue
				fi
				whiplist_args=''
				for ((i = 0 ; i < ${#classes[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${classes[$i]}' Select_Class_'${classes[$i]}' OFF '
				done
				whiptail --title "Assert Class Method" --radiolist "Select a class" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				CLASS_NAME=$(cat out.txt)
				if [ -z "$CLASS_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				whiplist_args=''
				for ((i = 0 ; i < ${#methods[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${methods[$i]}' Select_Method_'${methods[$i]}' OFF '
				done
				whiptail --title "Assert Class Method" --radiolist "Select a method" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				METHOD_NAME=$(cat out.txt)
				if [ -z "$METHOD_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				MESSAGE=$(whiptail --inputbox "Enter a message if the test fails" 8 39 --title "Assert Class Method" 3>&1 1>&2 2>&3)
				if [ -z "$MESSAGE" ]; then
					COMMAND="utf"
					continue
				fi
				echo "    ASSERT_CLASS_METHOD("$CLASS_NAME", "$METHOD_NAME", "'"'$MESSAGE'"'") BEGIN {" >> create_test_tmp.txt
				echo "        /* code */" >> create_test_tmp.txt
				echo "    } END" >> create_test_tmp.txt
				whiptail --title "Create Test" --msgbox "Assert for class "$CLASS_NAME" for method "$METHOD_NAME" was added successfully!" 8 78
				;;
			"Assert Class Method Sig")
				if [ "${#classes[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Method Sig" --msgbox "No classes found!" 8 78
					continue
				fi
				if [ "${#methods[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Method Sig" --msgbox "No methods found!" 8 78
					continue
				fi
				if [ "${#methods_sigs[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Method Sig" --msgbox "No methods signatures found!" 8 78
					continue
				fi
				whiplist_args=''
				for ((i = 0 ; i < ${#classes[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${classes[$i]}' Select_Class_'${classes[$i]}' OFF '
				done
				whiptail --title "Assert Class Method Sig" --radiolist "Select a class" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				CLASS_NAME=$(cat out.txt)
				if [ -z "$CLASS_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				whiplist_args=''
				for ((i = 0 ; i < ${#methods[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${methods[$i]}' Select_Method_'${methods[$i]}' OFF '
				done
				whiptail --title "Assert Class Method Sig" --radiolist "Select a method" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				METHOD_NAME=$(cat out.txt)
				if [ -z "$METHOD_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				whiplist_args=''
				for ((i = 0 ; i < ${#methods_sigs[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${methods_sigs[$i]}' - OFF '
				done
				whiptail --title "Assert Class Method Sig" --radiolist "Select a signature for method. Do you remember them? :)" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				SIGNATURE_NAME=$(cat out.txt)
				if [ -z "$SIGNATURE_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
				MESSAGE=$(whiptail --inputbox "Enter a message if the test fails" 8 39 --title "Assert Class Method Sig" 3>&1 1>&2 2>&3)
				if [ -z "$MESSAGE" ]; then
					COMMAND="utf"
					continue
				fi
				echo "    ASSERT_CLASS_METHOD_SIGNATURE("$CLASS_NAME", "$METHOD_NAME", "$SIGNATURE_NAME", "'"'$MESSAGE'"'") BEGIN {" >> create_test_tmp.txt
				echo "        /* code */" >> create_test_tmp.txt
				echo "    } END" >> create_test_tmp.txt
				whiptail --title "Create Test" --msgbox "Assert signature for method "$METHOD_NAME" in class "$CLASS_NAME" was added successfully!" 8 78
				;;
			"Assert Class Constructor")
		        if [ "${#classes[@]}" -eq 0 ]; then
					whiptail --title "Assert Class Constructor" --msgbox "No classes found!" 8 78
					continue
				fi
		        whiplist_args=''
				for ((i = 0 ; i < ${#classes[@]} ; i++ )); do
					whiplist_args=$whiplist_args' '${classes[$i]}' Select_Class_'${classes[$i]}' OFF '
				done
				whiptail --title "Assert Class Constructor" --radiolist "Select a class" 20 78 13 $whiplist_args 3>&1 1>&2 2>out.txt
				CLASS_NAME=$(cat out.txt)
				if [ -z "$CLASS_NAME" ]; then
					COMMAND="utf"
					continue
				fi
				rm out.txt
		        NR_INPUT_PARAMETERS=$(whiptail --inputbox "How many parameters constructor of class "$CLASS_NAME" has?" 8 65 --title "Assert Class Constructor" 3>&1 1>&2 2>&3)
				if [ -z "$NR_INPUT_PARAMETERS" ]; then
					COMMAND="utf"
					return 0
				fi
				ALL_PARAMETERS=""
				for ((i = 1 ; i <= $NR_INPUT_PARAMETERS ; i++ )); do
					PARAMETER=$(whiptail --inputbox "Enter the type of parameter "$i 8 65 --title "Assert Class Constructor" 3>&1 1>&2 2>&3)
					if [ -z "$PARAMETER" ]; then
						COMMAND="utf"
						return 0
					fi
					if [ $i == $NR_INPUT_PARAMETERS ]; then
						ALL_PARAMETERS=$ALL_PARAMETERS$PARAMETER
					else
						ALL_PARAMETERS=$ALL_PARAMETERS$PARAMETER','
					fi
				done
		        MESSAGE=$(whiptail --inputbox "Enter a message if the test fails" 8 39 --title "Assert Class Constructor" 3>&1 1>&2 2>&3)
				if [ -z "$MESSAGE" ]; then
					COMMAND="utf"
					continue
				fi
		        echo "    ASSERT_CLASS_CONSTRUCTOR("'"'$MESSAGE'"'", "$CLASS_NAME", "$ALL_PARAMETERS") BEGIN {" >> create_test_tmp.txt
				echo "        /* code */" >> create_test_tmp.txt
				echo "    } END" >> create_test_tmp.txt
				whiptail --title "Create Test" --msgbox "Assert constructor for class "$CLASS_NAME" was added successfully!" 8 78	        	
				;;
			"Save & Exit")
				if (whiptail --title "Save & Exit" --yesno "Do you want to save changes?" 8 78); then
					whiptail --title "Save & Exit" --msgbox "Test "$SUITE_NAME"::"$TEST_NAME" was created!" 8 78
					echo "}" >> create_test_tmp.txt
					cat create_test_tmp.txt >> tests.h
					rm create_test_tmp.txt
					COMMAND="utf"
					break
				else
					continue
				fi
				;;
			*)
				if (whiptail --title "Close" --yesno "Your changes will be lost. Do you want to return to main menu?" 8 78); then
					break
				fi
				;;
		esac
	done
}

while true; do
	case $COMMAND in 
		"description") 
			whiptail --title "Unit Test Framework Creater" --msgbox "You can create custom test for VPL Moodle using this script. Press OK to continue." 8 78
			COMMAND="utf"
			;;
		"utf")
			menu_creater		
			case $MENU in
				"<-- Back")
					COMMAND="description"
					;;
				"Add Class")
					add_class
					;;
				"Add Attribute")
					add_attribute
					;;
				"Add Method")
					add_method
					;;
				"Add Function")
					add_function
					;;
				"Create Test")			
					create_test
					;;
				*)
					break
					;;
			esac
					
			;;
		*)
			break
			;;
	esac
done


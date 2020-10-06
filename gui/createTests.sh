#!/bin/bash

COMMAND="description"
attributes=()
methods=()
functions=()

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
	FUNCTION_NAME=$(whiptail --inputbox "Enter the function name" 8 65 --title "Add Function" 3>&1 1>&2 2>&3)
	if [ -z "$FUNCTION_NAME" ]; then
		COMMAND="utf"
		return 0
	fi
	RETURN_VALUE=$(whiptail --inputbox "Enter the return type of function "$FUNCTION_NAME 8 65 --title "Add Function" 3>&1 1>&2 2>&3)
	if [ -z "$RETURN_VALUE" ]; then
		COMMAND="utf"
		return 0
	fi
	NR_INPUT_PARAMETERS=$(whiptail --inputbox "How many parameters function "$FUNCTION_NAME" has?" 8 65 --title "Add Function" 3>&1 1>&2 2>&3)
	if [ -z "$NR_INPUT_PARAMETERS" ]; then
		COMMAND="utf"
		return 0
	fi
	ALL_PARAMETERS=""
	for ((i = 1 ; i <= $NR_INPUT_PARAMETERS ; i++ )); do
		PARAMETER=$(whiptail --inputbox "Enter the type of parameter "$i 8 65 --title "Add Function" 3>&1 1>&2 2>&3)
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
	echo $RETURN_VALUE' '$FUNCTION_NAME'('$ALL_PARAMETERS') __attribute__((weak));' >> tests.h
	whiptail --title "Add Function" --msgbox "Function "$FUNCTION_NAME" was added successfully!" 8 78
	COMMAND="utf"
}

function create_test {
	echo "asdf"
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


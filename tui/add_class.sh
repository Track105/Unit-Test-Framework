#!/bin/bash

source ./common.sh

function add_class {
	local -n classes=$1
	
	get_integer NR_CLASSES "Register class" "How many classes do you want to register?" "Invalid value! Enter a positive integer."
	get_types classes CLASSES NR_CLASSES "Register class" "Enter the name of class" "Invalid name! Enter a valid class name."
	
	for ((i = 0 ; i < ${#classes[@]} ; i++ )); do
		echo -e 'CLASS('${classes[$i]}');\n' >> tests.h
	done	
	
	if [ $NR_CLASSES -eq 0 ]; then
		whiptail --title "Add Class" --msgbox "No class added! You can assert only functions." 8 78
	elif [ $NR_CLASSES -eq 1 ]; then
		whiptail --title "Add Class" --msgbox "Class $CLASSES was added successfully!" 8 78
	else
		whiptail --title "Add Class" --msgbox "Classes $CLASSES were added successfully!" 8 78
	fi
}


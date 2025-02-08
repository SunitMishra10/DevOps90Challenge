#!/bin/bash
<<info

Implement an option -c or --create that allows the script to create a new user account. The script should prompt the user to enter the new username and password.

Ensure that the script checks whether the username is available before creating the account. If the username already exists, display an appropriate message and exit gracefully.

After creating the account, display a success message with the newly created username.

Part 2: Account Deletion
Implement an option -d or --delete that allows the script to delete an existing user account. The script should prompt the user to enter the username of the account to be deleted.

Ensure that the script checks whether the username exists before attempting to delete the account. If the username does not exist, display an appropriate message and exit gracefully.

After successfully deleting the account, display a confirmation message with the deleted username.

Part 3: Password Reset
Implement an option -r or --reset that allows the script to reset the password of an existing user account. The script should prompt the user to enter the username and the new password.

Ensure that the script checks whether the username exists before attempting to reset the password. If the username does not exist, display an appropriate message and exit gracefully.

After resetting the password, display a success message with the username and the updated password.

Part 4: List User Accounts
Implement an option -l or --list that allows the script to list all user accounts on the system. The script should display the usernames and their corresponding user IDs (UID).
Part 5: Help and Usage Information
Implement an option -h or --help that displays usage information and the available command-line options for the script.
Bonus Points (Optional)
If you want to challenge yourself further, you can add additional features to the script, such as:

Displaying more detailed information about user accounts (e.g., home directory, shell, etc.).
Allowing the modification of user account properties (e.g., username, user ID, etc.).
Remember to handle errors gracefully, provide appropriate user prompts, and add comments to explain the logic and purpose of each part of the script.

info


create_user () {
        read -p "Enter the user you want to create " username
	read -s -p "Enter the password " password
	list_of_users=$(cat /etc/passwd | grep $username | wc | awk '{ print $1 }')
        if [ $list_of_users -eq 0 ]; then
		echo -e "\nCreating user "
		sudo useradd -m $username
                echo -e "$password\n$password" | sudo passwd $username
		echo "User created successfully "
		exit 0
        else
		echo -e "\nUser already exists "
		exit 0
	fi

}


delete_user () {
        read -p "Enter the user you want to delete " username
        list_of_users=$(cat /etc/passwd | grep $username | wc | awk '{ print $1 }')
        if [ $list_of_users -eq 0 ]; then
		echo -e "\nUser doesn't exist "
		exit 0

        else
		echo -e "\nDeleting user "
                sudo userdel -r $username
                echo "User deleted successfully "
		exit 0
        fi


}

reset_password () {
        read -p "Enter the username whose password you want to reset " username
        list_of_users=$(cat /etc/passwd | grep $username | wc | awk '{ print $1 }')
        if [ $list_of_users -eq 0 ]; then
                echo -e "\nUser doesn't exist "
		exit 0

        else
                
		read -s -p "Enter the password " password1
		echo -e "\n"
		read -s -p "Enter the password again " password2
		echo -e "\n"
		if [ $password1 == $password2 ]; then

                	echo -e "$password1\n$password1" | sudo passwd $username
                	echo "Password reset successfully "
			exit 0
	        else
			echo "Passwords do not match "
			exit 0

		fi
	
        fi


}

print_info (){
	read -p "Enter the username whose information you want to retrieve " username
        list_of_users=$(cat /etc/passwd | grep $username | wc | awk '{ print $1 }')
        if [ $list_of_users -eq 0 ]; then
                echo -e "\nUser doesn't exist "
                exit 0

        else
		homedirectory=$(cat /etc/passwd | grep $username | awk -F: '{ print $6 }')
		shell=$(cat /etc/passwd | grep $username | awk -F: '{ print $7 }')
		echo "Home Directory of $username: $homedirectory"
		echo "Shell of $username: $shell"


        fi

}
if [ $1 == "-c" ] || [ $1 == "--create" ]; then
	echo "Creation was selected"
	create_user
elif [ $1 == "-d" ] || [ $1 == "--delete" ]; then
	echo "Deletion was seleted"
	delete_user
elif [ $1 == "-r" ] || [ $1 == "--reset" ];  then
	echo "Password reset selected"
	reset_password

elif [ $1 == "-l" ] || [ $1 == "--list" ]; then
	list_of_users=$(awk -F: '{ print $1, $3 }' /etc/passwd)
	echo "$list_of_users"

elif [ $1 == "-i" ] || [ $1 == "--info" ]; then
        print_info

elif [ $1 == "-h" ] || [ $1 == "--help" ]; then
        echo "Usage: $0 [options]"
    	echo
    	echo "Options:"
    	echo "  -h, --help      Display this help message"
    	echo "  -l, --list      Display username and UID"
    	echo "  -c, --create    Create new user"
    	echo "  -d, --delete    Delete an existing user"
    	echo "  -r, --reset     Reset password for an existing user"
    	echo "  -i, --info      Give information about a user"
fi


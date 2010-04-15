#!/bin/bash

while selection=$(zenity --title="Usermanager" --list --column "id" --column "Please select" --hide-column=1 --text="What do you want to do?" "add" "Add a user" "remove" "Remove a user" ); do
  if [ ${selection} = "add" ]; then
	echo "Add user"
	if name=$(zenity --title="Enter full name" --entry --text "Please enter a full name for the new user.") ; then
	  username_guess=$(echo "$name" | cut -d" " -f1 | tr A-Z a-z)

	  if username=$(zenity --title="Enter the new username" --entry --text "Please choose a short username.\n\nIt should be all lowercase and contain only letters and numbers." --entry-text "$username_guess") || [ "x$username" = "x" ] ; then

	    while ! useradd -c "$name,,," -G adm,audio,video,wheel,netdev,plugdev,users "$username" ; do
	      username=$(zenity --title="Please check username" --entry --text "Please ensure that your username consists of only\nletters and numbers and is not already in use on the system." --entry-text "$username")
	    done

	    password=""
	    while [ x$password = x ] ; do
	      password1=$(zenity --title=Password --entry --text="Please choose a new password." --hide-text)
	      password2=$(zenity --title=Confirm --entry --text="Confirm your new password." --hide-text)
	      if [ $password1 != $password2 ] ; then 
		zenity --title="Error" --error --text="The passwords do not match.\n\nPlease try again." --timeout 6
	      else 
		if [ x$password1 = x ] ; then
			zenity --title="Error" --error --text="Password cannot be blank!\n\nPlease try again." --timeout 6
		else
			password=$password1
		fi
	      fi
	    done

passwd "$username" <<EOF
$password
$password
EOF
	    if zenity --question --title="User created" --text="The user $username has been successfully created.\n\nDo you want to set this user as default user for the login?" --ok-label="Yes, please!" --cancel-label="No, keep the old user as default"; then
	      sed -i "s/.*default_user.*/default_user $username/g" /etc/slim.conf
	    fi
	    zenity --info --title="User created" --text "Thanks. The new user can now be used." --timeout 6
	  fi
	fi
  elif [ ${selection} = "remove" ]; then
        xfceuser=$(ps u -C xfce4-session | tail -n1 | awk '{print $1}')
        echo "Remove User"
	amount=$(cat /etc/passwd | grep /home/ | grep -v root | awk -F\: '{print $1 }' | wc -l)
	if [ ${amount} = "1" ]; then
	      zenity --title="Error" --error --text="Sorry! You can't remove the last normal user!" --timeout 6
	else
	      if selection=$(cat /etc/passwd | grep /home/ | grep -v root | grep -v $xfceuser | awk -F\: '{print $1 }' | zenity --width=100 --height=200 --title="Select the user to delete" --list  --column "Username"  --text "Select the user to delete\n\nPlease note: You can't remove the user that is currently logged in.") ; then
	        if zenity --question --title="Confirm User Removal" --text="Are you REALLY sure you want to remove the user $selection?\n\nThere will be NO other confirmation and this can NOT be undone!" --ok-label="Yes, remove user!" --cancel-label="Don't remove the user"; then
		  echo "Really remove $selection"
		  userdel -fr $selection
		  sed -i "s/.*default_user $selection/default_user/g" /etc/slim.conf
		  zenity --info --title="User removed" --text "The user $selection has been removed." --timeout 6
	        else
		  echo "Don't remove $selection"
		  zenity --info --title="User not removed" --text "Cancelled removal of user $selection at user's request." --timeout 6
               fi
	    fi
	fi
  fi
done




#########################################################################
#                                                                       #
#       Name of Script: samba-server-cli                                #
#       Description: Samba Server Administration                        #
#       Autor: Jose Manuel Afonso Santana                               #
#       Alias: joseafon                                                 #
#       Email: jmasantana@linuxmail.org                                 #
#                                                                       #
#########################################################################


#!/bin/sh

clear

which apt > /dev/null 2>&1

if [ $? -ne 0 ]
then

    echo  "\e[31mYour operative system is not compatible with this script\e[0m"

    exit 1

fi

if [ $USER != 'root' ]
then

echo "\e[31mYou need privileges of administrator\e[0m"

	exit 1
fi

echo "\e[92m
███████╗ █████╗ ███╗   ███╗██████╗  █████╗           
██╔════╝██╔══██╗████╗ ████║██╔══██╗██╔══██╗          
███████╗███████║██╔████╔██║██████╔╝███████║          
╚════██║██╔══██║██║╚██╔╝██║██╔══██╗██╔══██║          
███████║██║  ██║██║ ╚═╝ ██║██████╔╝██║  ██║          
╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚═╝  ╚═╝          
    ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ 
    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
    ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
    ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
    ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
    ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝
         ██████╗██╗     ██╗                          
        ██╔════╝██║     ██║                          
        ██║     ██║     ██║                          
        ██║     ██║     ██║                          
        ╚██████╗███████╗██║                          
         ╚═════╝╚══════╝╚═╝                          
\e[0m"
echo

echo "\e[96mChecking the network connection ...\e[0m"

	ping -c 3 8.8.8.8 > /dev/null 2>&1

	if [ $? -ne 0 ]
	then
        echo
		echo "\e[31mThe network connection failed, trying to connect to the gateway ...\e[0m"

		gateway=$(ip route show | sed -n 1p | awk '{print $3}')

		ping -c 3 $gateway > /dev/null 2>&1

			if [ $? -ne 0 ]
			then
				echo
				echo "\e[31mImpossible to connect to the gateway\e[0m"
				sleep 3
                clear

				exit 1
			fi

	else
        echo
		echo "\e[96mDone\e[0m"
        echo
        echo "\e[96mInstalling system updates, please wait...\e[0m"

        apt-get update -y > /dev/null 2>&1
        apt-get upgrade -y > /dev/null 2>&1
        dpkg --configure -a
        apt-get autoremove -y > /dev/null 2>&1

        echo
		echo "\e[96mDone\e[0m"

		sleep 3
	fi

echo

	which smbd > /dev/null 2>&1

	if [ $? -ne 0 ]
	then
		echo "\e[96mInstalling Samba, please wait...\e[0m"

        apt-get install -y samba > /dev/null 2>&1
		apt-get install -y smbclient > /dev/null 2>&1
		apt-get clean

        # Enable name server for NetBIOS
        # Save the line number for wins support
        wins_line=$(sed -n '/wins support =/=' /etc/samba/smb.conf)

        # Remove the line and replace it with the new value
        sed -i ''$wins_line'd' /etc/samba/smb.conf
        sed -i ''$wins_line'i\wins support = yes\' /etc/samba/smb.conf

        # Copy of the original file
        cp /etc/samba/smb.conf /etc/samba/smb.conf.original

        # Create directories to save folders shares
        mkdir -p $PWD/private $PWD/public

        # Create directory to save configuration of shaders folders
        mkdir -p $PWD/resources

        # Create directory to save the groups to who the user belongs
        mkdir -p $PWD/group

        else
            echo
            echo "\e[96mSamba is installed\e[0m"
	fi

	while :
	do
		clear
		echo "\e[92m
███╗   ███╗ █████╗ ██╗███╗   ██╗
████╗ ████║██╔══██╗██║████╗  ██║
██╔████╔██║███████║██║██╔██╗ ██║
██║╚██╔╝██║██╔══██║██║██║╚██╗██║
██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
███╗   ███╗███████╗███╗   ██╗██╗   ██╗
████╗ ████║██╔════╝████╗  ██║██║   ██║
██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝

CHOOSE A OPTION

#############################################
#                                           #
# [1] PUBLIC FOLDERS                        #
#                                           #
# [2] PRIVATE FOLDERS                       #
#                                           #
# [3] USERS                                 #
#                                           #
# [4] SAMBA RESOURCES                       #
#                                           #
# [0] EXIT                                  #
#                                           #
#############################################
\e[0m"
echo
	read option1

        case $option1 in

            1) while :
            do
                clear
                echo "\e[92m
+------------------------------------------------------+
|                                                      |
|                  PUBLIC FOLDERS                      |
|                                                      |
+------------------------------------------------------+
|                                                      |
| Press [1] to create public folder                    |
|                                                      |
| Press [2] to delete public folder                    |
|                                                      |
| Press [0] to return to the main menu                 |
|                                                      |
+------------------------------------------------------+
\e[0m"
                echo

                read option2

	                case $option2 in

		                1) clear
                                echo "\e[92m
+--------------------------------------------------+
|                                                  |
|                CREATE PUBLIC FOLDER              |
|                                                  |
+--------------------------------------------------+
\e[0m"
                                echo
                                echo "\e[96mTHESE ARE THE PUBLIC FOLDERS CREATED\e[0m"
                                echo "\e[96m------------------------------------------------------------\e[0m"
                                echo

                                    ls $PWD/public

                                echo
                                echo "\e[96m------------------------------------------------------------\e[0m"

                                echo "\e[96mEnter the name of the folder share\e[0m"
                                echo
			                        read directory

			                        if [ -d $PWD/public/"$directory" ]
			                        then
                                    echo
				                    echo "\e[31mThe folder $directory already exists\e[0m"
				                    sleep 2

			                        else
				                        mkdir -p $PWD/public/"$directory"
				                        chmod 777 $PWD/public/"$directory"

				                        echo "
["$directory"]
path = $PWD/public/"$directory"
comment = Public Folder
browseable = yes
writable = yes
guest ok = yes
create mode 0777
directory mode = 0777
" >> /etc/samba/smb.conf

                                        # Save the configuration of shared folder
                                        touch $PWD/resources/"$directory".conf

                                        echo "
["$directory"]
path = $PWD/public/"$directory"
comment = Public Folder
browseable = yes
writable = yes
guest ok = yes
create mode 0777
directory mode = 0777
" >> $PWD/resources/"$directory".conf

                                        echo
				                        echo "\e[96mThe folder $directory has been created\e[0m"
				                        sleep 2

			                        fi
			                        ;;



                    2) clear
                            echo "\e[92m
+--------------------------------------------------+
|                                                  |
|                DELETE PUBLIC FOLDER              |
|                                                  |
+--------------------------------------------------+
\e[0m"
                        echo
                        echo "\e[96mTHESE ARE THE PUBLIC FOLDERS CREATED\e[0m"
                        echo "\e[96m------------------------------------------------------------\e[0m"
                        echo

                       		 ls $PWD/public

                        echo
                        echo "\e[96m------------------------------------------------------------\e[0m"
                        echo
		                echo "\e[96mEnter the name of the folder to delete\e[0m"
		                echo

		                read directory

		                if [ -d $PWD/public/"$directory" ]
		                then
			                echo
                                # Delete public folder
				                rm -r $PWD/public/"$directory"

                                # Save the line number of the WORKING GROUP
                                line=$(sed -n '/workgroup =/=' /etc/samba/smb.conf)

                                # Save the name of the current WORKING GROUP
                                workgroup=$(sed -n ''$line'p' /etc/samba/smb.conf | awk '{print $3}')

                                # Delete the Samba configuration file
                                rm /etc/samba/smb.conf

                                # Delete the configuration of the folder share
                                rm $PWD/resources/"$directory".conf

                                # Copy the original Samba file
                                cp /etc/samba/smb.conf.original /etc/samba/smb.conf

                                # Delete the line where the WORK GROUP in the original file
                                sed -i ''$line'd' /etc/samba/smb.conf

                               # Replaces the name of the WORKING GROUP that comes by default with the one previously used, saved in the workgroup variable
                                sed -i ''$line'i\workgroup = '$workgroup'\' /etc/samba/smb.conf

                                # Save the output of all shared resource settings in the new Samba file
                                cat $PWD/resources/*.conf >> /etc/samba/smb.conf 2>&1

                                echo
				                echo "\e[96mThe $directory folder has been deleted\e[0m"
				                sleep 2

                                systemctl restart smbd
		                else

			                echo
				            echo "\e[31mThe $directory folder does not exist\e[0m"
				            sleep 2

		                fi
		                ;;

                    0) clear
                        echo "\e[96mYOU RETURN TO THE MAIN MENU\e[0m"
                        sleep 2
                        break
                        ;;

                    *) clear
                        echo
                        echo "\e[31mOPTION NOT VALID\e[0m"
                        sleep 2
                        ;;

                    esac

                done
            ;;

            2) while :
                do
                    clear

                         echo "\e[92m
+----------------------------------------------------+
|                                                    |
|                 PRIVATE FOLDERS                    |
|                                                    |
+----------------------------------------------------+
|                                                    |
| Press [1] to create private folder                 |
|                                                    |
| Press [2] to delete private folder                 |
|                                                    |
| Press [3] to show users of folders                 |
|                                                    |
| Press [0] to return to the main menu               |
|                                                    |
+----------------------------------------------------+
\e[0m"
                        read option2

                        clear

                        case $option2 in

	                    1) clear
                                echo "\e[92m
+--------------------------------------------------+
|                                                  |
|               CREATE PRIVATE FOLDER              |
|                                                  |
+--------------------------------------------------+
\e[0m"
		                    echo
                            echo "\e[96mTHESE ARE THE PRIVATE FOLDERS CREATED\e[0m"
                            echo "\e[96m------------------------------------------------------------\e[0m"
                            echo

                                ls $PWD/private

                            echo
                            echo "\e[96m------------------------------------------------------------\e[0m"
                            echo
                            echo "\e[93mREMEMBER YOU NEED TO CREATE A USER AND ADD IT TO THIS FOLDER TO ACCESS THIS RESOURCE\e[0m"
                            echo
			                echo "\e[96mEnter the name of the private folder to create\e[0m"
			                echo

			                read directory

			                if [ -d $PWD/private/"$directory" ]
			                then
				                echo
					            echo "\e[31mThe $directory folder already exists\e[0m"
					            sleep 2

			                else

				                groupadd $directory > /dev/null 2>&1

                                if [ $? -ne 0 ]
                                then
                                    echo
                                    echo "\e[93mDo not use spaces to create folders\e[0m"
                                    sleep 2

                                else
                                    echo
                                    echo "\e[96mEnter a comment to define the share. Example: computer department\e[0m"
                                    echo

                                    read comment

				                    mkdir -p $PWD/private/$directory

				                    chgrp $directory $PWD/private/$directory

				                    chmod 770 $PWD/private/$directory

                                    # Create a file where the user save his groups
                                    touch $PWD/group/$directory

				                    echo "
[$directory]
path = $PWD/private/$directory
comment = $comment
browseable = yes
guest ok = no
writable = yes
create mode = 0770
directory mode = 0770
write list = @$directory" >> /etc/samba/smb.conf

                                # File is created where the share configuration is saved
                                touch $PWD/resources/$directory.conf

                                echo "
[$directory]
path = $PWD/private/$directory
comment = $comment
browseable = yes
guest ok = no
writable = yes
create mode = 0770
directory mode = 0770
write list = @$directory" >> $PWD/resources/$directory.conf

                                echo
	                            echo "\e[96mThe private folder $directory has been created\e[0m"
	                            sleep 2

			                    fi

                            fi
			                ;;

	                    2) clear
                                echo "\e[92m
+--------------------------------------------------+
|                                                  |
|               DELETE PRIVATE FOLDER              |
|                                                  |
+--------------------------------------------------+
\e[0m"
		                        echo
                                echo "\e[96mTHESE ARE THE PRIVATE FOLDERS CREATED\e[0m"
                                echo "\e[96m------------------------------------------------------------\e[0m"
                                echo

                                    ls $PWD/private

                                echo
                                echo "\e[96m------------------------------------------------------------\e[0m"
                                echo
			                    echo "\e[96mEnter the name of the folder you want to delete\e[0m"
			                    echo

			                        read directory

			                    if [ -d $PWD/private/$directory ]
			                    then

                                    delgroup $directory > /dev/null 2>&1

				                    rm -r $PWD/private/$directory

                                    # Save the line number of the WORKING GROUP in the variable
                                    line=$(sed -n '/workgroup =/=' /etc/samba/smb.conf)

                                    # Save the name of the current WORKING GROUP
                                    workgroup=$(sed -n ''$line'p' /etc/samba/smb.conf | awk '{print $3}')

                                   # Delete Samba configuration file
                                    rm /etc/samba/smb.conf

                                   # Clear the share record
                                    rm $PWD/resources/"$directory".conf

                                    # Copy the original Samba file
                                    cp /etc/samba/smb.conf.original /etc/samba/smb.conf

                                    # Delete the line where the WORK GROUP is located in the original file
                                    sed -i ''$line'd' /etc/samba/smb.conf

                                    # Replaces the name of the WORKING GROUP that comes by default with the one previously used, saved in the workgroup variable
                                    sed -i ''$line'i\workgroup = '$workgroup'\' /etc/samba/smb.conf

                                    # Save the output of all shared resource settings in the new Samba file
                                    cat $PWD/resources/*.conf >> /etc/samba/smb.conf 2>&1

                                    # Delete the record that stores the names of the users 
                                    rm -r $PWD/group/$directory

				                    echo
				                    echo "\e[96mThe $directory folder has been deleted\e[0m"

				                    sleep 2

                                    systemctl restart smbd

			                    else

				                    echo
					                echo "\e[31mThe $directory folder does not exist\e[0m"
					                sleep 2

			                    fi
			            ;;


                        3) clear
                                echo "\e[92m
+--------------------------------------------------+
|                                                  |
|             USERS OF PRIVATE FOLDERS             |
|                                                  |
+--------------------------------------------------+
\e[0m"
                                echo
                                echo "\e[96mTHESE ARE THE PRIVATE FOLDERS CREATED\e[0m"
                                echo "\e[96m------------------------------------------------------------\e[0m"
                                echo

                                    ls $PWD/private

                                echo
                                echo "\e[96m------------------------------------------------------------\e[0m"

                                echo "\e[96mEnter the name of the folder\e[0m"
                                echo

                                read directory

                                if [ -f $PWD/group/$directory ]
                                then
                                    clear
                                    echo "\e[93mPRESS Q TO EXIT\e[0m"
                                    echo
                                    echo "\e[96mUsers of the $directory folder\e[0m"
                                    echo "\e[96m---------------------------------------------------------\e[0m"
                                    echo
                                        less $PWD/group/$directory

                                else
                                    echo
                                    echo "\e[31mThe $directory folder has no users or does not exist\e[0m"
                                    sleep 2
                                fi
                        ;;

                        0) clear
                                echo "\e[96mRETURN TO THE MAIN MENU\e[0m"
                                sleep 2
                                break
                                ;;

                        *) clear
                                echo "\e[31mOPTION NOT VALID\e[0m"
                                sleep 2
                                ;;

                        esac

                    done
                ;;

            3) while :
                do

                    clear
                    echo "\e[92m
+---------------------------------------------------+
|                                                   |
|                    SAMBA USERS                    |
|                                                   |
+---------------------------------------------------+
|                                                   |
| Press [1] to list samba users                     |
|                                                   |
| Press [2] to create samba user                    |
|                                                   |
| Press [3] to delete samba user                    |
|                                                   |
| Press [4] to add user to private folder           |
|                                                   |
| Press [5] to delete user from private folder      |
|                                                   |
| Press [0] to return to the main menu              |
|                                                   |
+---------------------------------------------------+
\e[0m"
                        echo

                        read option2

                        echo

                            case $option2 in

		                    1) clear
                                    echo "\e[92m
+--------------------------------------------------+
|                                                  |
|                 SAMBA USERS LIST                 |
|                                                  |
+--------------------------------------------------+
\e[0m"
			                    echo
                                echo "\e[93mPRESS Q TO EXIT\e[0m"
                                echo

                                # User list samba
				                pdbedit -L | less
			                    ;;

	                        2) clear
                                    echo "\e[92m
+--------------------------------------------------+
|                                                  |
|                 CREATE SAMBA USER                |
|                                                  |
+--------------------------------------------------+
\e[0m"
		                         echo
			                     echo "\e[93mEnter the username without spaces\e[0m"
			                     echo

			                     read user

                                 # Filter the username
                                 cut -d : -f 1 /etc/shadow | grep -w $user > /dev/null 2>&1

					             if [ $? -eq 0 ]
					             then

                                     # User list samba
                                     pdbedit $user > /dev/null 2>&1

                                        if [ $? -eq 0 ]
                                        then
                                            echo
                                            echo "\e[31mUser $user already exists\e[0m"
                                            sleep 2
                                        else
                                            echo
                                            echo "\e[96mEnter the password of the user $user\e[0m"
                                            echo

                                                smbpasswd -a $user

                                            sleep 2
                                        fi

                                  else

                                        # Create user with not possibility of logging into the system
						                useradd -s /usr/sbin/nologin $user > /dev/null 2>&1

                                        if [ $? -ne 0 ]
                                        then
                                            echo
                                            echo "\e[93mEnter the username without spaces\e[0m"
                                            sleep 2
                                        else
                                            echo
							                echo "\e[96mEnter the password of the user $user\e[0m"
							                echo

                                            # Create samba user
								            smbpasswd -a $user

                                            sleep 2
                                        fi
					            fi
					             ;;

	                        3) clear
                                    echo "\e[92m
+--------------------------------------------------+
|                                                  |
|                 DELETE SAMBA USER                |
|                                                  |
+--------------------------------------------------+
\e[0m"
		                         echo
			                     echo "\e[96mEnter the name of the user you want to delete\e[0m"
			                     echo

				                 read user

				                 pdbedit $user > /dev/null 2>&1

					                if [ $? -eq 0 ]
					                then

                                        # Delete user from Samba database
						                smbpasswd -x $user

                                        # Remove user from system
						                userdel $user > /dev/null

							            echo
								        echo "\e[96mUser $user has been deleted\e[0m"
								        sleep 2

					                else
						                echo
							            echo "\e[31mUser $user does not exist\e[0m"
							            sleep 2

					                fi
					                ;;

		                    4) clear
                                     echo "\e[92m
+--------------------------------------------------+
|                                                  |
|                   ADD SAMBA USER                 |
|                        TO                        |
|                   PRIVATE FOLDER                 |
|                                                  |
+--------------------------------------------------+
\e[0m"
                                 echo
			                     echo "\e[93mTHE USER AND THE PRIVATE FOLDER MUST EXIST\e[0m"
                                 echo

				                 echo "\e[96mEnter the name of the user you want to add to the private folder\e[0m"
				                 echo

				                 read user

				                 pdbedit $user > /dev/null 2>&1

				                    if [ $? -eq 0 ]
				                    then
					                     echo
                                         echo "\e[96mTHESE ARE THE PRIVATE FOLDERS CREATED\e[0m"
                                         echo "\e[96m------------------------------------------------------------\e[0m"
                                         echo

                                            ls $PWD/private

                                         echo
                                         echo "\e[96m------------------------------------------------------------\e[0m"
                                         echo

					                     echo "\e[96mEnter the name of the private folder\e[0m"
                                         echo

					                     read directory

						                    if [ -d $PWD/private/$directory ]
						                    then

                                                # Add new group to user
							                    usermod -a -G $directory $user > /dev/null 2>&1

                                                if [ $? -eq 0 ]
                                                then

							                        echo
								                    echo "\e[96mThe user $user has been added to the private folder $directory\e[0m"

                                                    # Add the user's name to the file in the shared folder
                                                    echo "$user" >> $PWD/group/$directory

								                    sleep 2
                                                            systemctl restart smbd
                                                else
                                                    echo
                                                    echo "\e[31mThe username is not correct\e[0m"
                                                    sleep 2
                                                fi

                                             else
                                                echo
                                                echo "\e[31muser $user does not exist\e[0m"
                                                sleep 2
						                    fi

				                     else

					                    echo "\e[31muser $user does not exist\e[0m"
					                    sleep 2

                                fi
				                    ;;

		                    5) clear
                                     echo "\e[92m
+--------------------------------------------------+
|                                                  |
|                  DELETE SAMBA USER               |
|                         TO                       |
|                   PRIVATE FOLDER                 |
|                                                  |
+--------------------------------------------------+
\e[0m"
				                echo "\e[96mEnter the name of the user you want to delete from the private folder\e[0m"
                                echo

				                read user

					            pdbedit $user > /dev/null 2>&1

						        if [ $? -eq 0 ]
						        then
							         echo
                                     echo "\e[96mTHESE ARE THE PRIVATE FOLDERS CREATED\e[0m"
                                     echo "\e[96m------------------------------------------------------------\e[0m"
                                     echo

                                        ls $PWD/private

                                     echo
                                     echo "\e[96m------------------------------------------------------------\e[0m"
                                     echo
							         echo "\e[96mEnter the name of the private folder\e[0m"
                                     echo

							         read directory

							         if [ -d $PWD/private/$directory ]
							         then

								         # Filter the username of the file
                                         grep -w $user $PWD/group/$directory > /dev/null 2>&1

                                         if [ $? -eq 0 ]
                                         then

                                             # Delete group to which the user belonged
								             deluser $user $directory > /dev/null 2>&1

                                            echo
                                            echo "\e[96mThe user $user has been removed from the private folder $directory\e[0m"

                                            # Save the line number that match the user
                                            line=$(sed -n '/'$user'/=' $PWD/group/$directory)

                                            # Delete the line where the value of the $line variable is located
                                            sed -i ''$line'd' $PWD/group/$directory

                                            sleep 2
                                            systemctl restart smbd

                                         else

                                             echo
                                             echo "\e[31mUser does not belong this share\e[0m"
                                             sleep 2

                                         fi



                                     else

                                        echo
                                        echo "\e[31mPrivate folder $directory does not exist\e[0m"
                                        sleep 2

							         fi

						        else

							        echo
							        echo "\e[31mThe user $user does not exist\e[0m"

							        sleep 2


						        fi
						        ;;

                          0) clear
                                echo
                                     echo "\e[96mRETURN TO THE MAIN MENU\e[0m"
                                     sleep 2
                                     break
                                     ;;

                          *) clear
                                echo
                                echo "\e[31mOPTION NOT VALID\e[0m"
                                sleep 2
                                ;;

                        esac

                    done
                ;;

            4) while :
                do
                    clear

                    echo "\e[92m
+--------------------------------------------------------+
|                                                        |
|                    SAMBA RESOURCES                     |
|                                                        |
+--------------------------------------------------------+
|                                                        |
| Press [1] to see shares                                |
|                                                        |
| Press [2] to see current connections                   |
|                                                        |
| Press [3] to change the WORKGROUP                      |
|                                                        |
| Press [0] to return to the main menu                   |
|                                                        |
+--------------------------------------------------------+
\e[0m"
                    echo

                    read option2

                    case $option2 in

		            1) clear
                            echo "\e[92m
+--------------------------------------------------+
|                                                  |
|                  SHARED RESOURCES                |
|                                                  |
+--------------------------------------------------+
\e[0m"
                            echo
                            echo "\e[93mPRESS Q TO EXIT\e[0m"
                            echo

                            # Show server shares
				            smbtree | less
				            ;;


                    2) clear
                            echo "\e[92m
+--------------------------------------------------+
|                                                  |
|               CURRENT CONNECTIONS                |
|                                                  |
+--------------------------------------------------+
\e[0m"
                            echo
                            echo "\e[93mPRESS Q TO EXIT\e[0m"
                            echo

                            # Shows the clients that are connected to the server
                            smbstatus | less
                            ;;

                    3) clear
                            echo "\e[92m
+--------------------------------------------------+
|                                                  |
|                    CHANGE NAME                   |
|                        OF                        |
|                     WORKGOUP                     |
|                                                  |
+--------------------------------------------------+
\e[0m"
                            echo

                            # Save the line value
                            workgroup_line=$(sed -n '/workgroup =/=' /etc/samba/smb.conf)

                            # Save the name of the current WORKING GROUP
                            workgroup=$(sed -n ''$workgroup_line'p' /etc/samba/smb.conf | awk '{print $3}')

		                    echo "\e[96mThe name of the WORKGROUP is $workgroup\e[0m"
		                    echo
                            echo "\e[96mEnter the new name to the WORKGROUP\e[0m"
                            echo

			                read new

                            # Save the value of the variable $new in uppercase
                            upper=$(echo $new | awk '{print toupper ($0)}')

			                echo

                            # Change the new name of WORKING GROUP in the Samba configuration file
                            sed -i 's/'$workgroup'/'$upper'/' /etc/samba/smb.conf

                            echo
			                echo "\e[96mThe previous WORKGROUP was $workgroup and has been replaced by $upper\e[0m"
			                sleep 4
                                    systemctl restart smbd
			                ;;

                    0) clear
			                echo "\e[96mRETURN TO THE MAIN MENU\e[0m"
		                    sleep 2
			                break
			                ;;

		            *) clear
			                echo
			                echo "\e[31mOPTION NOT VALID\e[0m"
			                sleep 2
			                ;;

	                esac

                done
            ;;

            0) clear
                    echo "\e[96mSEE YOU NEXT TIME\e[0m"
                    sleep 2
                    break
                    ;;

            *) clear
                    echo "\e[31mOPTION NOT VALID\e[0m"
                    sleep 2
                    ;;

        esac

    done
clear

systemctl restart smbd

exit 0



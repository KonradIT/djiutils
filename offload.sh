echo "  _____       _ _____   _    _ _   _ _ "
echo " |  __ \     | |_   _| | |  | | | (_) |"
echo " | |  | |    | | | |   | |  | | |_ _| |"
echo " | |  | |_   | | | |   | |  | | __| | |"
echo " | |__| | |__| |_| |_  | |__| | |_| | |"
echo " |_____/ \____/|_____|  \____/ \__|_|_|"
echo "                                       "

if [[ $1 == "help" ]];
	then
		echo "Usage: $0 [path of destination]"
	else


	if [[ -d DCIM ]];
	then

		echo "DCIM found"
		
		echo "Destination: $1"
		echo -ne "[y/n]? : "; read choice
		destination=""
		if [[ $choice == "y" ]];
			then
				destination=$1
			else
				echo -ne "Enter destination: "
				read destination
		fi	
		
		mv_command=""
		echo -ne "Command to use: enter for mv, write something else: "
		read mv_command
		if [[ $mv_command == "" ]];
			then
				mv_command="mv"
		fi	
		for folder in DCIM/*
			do
				echo "Folder:"
				echo $folder
				if [[ $folder == "DCIM/PANORAMA" ]]
					then
						mkdir -p "$destination/$name/panoramas"
						$mv_command $folder/* "$destination/panoramas/"
					else
						for i in $folder/*.JPG
							do
							echo $i
							photo_date=$(exiftool -d "%Y-%m-%d" -DateTimeOriginal -S -s $i)
							echo $photo_date
							if [[ -d "$destination/$photo_date" ]];
								then
									mv $i "$destination/$photo_date/photos/"
								else
									mkdir "$destination/$photo_date"
									mkdir "$destination/$photo_date/photos"
									mkdir "$destination/$photo_date/videos"
									
									mv $i "$destination/$photo_date/photos/"
							fi
						done
						for i in $folder/*.MP4
							do
							video_date=$(date -d"$(mediainfo $i --Inform="Video;%Tagged_Date%")" +%Y-%m-%d)
							if [[ -d "$destination/$video_date" ]];
								then
									mv $i "$destination/$video_date/videos/"
								else
									mkdir "$destination/$video_date"
									mkdir "$destination/$video_date/photos"
									mkdir "$destination/$video_date/videos"
									
									mv $i "$destination/$video_date/videos/"
							fi
						done
						echo "Transfer done"
					
				fi
		done
				
	else

		echo "Error: Run script inside SD card"
		pwd

	fi

fi

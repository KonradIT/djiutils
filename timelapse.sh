## Usage: timelapse.sh 24 1920 1080 out.mp4
if [[ $1 == "help" ]];
	then
		echo "Usage: $0 [framerate] [width] [height] [output filename]"
		echo "For example: timelapse.sh 24 1920 1080 out.mp4"
	else
		framerate="$1"
		filename="$4"
		resolution_width="$2"
		resolution_height="$3"
		$(which ls) -1tr *.JPG > timelapse_list.txt
		mencoder -nosound -ovc x264 \
			-vf scale=$resolution_width:$resolution_height -mf type=jpeg:fps=$framerate \
			mf://@timelapse_list.txt -o timelapse_unstable.mp4
		rm gopro_timelapse_list.txt

		echo "Conversion to timelapse done"
		echo "Stabilizing..."
		echo -ne "Remove *.JPG? [y/n]? : "; read choice
		if [[ $choice == "y" ]];
			then
				rm *.JPG
		fi	
		echo -ne "Remove unstabilized timelapse mp4? [y/n]? : "; read choice_two
		if [[ $choice_two == "y" ]];
			then
				rm timelapse_unstable.mp4
		fi	
		ffmpeg -i timelapse_unstable.mp4 -vf vidstabdetect=shakiness=10:accuracy=15 -f null -
		ffmpeg -i timelapse_unstable.mp4 -vf vidstabtransform=zoom=5:smoothing=30 -vcodec libx264 -preset slow -tune film -crf 20 -an $filename
		echo "Done."
fi

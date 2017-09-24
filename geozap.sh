#!/bin/bash

clear

source <(curl -s https://raw.githubusercontent.com/alectramell/beacons/master/colors.sh)

clear

if [ -e $(pwd)/GPS_LOG.txt ]
then
	rm $(pwd)/GPS_LOG.txt
else
	clear
fi

clear

if [ -e $(pwd)/*_original ]
then
	rm $(pwd)/*_original
else
	clear
fi

clear

IMGLIST=($(ls $(pwd)/*.JPG))
IMGNUMB=$(ls $(pwd)/*.JPG | wc -l)
IMGNUMS=$(($IMGNUMB - 1))

clear

for i in $(seq 0 $IMGNUMS)
do
	LATCOR=($(cat $(ls $(pwd)/*.lat)))
	exiftool -q -GPSLatitude="${LATCOR[$i]}" ${IMGLIST[$i]} &>/dev/null
	echo "[${sky}${bold}Writing Latitude Data ${gold}$i/$IMGNUMB${reset}] (Progress ${green}${bold}1/3${reset})"
	sleep 0.5
done

for i in $(seq 0 $IMGNUMS)
do
	LONCOR=($(cat $(ls $(pwd)/*.lon)))
	exiftool -q -GPSLongitude="${LONCOR[$i]}" ${IMGLIST[$i]} &>/dev/null
	echo "[${sky}${bold}Writing Longitude Data ${gold}$i/$IMGNUMB${reset}] (Progress ${green}${bold}2/3${reset})"
	sleep 0.5
done

for i in $(seq 0 $IMGNUMS)
do
	ALTCOR=($(cat $(ls $(pwd)/*.alt)))
	exiftool -q -GPSAltitudeRef="Above Sea Level" -GPSAltitude="${ALTCOR[$i]}" ${IMGLIST[$i]} &>/dev/null
	echo "[${sky}${bold}Writing Altitude Data ${gold}$i/$IMGNUMB${reset}] (Progress ${green}${bold}3/3${reset})"
	sleep 0.5
done

clear

rm -r $(pwd)/*_original

clear

exiftool *.JPG | grep "GPS" > $(pwd)/GPS_LOG.txt

clear
sleep 0.5
clear
$(pwd)/GPS_LOG.bak

clear

echo "${gold}${bold}GeoTagging Complete!${reset} (${green}${bold}Final${reset})"

sleep 3.5

xdg-open $(pwd)/GPS_LOG.txt &

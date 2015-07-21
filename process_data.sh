#!/bin/bash
#process_data.sh
#
#process the robot garden data.sh

#!/bin/bash

filedate=`date +"%Y-%m-%d" --date="1 day ago"`
filename='./processing/'$filedate
output='./processed'

mv ./greenhouse.csv ./processing/$filename.csv
sudo touch ./greenhouse.csv

cat $filename.csv | while read line
do
    #chop each line into bits
    date=`echo $line |cut -d',' -f1`
    temp_pre=`echo $line |cut -d',' -f2`
    humid_pre=`echo $line |cut -d',' -f3`
    moist_pre=`echo $line |cut -d',' -f4`
    light_pre=`echo $line |cut -d',' -f5`
    
    #chop down to 1 sf
    printf -v temp "%.1f" $temp_pre
    printf -v humid "%.1f" $humid_pre 
    printf -v moist "%.1f" $moist_pre 
    printf -v light "%.1f" $light_pre 
    
    #write the data out to respective files
    #echo $date","$temp","$humid","$moist","$light
    echo $date","$temp >>  $output/$filedate-temperature.csv
    echo $date","$humid >> $output/$filedate-humidity.csv
    echo $date","$moist >> $output/$filedate-moisture.csv
    echo $date","$light >> $output/$filedate-light.csv

done

#sync it up to the remote server and clear out the processed folder
rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress ./processed remote:/root/
rm -rf processing/*
rm -rf processed/*

#!/bin/bash
#    Copyright (C) by Hector D. Menendez <hector.david.1987@gmail.com>
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, version 3 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


#   Environment. Please, Modify GENERAL_FOLDER with your current folder in order to run the script

#   Example: sh scriptGeneration.sh

GENERAL_FOLDER="/home/elluisma/owncloud/CEC2015/code/GANY"
PATH_MODELOS=$GENERAL_FOLDER"/Code/Scripts" 
ALGORITHMS=$PATH_MODELOS"/algorithms"
DATASET="spirals.csv"
CLUSTERS="2"
AUTOSIM=$PATH_MODELOS"/similarities/AutoSimilarity.jar" 
SOLUTION=$GENERAL_FOLDER"/Examples/Spirals/spiralsSol.csv"
CURRENT_DIRECTORY=`pwd`
while read line
do
	echo $line
	cd $PATH_MODELOS/$line
	sh $line.sh $DATASET $CLUSTERS
	mv $line.General.r $CURRENT_DIRECTORY/
	cd $CURRENT_DIRECTORY
	if [ ! -d "$line.Sols" ]; then
	  mkdir $line.Sols
	fi
	chmod 777 $line.General.r
	./$line.General.r
	cd $line.Sols
	rm sol~ sol
	cat sol* > sol
    sed -i 's/  / /g' sol
    sed -i 's/  / /g' sol
    sed -i 's/  / /g' sol
    sed -i 's/  / /g' sol
    sed 's/^[ \t]*//' -i sol
	java -cp $AUTOSIM autosimilarity.CheckSimilaritiesFile sol $SOLUTION > $CURRENT_DIRECTORY/results$line
done < $ALGORITHMS
cd $CURRENT_DIRECTORY
./statistic.r


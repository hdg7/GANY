#!/bin/bash
#
#    Copyright (C) 2015 by Hector D. Menendez <hector.david.1987@gmail.com>
#
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

#The first argument is the datasetPath
#The second argument is the number of clusters

#Ex: sh gen.sh iris.dat 3 50

GENERAL_FOLDER="/home/elluisma/owncloud/CEC2015/code/GANY"
CONVERSORPATH=$GENERAL_FOLDER"/Code/Scripts/gen/matrix.r"	
GEN=$GENERAL_FOLDER"/Code/Scripts/gen/gen.r"

echo "#!/bin/bash" > gen.General.r
echo "$CONVERSORPATH $1 $2 300" >> gen.General.r
echo "for(( i=1; i<=50; i++ ))" >> gen.General.r
echo "do" >> gen.General.r
echo "$GEN test1 \$i" >> gen.General.r
echo "done" >> gen.General.r
#echo "./convertRSols.r gen.Sols" >> gen.General.r

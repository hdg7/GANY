#!/usr/bin/Rscript
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

#   Example: ./statistic.r


ak <- read.csv("resultsgen",head=FALSE)
ak <- as.numeric(as.matrix(ak))
print("Genetic Results")
print(sd(as.matrix(ak)))
print(summary(as.matrix(ak)))


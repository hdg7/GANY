# GANY
The GANY algorithm published on Congress on Evolutionary Computation 2015 

The Repository

Here you can find two folders: 
- Code: The original code of the algorithm in R.
- Example: An example to run the algorithm.

The algorithm works as follows: 
- You have to create an script generation with the same information contained in scriptgeneration.sh. If you want, you can just use this file and modify the GENERALFOLDER with the current location of our GANY folder. 
- You also have to modify the variable GENERALFOLDER in file gen.sh (Code/Script).
- You need R and the following packages: kernlab, GA, proxy, MASS, fields, matrixStats and compiler (the last is to compile the fitness and make your algorithm faster but it is not available in all R distributions).

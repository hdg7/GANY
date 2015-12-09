# GANY
The GANY algorithm published on Congress on Evolutionary Computation 2015 

http://ieeexplore.ieee.org/xpl/login.jsp?tp=&arnumber=7256951

The Repository

Here you can find two folders: 
- Code: The original code of the algorithm in R.
- Example: An example to run the algorithm.

The algorithm works as follows: 
- You have to create an script generation with the same information contained in scriptgeneration.sh. If you want, you can just use this file and modify the GENERALFOLDER with the current location of our GANY folder. 
- You also have to modify the variable GENERALFOLDER in file gen.sh (Code/Script).
- You need R and the following packages: kernlab, GA, proxy, MASS, fields, matrixStats and compiler (the last is to compile the fitness and make your algorithm faster but it is not available in all R distributions).
- Prepare the dataset in the same way you have in the Example folder, the solutions will be created in the .Sols folder.
- The script has an evaluation package used to evaluate the solutions with a sol.csv file, you can also configure it in the script. The current evaluation is the accuracy.
- Run:
	> sh scriptGeneration.sh

# BSB-2023-Framework
Source code of the framework for hybrid modeling of cell signaling pathways
<br /> <br/> 
## Components installation 
### Linux
#### Jupyter notebook
In the console:
	apt-get install python3
	python3 -m pip install jupyter
<br /> <br/> 
#### Julia 
In the console:
	apt-get install julia
	julia
	using Pkg
	Pkg.add("IJulia") 
<br /> <br/> 
#### Executing
In the console:
Jupyter notebook
<br /> <br/> 
### Windows
#### Jupyter notebook
Download the Anaconda installer from https://www.anaconda.com/distribution/, run it and follow the instructions.
<br /> <br/> 
#### Julia 
Download the Julia installer from https://julialang.org/downloads/, run it and follow the instructions.
Type "Julia" in the start menu to open the console
Install the package “IJulia”, in the console:
using Pkg
Pkg.add("IJulia")
<br /> <br/> 
#### Executing
Run Anaconda via the start menu.
In the Anaconda interface, click on “Launch” under Jupyter notebook.
<br /> <br/> 
### Usage guide 
An interface of Jupyter will be executed in the default browser, search and open the file "Pipeline.ipynb" in the downloaded files directory.
- Run the cells one by one following the indications contained in the code blocks, making the desired changes (in particular, imported file names, parameters and algorithms used by the functions).

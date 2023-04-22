# BSB-2023-Framework
Source code of the framework for hybrid modeling of cell signaling pathways
<br /> <br/> 
## Components installation 
### Linux
#### Jupyter notebook
In the console:
- apt-get install python3<br /> <br/> 
- python3 -m pip install jupyter
<br /> <br/> 
#### Julia 
In the console:
- apt-get install julia
- julia
- using Pkg
- Pkg.add("IJulia") 
<br /> <br/> 
#### Executing
In the console:
- Jupyter notebook
<br /> <br/> 
### Windows
#### Jupyter notebook
Download the Anaconda installer from https://www.anaconda.com/distribution/, run it and follow the instructions.
<br /> <br/> 
#### Julia 
Download the Julia installer from https://julialang.org/downloads/, run it and follow the instructions.
Type "Julia" in the start menu to open the console
Install the package “IJulia”, in the console:
- using Pkg
- Pkg.add("IJulia")
<br /> <br/> 
#### Executing
Run Anaconda via the start menu.
In the Anaconda interface, click on “Launch” under Jupyter notebook.
<br /> <br/> 
### Usage guide 
An interface of Jupyter will be executed in the default browser, search and open the file "Pipeline.ipynb" in the downloaded files directory.
- Run the cells one by one following the indications contained in the code blocks, making the desired changes (in particular, imported file names, parameters and algorithms used by the functions).
<br /> <br/> 
<br /> <br/> 
<br /> <br/> 
## Extra procedures
To facilitate the reproduction of the results, the present root directory contains the converted SBML models that were originally downloaded from the Anguix database ("model.sbml" and "cutmodel.sbml"). However, if one wishes to perform the entire process, the Anguix CSV files can be downloaded by following the instructions provided either in https://github.com/Dynamic-Systems-Biology/Anguix or https://github.com/anthraxodus/Anguix-command-line repositories. To do so, the user is required to execute the "Query 1" cited in the README section after selecting the organism "Danio Rerio" and download its data from Anguix database, and then clicking on the tab "Table" and then in "Export CSV" located in the upper right-hand corner of the query execution result in Neo4j.
<br /> <br/>
In possession of the CSV file, the following procedure should be followed to perform the conversion of these files to SBML format:


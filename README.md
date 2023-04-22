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
To facilitate the reproduction of the results, the present root directory contains the converted SBML models that were originally downloaded from the Anguix database ("model.sbml" and "cutmodel.sbml"). However, if one wishes to perform the entire process, the Anguix CSV files can be downloaded by following the instructions provided either in https://github.com/Dynamic-Systems-Biology/Anguix or https://github.com/anthraxodus/Anguix-command-line repositories. To do so, the user needs to execute "Query 1" as mentioned in the README section after selecting the "Danio Rerio" organism and download its data from the Anguix database. Finally, the CSV file can be downloaded by clicking on the "Table" tab, and then on "Export CSV" located in the upper right-hand corner of the query execution result in Neo4j.

<br /> <br/> 
In possession of the CSV file, the following procedure should be followed to perform the conversion of these files to SBML format (currently only on Linux):
#### Install C++, in the console:
- sudo apt update
- sudo apt install build-essential
- gcc –version
#### Install Qt Creator, in the console:
- sudo apt-get update
- sudo apt-get upgrade
- sudo apt-get -y install build-essential openssl libssl-dev libssl1.0 libgl1-mesa-dev libqt5x11extras5

Download the Qt installer from https://www.qt.io/download-qt-installer and execute, in the console:
- chmod +x qt(...).run
- /qt(...).run


Follow the steps indicated by the installer, pressing “Agree” and “Continue”. Just be careful with the “Installation folder” section. Do not change the location or name of the directory where Qt will be installed, and check the option “Qt 6… for desktop development”.

<br /> <br/>
#### Download and install Julia, libNeo4J and libSBML packages for Qt Creator applications
Access the CSV2SBML repository https://drive.google.com/drive/folders/1Okjj9wAWZTgfKcxt68a8cbY7KtsrsmUl on Google Drive and download the folder “libs”. Extract the files, in the console:
- unzip libs(...).zip

Open the folder that will be generated and copy each of the directories inside to the opt folder, in the console:
- cp -R foldername /opt

<br /> <br/>
#### Download and open the converter application project in Qt Creator
In the same Google Drive directory as in the previous step, download the folder of one of the two versions of the converter "CSV2SBML" (graphical interface) or "CSV2SBML_CL" (command line). Extract the files, in the console:
- unzip CSV2SBML(...).zip 
      
In Qt Creator: 
- Projects – Open

Go to the project’s directory “CSV2SBML(...)” downloaded and open the file “AnguixCSVtoSBML.pro”.

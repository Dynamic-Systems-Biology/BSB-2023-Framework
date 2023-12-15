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
Type "Julia" in the start menu to open the console and install the package “IJulia”, in the console:
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

<br /> <br/>
#### Using the application (graphical interface)
- With the project open in Qt Creator, click on the “Run” button on the lower left.
- Click on the “Convert” button on the interface.
- Following the application's instructions, select the CSV file to be converted and then the folder to store the SBML file.
- Access the SBML file in the selected location.

<br /> <br/>
#### Using the application (command line)
- Click in the "Projects" tab, in "Desktop -> Run" check the "Run in terminal" box and return to "Edit" tab.
- With the project open in Qt Creator, Click on the “Run” button on the lower left.
- At the command prompt, type/paste the name of the CSV file and press Enter.
- type/paste the path of the directory where you want to store the result and press “Enter”.
- Wait for the execution and at the end type “Ctrl+c” and “Enter” to close the terminal.

<br /> <br/> 
# Jupyter notebook block by block tutorial
<br /> <br/> 
## Section "Import packages" (code block 1)
Framework lib and Julia packages import. Just execute.
<br /> <br/> 
## Section "Import SBML model" (code blocks 2 to 12)
Code Block 2: It is necessary to enter the following information: Name of the file that contains the SBML model in line 1, level and version of the SBML file that contains the model in lines 2 and 3 respectively; It is not necessary to change line 4.

Execute from code blocks 3 to 8 without changes. The imported model parameters will be defined and displayed.

Code Block 9 (# Setting the initial concentrations): It is necessary to change the number of species in parentheses in the line "u0 = zeros(...)", putting the total number of species in the model instead of "...".
It is also necessary to insert the initial value of the species in the model, based on the order in which they are displayed in code block 7 (with the variable "speciesvector"), for example, if the first species showed in block 7 is "specie 0" and the second is "specie 1", then you need to set the line "u0[1] = X" with "X" being the initial value of specie 0 and line "u0[1] = X" with "X" being the initial value of specie 1. To finish, make sure that the line "selected_species = [...]" contains a number for each species in the model.

Execute code block 10 without changes.

Code Block 11 (# Define Params): Based on the SBML file information and the order from the code block 10 display, set the parameters in the line "model_param = Float32.([...])", for example, if the first parameter shown on code block 10 is "Reaction0_Km", search for the value of parameter "Km" on "Reaction0" reaction on the SBML file of the model and insert it first inside the brackets and do the same for the other values.

Execute code blocks 12 and 13 without changes, they will generate time series with a simulation and plot a graph with the results. still only with the ODE'S

<br /> <br/> 
## Section "Import the cutout model" (code blocks 14 to 20)
Repeat the same proccess from the blocks 2 to 12, this time with another model, in the preset example, it is a cutout model from the previously defined one.
On the last block of this set, a graph is plotted comparing the two simulations of the models especies concentration over time.

<br /> <br/> 
## Section "Turning ODE's into a system of UDE's" (code block 21)
Code Block 21(# Defining the neural network characteristics): It is necessary to change the number in the lines containing 'Lux.Dense(X, X" by replacing "X" with the number of species in the model. If desired, it is also possible to add or remove lines in the format "Lux.Dense(X, X, Lux.sigmoid)" to change the number of layers of the neural network. There is no need to change the other lines, the last one will generate the system of UDE's.

<br /> <br/> 
## Section "Training the model with ADAM" (code blocks 22 to 27)
Code Block 22(# Generating predict and loss functions parameters): It is not necessary to make changes, but if desired it is possible to change abstol, reltol and saveat parameters for specific needs, it is also possible to change the value "VALUE" on line 'X_val = view(X_2, :, VALUE:Z)' thus increasing the size of the training set, if this is done, then the value "VALUE+1" in the line "X_train = view(X_2, :, VALUE+1:N)" must be changed to the new value plus 1. Just like the example.

Code Block 23(# Train with ADAM): In this block, training is carried out with the ADAM algorithm, it is possible to change the number of training iterations in the line "maxiters=X" changing X to the desired number of iterations. It is also possible to use other algorithm instead of ADAM, changing the line 'ADAM(0.1)' to the name of another algorithm in the package, for example 'GradientDescent()'. no more changes are necessary.

Execute code blocks 24 and 25 without changes. they will plot graphs for the losses and the timeseries of the species of the model.

Code blocs 25 and 26(# Get the time indices corresponding to the desired moments): These blocks are responsible for printing concentration values ​​of the model species at the desired moments, the first block is in relation to the model generated at the beginning with the ODE's, and the second block for the model trained with ADAM, to choose the moments to be printed, simply change the values ​​inside the brackets on the second line "desired_moments = [...]".

<br /> <br/> 
## Section "Training the model with SGD" (code blocks 27 to 31)
The same procces from the last section is executed but using SGD method for training instead o ADAM.

<br /> <br/> 
## Section "Model Selection" (code blocks 32 and 33)
These blocks apply the model selection function to calculate the best model among the last two generated with ADAM and SGD, the first block simply uses the function and displays the result, while the second internally shows the values ​​that led to the result of the function.

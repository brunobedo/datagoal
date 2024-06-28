# DataGoal : A MATLAB Toolbox for Soccer Positional Data Analysis ⚽

## Introduction 🚀

The rapid advancements in computational sciences, including computer vision and image processing, have introduced new methods for data collection, aiding in the understanding of technical and tactical aspects of sports. In collective sports, there has been a notable increase in scientific and technical data production, particularly in invasion sports like soccer. Despite this, professional development in computational methods for sports professionals has not kept pace. 

This ongoing project, aligned with the initial schedule, aims to develop a technical-scientific tool for processing and analyzing positional data in soccer. This tool is designed to help sports professionals in processing soccer data efficiently.

## Context 🌐

Significant advancements in computational sciences, image processing, and computer vision offer emerging methods for acquiring crucial information when applied to sports. These advancements enable the application of diverse knowledge from fields like mathematics, physics, and computer science to objectively quantify athletes' performance and adjust training programs for optimal decision-making in sports.

Positional data analysis provides insights into athlete interactions within a team and collective organization, which is a dynamic process influenced by game context and constraints. The analysis of spatio-temporal positional data is crucial for understanding these constraints and characterizing various aspects of the sport.

With the increasing use of tracking systems in sports, new techniques for performance quantification have become possible. These techniques allow for understanding the dynamics of the game and factors affecting team tactical coordination. Various tools and systems for positional data acquisition exist, such as video systems processed by manual and/or automatic tracking systems and GPS systems.

Several toolboxes have been developed to facilitate data acquisition, processing, and analysis. Examples include MOCAP, ADAT, biomechZoo, MotoNMS, and BOPS. These tools offer numerous advantages, such as large-scale data processing, application of complex techniques by professionals with limited computational knowledge, and optimization of data processing for generating various types of analyses with low operational and computational costs.

## Objective 🎯

This research project aims to develop an open-source tool for analyzing positional data in soccer. This tool is intended for both the scientific community and professionals directly involved in practice, promoting the development and application of open-source tools in sports.

## Materials and Methods 🛠️

The toolbox was developed in MATLAB (Mathworks Inc., Natick, USA), a widely used language among research groups for developing and sharing tools through scripts or Graphical User Interfaces (GUI), simplifying and providing flexibility during data processing.

### Toolbox Organization 🗂️

The main goal of developing the tool was to automate all data processing steps with minimal user interaction, enabling use by professionals with limited computational programming knowledge. The toolbox is organized into the following sections:

### Configurations ⚙️

Users should select the game for analysis by choosing the folder where the game information is stored. They can also select the type of GPS used for data collection. The toolbox also processes tracking data from the Dvideow software.

### Data 📊

Users can select the number of athletes of interest and their positions (defenders, midfielders, and forwards). Depending on the metric and data acquisition of the opponent, it is possible to analyze data from two teams.

### Calibration and Data Processing Information 🧩

Each equipment has unique characteristics, such as different acquisition frequencies. Users can input the frequency in the graphical interface. All data is smoothed by a fourth-order Butterworth low-pass filter, with the cutoff frequency chosen by the user in the toolbox graphical interface. Data calibration is based on corner kick information, as used in various studies. Users should input the latitude and longitude values of each corner.

## Code Structure 📝

The main function `datagoal_GUI_v1` forms the basis of the DataGoal main file. This file creates the GUI and initializes the functions comprising the toolbox. It ensures that only one instance of the GUI is active at any given time. The GUI state is managed by a structure that includes the GUI name, its uniqueness, the opening function (`OpeningFcn`), the output function (`OutputFcn`), the layout function, and the callback function. This modular design allows the GUI to effectively respond to user actions and interface interactions.

During initialization, the function adjusts the GUI according to input arguments, including setting appropriate callbacks. If output arguments are expected, the `gui_mainfcn` function is called with the GUI state and input arguments. This ensures that the main function can handle different usage scenarios, providing flexibility and robustness to the application. The initialization code is marked to prevent editing, ensuring that essential configuration elements remain intact and functional.

The GUI opening function (`datagoal_GUI_v1_OpeningFcn`) is invoked just before the GUI becomes visible to the user. This function sets various initial configurations and states, including initializing global variables, configuring GUI components, and capturing user inputs. These configurations include disabling certain interface elements until appropriate data is loaded or specific actions are taken, guiding the user through the expected workflow and preventing errors.

The GUI output function (`datagoal_GUI_v1_OutputFcn`) ensures that the main GUI result is returned appropriately, completing the interaction cycle efficiently.

An example of the saved video can be accessed [HERE](https://drive.google.com/file/d/1TmOMntLm8MYTCVX0oTqYWH5nGCvSKI-9/view?usp=drive_link). The main execution code for the GUI can be found below.

## License 📜

The proposed tool is released under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) to encourage its use. This license allows for both personal and commercial use, modification, and distribution, ensuring that the tool remains freely accessible to the broader community. We strongly encourage contributions and improvements from the research community to enhance the functionality and applicability of this tool in the field of sports science.

```matlab
% This file is part of DataGoal: a Matlab Toolbox to Linear and Non-linear Soccer Positional Data Analysis.
% Copyright (C) 2024 Bruno L. S. Bedo, Felipe A. Moura, Rodrigo Aquino, Sergio A. Cunha, Paulo R. P. Santiago

% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at

% http://www.apache.org/licenses/LICENSE-2.0

% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

% Bruno L. S. Bedo,
% <bruno.bedo@usp.br>

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               DATAGOAL:                                 %
%              a Matlab Toolbox to Linear and Non-linear                  %
%                    Soccer Positional Data Analysis                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

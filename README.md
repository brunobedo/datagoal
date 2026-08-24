# DataGoal : A MATLAB Toolbox for Soccer Positional Data Analysis ⚽

## Introduction 🚀

The rapid advancements in computational sciences, including computer vision and image processing, have introduced new methods for data collection, aiding in the understanding of technical and tactical aspects of sports. 

In collective sports, there has been a notable increase in scientific and technical data production, particularly in invasion sports like soccer. Despite this, professional development in computational methods for sports professionals has not kept pace. 

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

The main execution code for the GUI can be found below.

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
```


## Articles 📚

### 1. Citing DataGoal

If you use DataGoal in your research, please cite the article:

- 📄 [Published Article](https://journals.sagepub.com/doi/10.1177/17543371261455525)
  
```bibtex
@article{bedo2026datagoal,
  title = {DataGoal: A MATLAB toolbox to linear and non-linear soccer positional data analysis},
  ISSN = {1754-338X},
  url = {http://dx.doi.org/10.1177/17543371261455525},
  DOI = {10.1177/17543371261455525},
  journal = {Proceedings of the Institution of Mechanical Engineers,  Part P: Journal of Sports Engineering and Technology},
  publisher = {SAGE Publications},
  author = {Bedo,  Bruno L. S. and Moura,  Felipe A. and Santiago,  Paulo R. P. and Cunha,  Sergio A. and Assis,  Ronaldo D. and Machado,  João C. and Aquino,  Rodrigo},
  year = {2026},
  month = June 
}
```

### 2. Articles that used dataGoal

The following articles have used DataGoal in their research:

```bibtex
@article{Sagaz2021,
  title = {Influ\^encias do mando de jogo,  nível competitivo e resultado da partida sobre o desempenho físico em jogadores profissionais de futebol},
  volume = {20},
  ISSN = {1677-8510},
  url = {http://dx.doi.org/10.33233/rbfex.v20i3.4178},
  DOI = {10.33233/rbfex.v20i3.4178},
  number = {3},
  journal = {Revista Brasileira de Fisiologia do exerc&amp;iacute cio},
  publisher = {Convergences Editorial},
  author = {Sagaz,  Gabriel Colatto and Aresi,  Louren\c{c}o Zini Moreira and Bedo,  Bruno Luiz Souza and Mesquita,  Filipe and Santiago,  Paulo Roberto Pereira and Azevedo,  Angelo Melim and Souza,  Helder and Gon\c{c}alves,  Eder and Aquino,  Rodrigo},
  year = {2021},
  month = nov,
  pages = {325–334}
}

@article{Machado2022,
  title = {Applying Different Strategies of Task Constraint Manipulation in Small-Sided and Conditioned Games: How Do They Impact Physical and Tactical Demands?},
  volume = {22},
  ISSN = {1424-8220},
  url = {http://dx.doi.org/10.3390/s22124435},
  DOI = {10.3390/s22124435},
  number = {12},
  journal = {Sensors},
  publisher = {MDPI AG},
  author = {Machado,  João Cláudio and Góes,  Alberto and Aquino,  Rodrigo and Bedo,  Bruno L. S. and Viana,  Ronélia and Rossato,  Mateus and Scaglia,  Alcides and Ibáñez,  Sérgio J.},
  year = {2022},
  month = jun,
  pages = {4435}
}

@article{Augusto2022,
  title = {Contextual variables affect peak running performance in elite soccer players: A brief report},
  volume = {4},
  ISSN = {2624-9367},
  url = {http://dx.doi.org/10.3389/fspor.2022.966146},
  DOI = {10.3389/fspor.2022.966146},
  journal = {Frontiers in Sports and Active Living},
  publisher = {Frontiers Media SA},
  author = {Augusto,  Di\^ego and Brito,  João and Aquino,  Rodrigo and Paulucio,  Dailson and Figueiredo,  Pedro and Bedo,  Bruno Luiz Souza and Touguinhó,  Deborah and Vasconcellos,  Fabrício},
  year = {2022},
  month = sep 
}

@article{Ueda2025,
  title = {Influence of manipulating pitch size and game format in small-sided soccer games on tactical creativity and exploratory behavior of young players},
  volume = {55},
  ISSN = {1871-1871},
  url = {http://dx.doi.org/10.1016/j.tsc.2024.101690},
  DOI = {10.1016/j.tsc.2024.101690},
  journal = {Thinking Skills and Creativity},
  publisher = {Elsevier BV},
  author = {Ueda,  Lucas Shoiti Carvalho and Aquino,  Rodrigo and Morais,  Cristiano Zarbato and Bedo,  Bruno and Teixeira,  Anderson Santiago and da Silva,  Juliano Fernandes and Borges,  Paulo Henrique},
  year = {2025},
  month = mar,
  pages = {101690}
}

@article{Kunrath2024,
  title = {Youth soccer team’s match dynamics with and without the ball when in both conditions of advantage and disadvantage},
  volume = {25},
  ISSN = {1474-8185},
  url = {http://dx.doi.org/10.1080/24748668.2024.2419759},
  DOI = {10.1080/24748668.2024.2419759},
  number = {3},
  journal = {International Journal of Performance Analysis in Sport},
  publisher = {Informa UK Limited},
  author = {Kunrath,  Caito A. and Bedo,  Bruno L. S. and Aquino,  Rodrigo and Laporta,  Lorenzo and De Conti Teixeira Costa,  Gustavo and Araújo,  Duarte and Leonardi,  Thiago},
  year = {2024},
  month = oct,
  pages = {462–478}
}

@article{Costa2024,
  title = {The impact of different game formats on players’ and team performance in youth soccer competitions},
  volume = {19},
  ISSN = {2048-397X},
  url = {http://dx.doi.org/10.1177/17479541241252946},
  DOI = {10.1177/17479541241252946},
  number = {5},
  journal = {International Journal of Sports Science &amp; Coaching},
  publisher = {SAGE Publications},
  author = {Costa,  Tobias dos Santos and Rossato,  Mateus and Rodrigues,  Obadias and Aquino,  Rodrigo and Bedo,  Bruno Souza and Leonardo,  Lucas and Machado,  João Cláudio},
  year = {2024},
  month = may,
  pages = {2016–2023}
}

@article{Gonalves2024,
  title = {Attack,  defense,  and transitions in soccer: analyzing the running performance of match-play},
  volume = {20},
  ISSN = {1825-1234},
  url = {http://dx.doi.org/10.1007/s11332-024-01210-y},
  DOI = {10.1007/s11332-024-01210-y},
  number = {3},
  journal = {Sport Sciences for Health},
  publisher = {Springer Science and Business Media LLC},
  author = {Gon\c{c}alves,  Luiz Guilherme and Silva,  Ana Filipa and Augusto,  Diego and Pasquarelli,  Bruno and Pastor,  Alejandro and de Okato Plato,  Felipe and Bedo,  Bruno L. S. and Vasconcellos,  Fabrício and Aquino,  Rodrigo},
  year = {2024},
  month = apr,
  pages = {1087–1100}
}

```

### 3. Academic Sources - Research Foundation

The following articles were academic sources that based our research to develop the codes:

```bibtex

@article{Frencken2011,
  title = {Oscillations of centroid position and surface area of soccer teams in small‐sided games},
  volume = {11},
  ISSN = {1536-7290},
  url = {http://dx.doi.org/10.1080/17461391.2010.499967},
  DOI = {10.1080/17461391.2010.499967},
  number = {4},
  journal = {European Journal of Sport Science},
  publisher = {Wiley},
  author = {Frencken,  Wouter and Lemmink,  Koen and Delleman,  Nico and Visscher,  Chris},
  year = {2011},
  month = jun,
  pages = {215–223}
}

@article{Low2019,
  title = {A Systematic Review of Collective Tactical Behaviours in Football Using Positional Data},
  volume = {50},
  ISSN = {1179-2035},
  url = {http://dx.doi.org/10.1007/s40279-019-01194-7},
  DOI = {10.1007/s40279-019-01194-7},
  number = {2},
  journal = {Sports Medicine},
  publisher = {Springer Science and Business Media LLC},
  author = {Low,  Benedict and Coutinho,  Diogo and Gon\c{c}alves,  Bruno and Rein,  Robert and Memmert,  Daniel and Sampaio,  Jaime},
  year = {2019},
  month = sep,
  pages = {343–385}
}

@article{Moura2011,
  title = {Quantitative analysis of Brazilian football players’ organisation on the pitch},
  volume = {11},
  ISSN = {1752-6116},
  url = {http://dx.doi.org/10.1080/14763141.2011.637123},
  DOI = {10.1080/14763141.2011.637123},
  number = {1},
  journal = {Sports Biomechanics},
  publisher = {Informa UK Limited},
  author = {Moura,  Felipe Arruda and Martins,  Luiz Eduardo Barreto and Anido,  Ricardo De Oliveira and De Barros,  Ricardo Machado Leite and Cunha,  Sergio Augusto},
  year = {2011},
  month = dec,
  pages = {85–96}
}

@article{Duarte2013,
  title = {Capturing complex,  non-linear team behaviours during competitive football performance},
  volume = {26},
  ISSN = {1559-7067},
  url = {http://dx.doi.org/10.1007/s11424-013-2290-3},
  DOI = {10.1007/s11424-013-2290-3},
  number = {1},
  journal = {Journal of Systems Science and Complexity},
  publisher = {Springer Science and Business Media LLC},
  author = {Duarte,  Ricardo and Araújo,  Duarte and Folgado,  Hugo and Esteves,  Pedro and Marques,  Pedro and Davids,  Keith},
  year = {2013},
  month = feb,
  pages = {62–72}
}

@article{Silva2014,
  title = {Numerical Relations and Skill Level Constrain Co-Adaptive Behaviors of Agents in Sports Teams},
  volume = {9},
  ISSN = {1932-6203},
  url = {http://dx.doi.org/10.1371/journal.pone.0107112},
  DOI = {10.1371/journal.pone.0107112},
  number = {9},
  journal = {PLoS ONE},
  publisher = {Public Library of Science (PLoS)},
  author = {Silva,  Pedro and Travassos,  Bruno and Vilar,  Luís and Aguiar,  Paulo and Davids,  Keith and Araújo,  Duarte and Garganta,  Júlio},
  editor = {Balasubramaniam,  Ramesh},
  year = {2014},
  month = sep,
  pages = {e107112}
}

@article{Gonalves2020,
  title = {Effects of Match-Related Contextual Factors on Weekly Load Responses in Professional Brazilian Soccer Players},
  volume = {17},
  ISSN = {1660-4601},
  url = {http://dx.doi.org/10.3390/ijerph17145163},
  DOI = {10.3390/ijerph17145163},
  number = {14},
  journal = {International Journal of Environmental Research and Public Health},
  publisher = {MDPI AG},
  author = {Gon\c{c}alves,  Luiz Guilherme Cruz and Kalva-Filho,  Carlos Augusto and Nakamura,  Fábio Yuzo and Rago,  Vincenzo and Afonso,  José and Bedo,  Bruno Luiz de Souza and Aquino,  Rodrigo},
  year = {2020},
  month = jul,
  pages = {5163}
}

@article{Zubillaga2013,
  title = {Influence of Ball Position on Playing Space in Spanish Elite Women’s Football Match-Play},
  volume = {8},
  ISSN = {2048-397X},
  url = {http://dx.doi.org/10.1260/1747-9541.8.4.713},
  DOI = {10.1260/1747-9541.8.4.713},
  number = {4},
  journal = {International Journal of Sports Science &amp; Coaching},
  publisher = {SAGE Publications},
  author = {Zubillaga,  Asier and Gabbett,  Tim J. and Fradua,  Luis and Ruiz-Ruiz,  Carlos and Caro,  Óscar and Ervilla,  Raúl},
  year = {2013},
  month = dec,
  pages = {713–722}
}

@article{Fonseca2012,
  title = {Spatial dynamics of team sports exposed by Voronoi diagrams},
  volume = {31},
  ISSN = {0167-9457},
  url = {http://dx.doi.org/10.1016/j.humov.2012.04.006},
  DOI = {10.1016/j.humov.2012.04.006},
  number = {6},
  journal = {Human Movement Science},
  publisher = {Elsevier BV},
  author = {Fonseca,  Sofia and Milho,  João and Travassos,  Bruno and Araújo,  Duarte},
  year = {2012},
  month = dec,
  pages = {1652–1659}
}

@article{barros2007analysis,
  title={Analysis of the distances covered by first division Brazilian soccer players obtained with an automatic tracking method},
  author={Barros, Ricardo ML and Misuta, Milton S and Menezes, Rafael P and Figueroa, Pascual J and Moura, Felipe A and Cunha, Sergio A and Anido, Ricardo and Leite, Neucimar J},
  journal={Journal of sports science \& medicine},
  volume={6},
  number={2},
  pages={233},
  year={2007}
}

@article{Moura2013,
  title = {A spectral analysis of team dynamics and tactics in Brazilian football},
  volume = {31},
  ISSN = {1466-447X},
  url = {http://dx.doi.org/10.1080/02640414.2013.789920},
  DOI = {10.1080/02640414.2013.789920},
  number = {14},
  journal = {Journal of Sports Sciences},
  publisher = {Informa UK Limited},
  author = {Moura,  Felipe Arruda and Martins,  Luiz Eduardo Barreto and Anido,  Ricardo O. and Ruffino,  Paulo Régis C. and Barros,  Ricardo M. L. and Cunha,  Sergio Augusto},
  year = {2013},
  month = oct,
  pages = {1568–1577}
}

@article{Moura2016,
  title = {Coordination analysis of players’ distribution in football using cross-correlation and vector coding techniques},
  volume = {34},
  ISSN = {1466-447X},
  url = {http://dx.doi.org/10.1080/02640414.2016.1173222},
  DOI = {10.1080/02640414.2016.1173222},
  number = {24},
  journal = {Journal of Sports Sciences},
  publisher = {Informa UK Limited},
  author = {Moura,  Felipe Arruda and van Emmerik,  Richard E. A. and Santana,  Juliana Exel and Martins,  Luiz Eduardo Barreto and Barros,  Ricardo Machado Leite de and Cunha,  Sergio Augusto},
  year = {2016},
  month = apr,
  pages = {2224–2232}
}

@article{Nakamura2017,
  title = {Repeated-Sprint Sequences During Female Soccer Matches Using Fixed and Individual Speed Thresholds},
  volume = {31},
  ISSN = {1064-8011},
  url = {http://dx.doi.org/10.1519/JSC.0000000000001659},
  DOI = {10.1519/jsc.0000000000001659},
  number = {7},
  journal = {Journal of Strength and Conditioning Research},
  publisher = {Ovid Technologies (Wolters Kluwer Health)},
  author = {Nakamura,  Fábio Y. and Pereira,  Lucas A. and Loturco,  Irineu and Rosseti,  Marcelo and Moura,  Felipe A. and Bradley,  Paul S.},
  year = {2017},
  month = jul,
  pages = {1802–1810}
}

@article{Souza2018,
  title = {Space configuration and numerical relationship during professional soccer matches: a proposal for small-sided games design},
  volume = {2018},
  ISSN = {1899-1955},
  url = {http://dx.doi.org/10.5114/hm.2018.83386},
  DOI = {10.5114/hm.2018.83386},
  number = {5},
  journal = {Human Movement},
  publisher = {Termedia Sp. z.o.o.},
  author = {Souza,  Nicolau Melo de and Caetano,  Fabio Giuliano and Santiago,  Paulo Roberto Pereira and Cunha,  Sergio Augusto and Torres,  Ricardo da Silva and Moura,  Felipe Arruda},
  year = {2018},
  pages = {121–128}
}

@article{Caetano2019,
  title = {Analysis of Match Dynamics of Different Soccer Competition Levels Based on The Player Dyads},
  volume = {70},
  ISSN = {1899-7562},
  url = {http://dx.doi.org/10.2478/hukin-2019-0030},
  DOI = {10.2478/hukin-2019-0030},
  number = {1},
  journal = {Journal of Human Kinetics},
  publisher = {Termedia Sp. z.o.o.},
  author = {Caetano,  Fabio Giuliano and Silva,  Vitor Panula da and Torres,  Ricardo da Silva and Anido,  Ricardo de Oliveira and Cunha,  Sergio Augusto and Moura,  Felipe Arruda},
  year = {2019},
  month = nov,
  pages = {173–182}
}

```

## Tutorial Video 🎬🎥
The tutorial video is available [here](https://youtu.be/RBs5-m0Gknw?si=PjVAwBU3mmRkyN-X). It provides a step-by-step guide, covering everything from installation and running the software to creating figures and videos.

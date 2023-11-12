function [res] = tacticalanalysisteamectors(dataraw)
%   Calculate the distance between sectors
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
global selections 
    dirsave = selections.Gamedir;
    mkdir([dirsave filesep 'Results'])
    
%%	Separating data
    xdata = dataraw.X; 
    ydata = dataraw.Y;

%%  Player's name
    playfull = [selections.PlayersList.Defender;selections.PlayersList.Midfielder;selections.PlayersList.Forwards];
    for p = 1:size(playfull)
        po= strfind(playfull{p},'.');
        players{p,1} = playfull{p}(1:po(end)-1);
        players{p,1} = strrep(players{p},'_','-');
    end

%%  Separating sectors  
%   Defender
    sD = size(selections.PlayersList.Defender,1); 
    xdataD = xdata(:,1:sD); 
    ydataD = ydata(:,1:sD); 

%   Midfielder
    sM = size(selections.PlayersList.Midfielder,1); 
    xdataM = xdata(:,1+sD:sM+sD); 
    ydataM = ydata(:,1+sD:sM+sD); 

%   Forwards
    sF = size(selections.PlayersList.Forwards,1); 
    xdataF = xdata(:,1+sD+sM:sM+sD+sF); 
    ydataF = ydata(:,1+sD+sM:sM+sD+sF);

%%  Calculating the averages positions of each sector
%   Averages of each player     
%   Defender
    DPlayMeanX = mean(xdataD,1);
    DPlayMeanY = mean(ydataD,1);
%   Midfielder
    MPlayMeanX = mean(xdataM,1);
    MPlayMeanY = mean(ydataM,1);
%   Forwards
    FPlayMeanX = mean(xdataF,1);
    FPlayMeanY = mean(ydataF,1);

%   Sector average
%   Defender
    DSecMeanX = mean(DPlayMeanX);
    DSecMeanY = mean(DPlayMeanY);
%   Midfielder
    MSecMeanX = mean(MPlayMeanX);
    MSecMeanY = mean(MPlayMeanY);
%   Forwards
    FSecMeanX = mean(FPlayMeanX);
    FSecMeanY = mean(FPlayMeanY);

%   Calculating distance between the avaregares betweem sectors (Euclidian distance)
%   Defender - Midfielder
    distmeanDM = pdist([DSecMeanX DSecMeanY;MSecMeanX MSecMeanY],'euclidean');

%   Midfielder - Forwards
    distmeanMF = pdist([MSecMeanX MSecMeanY;FSecMeanX FSecMeanY],'euclidean');

%   Defender - Forwards
    distmeanDF = pdist([DSecMeanX DSecMeanY;FSecMeanX FSecMeanY],'euclidean');

%%  Calculating the medians positions of each sector
%   Medians of each player     
%   Defender
    DPlaymedianX = median(xdataD,1);
    DPlaymedianY = median(ydataD,1);
%   Midfielder
    MPlaymedianX = median(xdataM,1);
    MPlaymedianY = median(ydataM,1);
%   Forwards
    FPlaymedianX = median(xdataF,1);
    FPlaymedianY = median(ydataF,1);

%   Sector median
%   Defender
    DSecmedianX = median(DPlaymedianX);
    DSecmedianY = median(DPlaymedianY);
%   Midfielder
    MSecmedianX = median(MPlaymedianX);
    MSecmedianY = median(MPlaymedianY);
%   Forwards
    FSecmedianX = median(FPlaymedianX);
    FSecmedianY = median(FPlaymedianY);

%   Calculating distance between the avaregares betweem sectors (Euclidian distance)
%   Defender - Midfielder
    distmedianDM = pdist([DSecmedianX DSecmedianY;MSecmedianX MSecmedianY],'euclidean');

%   Midfielder - Forwards
    distmedianMF = pdist([MSecmedianX MSecmedianY;FSecmedianX FSecmedianY],'euclidean');

%   Defender - Forwards
    distmedianDF = pdist([DSecmedianX DSecmedianY;FSecmedianX FSecmedianY],'euclidean');
    
%   Team mean vector
    TMeanX = mean(xdata,2); 
    TMeanY = mean(ydata,2);
    TMean = [TMeanX TMeanY];
    
%%  Calculating Streat Index of each sector

for i = 1:size(xdata,1)
    % Defender 
    linXD = xdataD(i,:); 
    linYD = ydataD(i,:); 
    DMeanX = mean(linXD,2);
    DMeanY = mean(linYD,2);
    DMatXY = [linXD' linYD']; 
    DMean = [DMeanX DMeanY];
    
    % Midfielder 
    linXM = xdataM(i,:); 
    linYM = ydataM(i,:); 
    MMeanX = mean(linXM,2);
    MMeanY = mean(linYM,2);
    MMatXY = [linXM' linYM']; 
    MMean = [MMeanX MMeanY];  
        
    % Forwards 
    linXF = xdataF(i,:); 
    linYF = ydataF(i,:);
    FMeanX = mean(linXF,2);
    FMeanY = mean(linYF,2);
    FMatXY = [linXF' linYF']; 
    FMean = [FMeanX FMeanY];
    
    % SI - Defenders
    for d = 1:size(DMatXY,1)
        ST_D(i,d) = pdist([DMatXY(d,:);DMean]); 
    end
   
    
    % SI - Midfields
    for m = 1:size(MMatXY,1)
        ST_M(i,m) = pdist([MMatXY(m,:);MMean]); 
    end
    
    % SI - Forwards
    for f = 1:size(FMatXY,1)
        ST_F(i,f) = pdist([FMatXY(f,:);FMean]); 
    end     
end 

%%  Calculating Vector Coding of Strech Index (SI)























end
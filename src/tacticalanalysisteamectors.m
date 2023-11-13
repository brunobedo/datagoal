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

   
%%  Calculating Streat Index of each sector
figure()
campo 

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
    for w = 1:size(DMatXY,1)
        ST_D(i,w) = pdist([DMatXY(w,:); DMeanX DMeanY]);
        p1a{w} = plot(DMatXY(w,1),DMatXY(w,2),'ro','MarkerSize',5,'LineWidth',3);
    end
    p2a = plot(DMeanX,DMeanY,'^b','MarkerSize',5,'LineWidth',3);
    pause(0.25)
    delete(p1a)
    delete(p2a)
    disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])

%     % SI - Midfields
%     for m = 1:size(MMatXY,1)
%         ST_M(i,m) = pdist([MMatXY(m,:);MMean]); 
%     end
%     
%     % SI - Forwards
%     for f = 1:size(FMatXY,1)
%         ST_F(i,f) = pdist([FMatXY(f,:);FMean]); 
%     end  


end
%%  Calculating Vector Coding of Strech Index (SI)






















end
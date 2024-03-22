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


    %%  Calculating variable frame by frame 
    for i = 1:size(xdata,1)
        % Defender 
        linXD = xdataD(i,:); 
        linYD = ydataD(i,:); 
        DMeanX = mean(linXD,2);
        DMeanY = mean(linYD,2);
        DMatXY = [linXD' linYD']; 
        DMean(i,:) = [DMeanX DMeanY];
        
        % Midfielder 
        linXM = xdataM(i,:); 
        linYM = ydataM(i,:); 
        MMeanX = mean(linXM,2);
        MMeanY = mean(linYM,2);
        MMatXY = [linXM' linYM']; 
        MMean(i,:) = [MMeanX MMeanY];  
        
        % Forwards 
        linXF = xdataF(i,:); 
        linYF = ydataF(i,:);
        FMeanX = mean(linXF,2);
        FMeanY = mean(linYF,2);
        FMatXY = [linXF' linYF']; 
        FMean(i,:) = [FMeanX FMeanY];
        
        %%% Strech Index 
        % SI - Defenders
        for w = 1:size(DMatXY,1)
            SI_D(i,w) = pdist([DMatXY(w,:); DMean(i,:)]);
        end
        
        % SI - Midfields
        for m = 1:size(MMatXY,1)
            SI_M(i,m) = pdist([MMatXY(m,:); MMean(i,:)]);
        end
        
        % SI - Forwards
        for f = 1:size(FMatXY,1)
            SI_F(i,f) = pdist([FMatXY(f,:); FMean(i,:)]);
        end
            
        %%% Sector Distances 
        % Defender - Midfielder
        DM_dist(i,1) =  pdist([DMean(i,:); MMean(i,:)]);
        DF_dist(i,1) =  pdist([DMean(i,:); FMean(i,:)]);
        MF_dist(i,1) =  pdist([MMean(i,:); FMean(i,:)]);

    end
    %  Strech Index (SI) - Mean 
    si_defenders = mean(SI_D,2);
    si_midfields = mean(SI_M,2);
    si_forwards  = mean(SI_F,2); 


    %% Calculating Vector Coding (VC)
    %   Defenders(SI)  vs  Midfields(SI) 
    vc_DM = calculate_vc(si_defenders,si_midfields);

    %   Defenders(SI)  vs  Forwards (SI) 
    vc_DF = calculate_vc(si_defenders,si_forwards);

    %   Midfields(SI)  vs  Forwards (SI) 
    vc_MF = calculate_vc(si_midfields,si_forwards);


    %%
    % Figures
    % figure(1); clf
    % campo()    
    %     p1a = plot(DMatXY(:,1),DMatXY(:,2), 'ro','MarkerSize',5,'LineWidth',3); 
    %     p1b = plot(DMean(:,1),DMean(:,2), 'r^','MarkerSize',5,'LineWidth',3);
    % %     convD = convhull(linXD,linYD);
    % %     p1c = plot(linXD(1,convD),linYD(1,convD),'-r');  
    %         p1d(w) = plot([DMatXY(w,1),DMean(1,1)],[DMatXY(w,2),DMean(1,2)],'--r');

    %     p2a = plot(MMatXY(:,1),MMatXY(:,2), 'bo','MarkerSize',5,'LineWidth',3); 
    %     p2b = plot(MMean(:,1),MMean(:,2), 'b^','MarkerSize',5,'LineWidth',3);   
    %         p2c(m) = plot([MMatXY(m,1),MMean(1,1)],[MMatXY(m,2),MMean(1,2)],'--b');

    %     pause(0.25)
    %     delete(p1a)
    %     delete(p1b)
    % %     delete(p1c)
    %     delete(p1d)
    %     delete(p2a)
    %     delete(p2b)
    %     delete(p2c)


    end


    %%  Functions 
    function [VC,vc_phase] = calculate_vc(series1,series2)
        hypotenuse=sqrt((diff(series1).^2)+(diff(series2).^2));
        sine=diff(series2)./hypotenuse;
        cosine=diff(series1)./hypotenuse;

        VC=atan2(sine,cosine)*(180/pi);

        [lin,value]=find(VC<0);

        VC(lin,1)=360+VC(lin,1);
        
        phase = zeros(size(VC,1),1);
        
        for row=1:size(VC,1)
            
            vc_line = VC(row,1);
            
            if (vc_line>=0 & VC<22.5)|(vc_line>=157.5 &vc_line<202.5)|(vc_line>=337.5 & vc_line<360)
                phase(row,1)=1;
            elseif (vc_line>=22.5 & vc_line<67.5)|(vc_line>=202.5 & vc_line<247.5)
                phase(row,1)=2;
            elseif (vc_line>=67.5 & vc_line<112.5)|(vc_line>=247.5 & vc_line<292.5)
                phase(row,1)=3;
            elseif (vc_line>=112.5 & vc_line<157.5)|(vc_line>=292.5 & vc_line<337.5)
                phase(row,1)=4;
            end
        end
            % Calculating the frequency for each pattern of coordination
            
        arrumar depois!!! 
        
        vc_phase_1 = length(find(phase==1))/length(phase)*100; % Serie 1 Phase
        vc_phase_2 = length(find(phase==2))/length(phase)*100; % In-phase
        vc_phase_3 = length(find(phase==3))/length(phase)*100; % Serie 2 Phase
        vc_phase_4 = length(find(phase==4))/length(phase)*100; % Anti-phase
    end




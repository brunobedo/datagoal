function [res] = distanceteamsectors(dataraw)
%   This file is part of DataGoal: a Matlab Toolbox to Linear and Non-linear Soccer Positional Data Analysis.
%   Copyright (C) 2024 Bruno L. S. Bedo, Felipe A. Moura, Rodrigo Aquino, Sérgio A. Cunha, Paulo R. P. Santiago
% 
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
% 
%       http://www.apache.org/licenses/LICENSE-2.0
% 
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
%   Bruno L. S. Bedo,
%   <bruno.bedo@usp.br>
    global selections 
    dirsave = selections.Gamedir;
    mkdir([dirsave filesep 'Results'])
    
    %	Separating data
    xdata = dataraw.X; 
    ydata = dataraw.Y;

    %  Player's name
    playfull = [selections.PlayersList.Defender;selections.PlayersList.Midfielder;selections.PlayersList.Forwards];
    for p = 1:size(playfull)
        po= strfind(playfull{p},'.');
        players{p,1} = playfull{p}(1:po(end)-1);
        players{p,1} = strrep(players{p},'_','-');
    end

    %  Separating sectors  
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


    %  Calculating variable frame by frame 
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
        
        % Distance
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
            
        % Sector Distances 
        % Defender - Midfielder
        DM_dist(i,1) =  pdist([DMean(i,:); MMean(i,:)]);
        DF_dist(i,1) =  pdist([DMean(i,:); FMean(i,:)]);
        MF_dist(i,1) =  pdist([MMean(i,:); FMean(i,:)]);

    end
%   Distance Average
    DM_dist_mean = mean(DM_dist); 
    DF_dist_mean = mean(DF_dist); 
    MF_dist_mean = mean(MF_dist);
    res_mean_dist = [DM_dist_mean; DF_dist_mean; MF_dist_mean]; 
    
    %  Strech Index (SI) - Mean 
    si_defenders = mean(SI_D,2);
    si_midfields = mean(SI_M,2);
    si_forwards  = mean(SI_F,2); 
    si_defenders_mean = mean(si_defenders);
    si_midfields_mean = mean(si_midfields);
    si_forwards_mean = mean(si_forwards); 
    si_mean = [si_defenders_mean; si_midfields_mean; si_forwards_mean];
    
    % Calculating Vector Coding (VC)
    %   Defenders(SI)  vs  Midfields(SI) 
    [vc_DM, vc_phase_DM] = calculate_vc(si_defenders,si_midfields);

    %   Defenders(SI)  vs  Forwards (SI) 
    [vc_DF, vc_phase_DF] = calculate_vc(si_defenders,si_forwards);

    %   Midfields(SI)  vs  Forwards (SI) 
    [vc_MF, vc_phase_MF] = calculate_vc(si_midfields,si_forwards);
    
    res_si_raw = [si_defenders, si_midfields, si_forwards];
    res_dist_taw = [DM_dist, DF_dist, MF_dist];
    
    res_vc_raw = [vc_DM, vc_DF, vc_MF];
    res_vc_mean = [vc_phase_DM; vc_phase_DF; vc_phase_MF];
    
    %%  Saving results
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    
    % Saving means
    tit1 = {'Strech Index (m)'}; 
    titSI = {'Defeders'; 'Midfields';'Forwards'};
    xlswrite(fname,tit1,1,'A1')
    xlswrite(fname,titSI,1,'A2')
    xlswrite(fname,si_mean,1,'B2')
    
    tit2 = {'Sector Distances(m)'}; 
    titDist = {'D-M'; 'D-F';'M-D'};
    xlswrite(fname,tit2,1,'C1')
    xlswrite(fname,titDist,1,'C2')
    xlswrite(fname,si_mean,1,'D2')
    
    tit3 = {'Coordenação (%)'}; 
    tit1VC = {'D-M'; 'D-F';'M-D'};
    tit2VC = {'InPhase', 'Anti-Phase','Phase 1', 'Phase 2'};
    xlswrite(fname,tit3,1,'E1')
    xlswrite(fname,tit1VC,1,'E2')
    xlswrite(fname,tit2VC,1,'F1')
    xlswrite(fname,res_vc_mean,1,'F2')
    
    % Saving Raw Results
    % SI
    tit4 = {'Strech Index (m)'}; 
    titSI = {'Defeders', 'Midfields','Forwards'};
    xlswrite(fname,tit4,1,'J1')
    xlswrite(fname,titSI,1,'K1')
    xlswrite(fname,res_si_raw,1,'K2')
    
    % Sector Distance
    tit5 = {'Sector Distance (m)'}; 
    titDist = {'D-M', 'D-F','M-D'};
    xlswrite(fname,tit5,1,'N1')
    xlswrite(fname,titDist,1,'O1')
    xlswrite(fname,res_dist_taw,1,'O2')
    
    % Vector Coding
    tit6 = {'Vector Coding (°)'}; 
    titDist = {'D-M', 'D-F','M-D'};
    xlswrite(fname,tit6,1,'R1')
    xlswrite(fname,titDist,1,'S1')
    xlswrite(fname,res_vc_raw,1,'S2')
    
end


    %  Functions 
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
            
        vc_phase_1 = length(find(phase==1))/length(phase)*100; % Serie 1 Phase
        vc_phase_2 = length(find(phase==2))/length(phase)*100; % In-phase
        vc_phase_3 = length(find(phase==3))/length(phase)*100; % Serie 2 Phase
        vc_phase_4 = length(find(phase==4))/length(phase)*100; % Anti-phase
        
        vc_phase = [vc_phase_1, vc_phase_2, vc_phase_3, vc_phase_4];
    end




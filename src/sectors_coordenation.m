function [res1] = sectors_coordenation(dataraw)
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
    playfull = [selections.PlayersList.Defender;selections.PlayersList.Midfielder;selections.PlayersList.Forwards];
    for p = 1:size(playfull)
        po= strfind(playfull{p},'.');
        players{p,1} = playfull{p}(1:po(end)-1);
        players{p,1} = strrep(players{p},'_','-');
    end    
    %   Separating data
    xdata = dataraw.X; 
    ydata = dataraw.Y;

    %%
    %   Time Vector
    vtime = [(0:size(xdata,1)-1)/str2double(selections.FreqAc)]'; 
    vtime = vtime./60; 
        
    %%    
    %   Mean of position of each pleayser 
    PlayersMeanX = mean(xdata,1);
    PlayersMeanY = mean(ydata,1);
    
    %   Team Mean 
    teamMeanX = mean(PlayersMeanX);
    teamMeanY = mean(PlayersMeanY);
    
    %   Median of position of each pleayser
    PlayersMedianX = median(xdata,1);
    PlayersMedianY = median(ydata,1);
    %   Team Mean 
    teamMedianX = median(PlayersMedianX);
    teamMediany = median(PlayersMedianY);   

    %   Team mean vector
    TMeanX = mean(xdata,2); 
    TMeanY = mean(ydata,2);
    TMean = [TMeanX TMeanY];
    
        %%  Separating sectors  
    %   Defender
    sD = size(selections.PlayersList.Defender,1); 
    xdataD = xdata(:,1:sD); 
    ydataD = ydata(:,1:sD); 
    xmeanD = mean(xdataD,2); 
    ymeanD = mean(ydataD,2); 

    %   Midfielder
    sM = size(selections.PlayersList.Midfielder,1); 
    xdataM = xdata(:,1+sD:sM+sD); 
    ydataM = ydata(:,1+sD:sM+sD); 
    xmeanM = mean(xdataM,2); 
    ymeanM = mean(ydataM,2); 
    
    %   Forwards
    sF = size(selections.PlayersList.Forwards,1); 
    xdataF = xdata(:,1+sD+sM:sM+sD+sF); 
    ydataF = ydata(:,1+sD+sM:sM+sD+sF);
    xmeanF = mean(xdataF,2); 
    ymeanF = mean(ydataF,2);
    
    %%  Calculating Vector Coding
    %   Script created by Felipe Arruda Moura - 09/07/2013
    datafrequency = str2num(selections.FreqAc); 
    
    % D vs M    
    series1 = xmeanD;
    series2 = xmeanM;
    hypotenuse=sqrt((diff(series1).^2)+(diff(series2).^2));

    sine=diff(series2)./hypotenuse;
    cosine=diff(series1)./hypotenuse;

    VC=atan2(sine,cosine)*(180/pi);

    [lin,value]=find(VC<0);

    VC(lin,1)=360+VC(lin,1);
    notanumber=isnan(VC);
    res1(:,1) = VC;
    title_vc1 = {'IF','AF','D','M'}';
    res1vc(:,1) = create_CtgVar(VC)';
    
    % D vs F    
    series1 = xmeanD;
    series2 = xmeanF;
    hypotenuse=sqrt((diff(series1).^2)+(diff(series2).^2));

    sine=diff(series2)./hypotenuse;
    cosine=diff(series1)./hypotenuse;

    VC=atan2(sine,cosine)*(180/pi);

    [lin,value]=find(VC<0);

    VC(lin,1)=360+VC(lin,1);
    notanumber=isnan(VC);
    res1(:,2) = VC;
    title_vc2 = {'IF','AF','D','F'}';
    res2vc(:,1) = create_CtgVar(VC)';
    
    % M vs F    
    series1 = xmeanM;
    series2 = xmeanF;
    hypotenuse=sqrt((diff(series1).^2)+(diff(series2).^2));

    sine=diff(series2)./hypotenuse;
    cosine=diff(series1)./hypotenuse;

    VC=atan2(sine,cosine)*(180/pi);

    [lin,value]=find(VC<0);

    VC(lin,1)=360+VC(lin,1);
    notanumber=isnan(VC);
    res1(:,3) = VC;
    title_vc3 = {'IF','AF','M','F'}';
    res3vc(:,1) = create_CtgVar(VC)';
    
    tit1 = {'Vector Coding',};
    tit2 = {'Time(s)','DxM','MxF','DxF'};
    vtime = [0:size(VC,1)-1/str2num(selections.FreqAc)]';
    redf = [vtime res1];
    
    
    %%  Saving results
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['NonLinear_Collective_Res_',selections.ColNonLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    xlswrite(fname,tit1,1,'A1')
    xlswrite(fname,tit2,1,'A2')
    xlswrite(fname,redf,1,'A3')
    xlswrite(fname,{'DxM'},1,'E2')
    xlswrite(fname,title_vc1,1,'E3')
    xlswrite(fname,res1vc,1,'F3')
    xlswrite(fname,{'MxF'},1,'G2')
    xlswrite(fname,title_vc2,1,'G3')
    xlswrite(fname,res2vc,1,'H3')
    xlswrite(fname,{'DxF'},1,'I2')
    xlswrite(fname,title_vc3,1,'I3')
    xlswrite(fname,res3vc,1,'J3')  
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColNonLinTyp(1:end));
    ewb.Save 
    ewb.Close(false)
end


function [group_phase] = create_CtgVar(coupangle)
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
    %%  CREATE_CTGVAR Assigns categorical variables based on angle ranges and calculates the frequency of each coordination pattern.
  
    %   [group_phase] = CREATE_CTGVAR(coupangle) takes a vector of angles in degrees and assigns them to one of four coordination 
    %   patterns based on predefined angle ranges. The function then calculates the frequency (in percentage) of each pattern 
    %   and returns these frequencies in the output variable 'group_phase'.
    %
    %   INPUT:
    %       coupangle - A vector of angles in degrees (size Nx1) for which the categorical variables will be assigned.
    %
    %   OUTPUT:
    %       group_phase - A 1x4 vector containing the percentage frequency of each coordination pattern:
    %                     1. Joint 1 - Phase (0 to 22.5 degrees, 157.5 to 202.5 degrees, 337.5 to 360 degrees)
    %                     2. In-Phase (22.5 to 67.5 degrees, 202.5 to 247.5 degrees)
    %                     3. Joint 2 - Phase (67.5 to 112.5 degrees, 247.5 to 292.5 degrees)
    %                     4. Anti-Phase (112.5 to 157.5 degrees, 292.5 to 337.5 degrees)
    %
    %   EXAMPLE:
    %       angles = [10, 30, 70, 120, 160, 210, 250, 300, 340];
    %       frequencies = create_CtgVar(angles);
    %       disp(frequencies);
    
    CtgVar_vc_DG = zeros(size(coupangle));

    CtgVar_vc_DG((coupangle >= 0) & (coupangle < 22.5)) = 1;        % Grupo 1 - Phase
    CtgVar_vc_DG((coupangle >= 22.5) & (coupangle < 67.5)) = 2;     % In-Phase
    CtgVar_vc_DG((coupangle >= 67.5) & (coupangle < 112.5)) = 3;    % Grupo 2 - Phase
    CtgVar_vc_DG((coupangle >= 112.5) & (coupangle < 157.5)) = 4;   % Anti-Phase
    CtgVar_vc_DG((coupangle >= 157.5) & (coupangle < 202.5)) = 1;   % Grupo 1 - Phase
    CtgVar_vc_DG((coupangle >= 202.5) & (coupangle < 247.5)) = 2;   % In-Phase
    CtgVar_vc_DG((coupangle >= 247.5) & (coupangle < 292.5)) = 3;   % Grupo 2 - Phase
    CtgVar_vc_DG((coupangle >= 292.5) & (coupangle < 337.5)) = 4;   % Anti-Phase
    CtgVar_vc_DG((coupangle >= 337.5) & (coupangle < 360)) = 1;     % Grupo 1 - Phase

    % Calcular a frequência para cada padrão de coordenação
    group_phase = zeros(1, 4);
    for i = 1:4
        group_phase(i) = round((sum(CtgVar_vc_DG == i) / length(CtgVar_vc_DG)) * 100, 3);
    end

    % Exibir os resultados
%     disp('Frequências de cada padrão de coordenação:');
%     disp(group_phase);
end

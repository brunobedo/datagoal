function [res] = ClusterPhase(dataraw)
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
    xdatat1 = dataraw.X; 
    ydatat1 = dataraw.Y;
    xdatat2 = dataraw.OpX; 
    ydatat2 = dataraw.OpY;    

    %%  Metrica to calculate  
    %   Area 
    for i = 1:size(xdatat1,1)
        K1 = convhull(xdatat1(i,:),ydatat1(i,:));
        K2 = convhull(xdatat2(i,:),ydatat2(i,:));
        SufAreat1(i,:) = polyarea(xdatat1(i,K1),ydatat1(i,K1));
        SufAreat2(i,:) = polyarea(xdatat2(i,K2),ydatat2(i,K2));
    end

    %%  Width, Length and LpW Ratio
    for i = 1:size(xdatat1,1)
    %   Team 1
    %   Width
        [Aminvt1(i,1) Aminpt1(i,:)] = min(ydatat1(i,:)); 
        [Amaxvt1(i,1) Amaxpt1(i,:)] = max(ydatat1(i,:));     

    %   Length 
        [Pminvt1(i,1) Pminpt1(i,:)] = min(xdatat1(i,:));
        [Pmaxvt1(i,1) Pmaxpt1(i,:)] = max(xdatat1(i,:));
        
    %   Calculating distances
    %   Width
        DistAt1(i,1) = pdist([xdatat1(i,Aminpt1(i,:)),ydatat1(i,Aminpt1(i,:));xdatat1(i,Amaxpt1(i,:)),ydatat1(i,Amaxpt1(i,:))],'euclidean');
    %   Length
        DistPt1(i,1) = pdist([xdatat1(i,Pminpt1(i,:)),ydatat1(i,Pminpt1(i,:));xdatat1(i,Pmaxpt1(i,:)),ydatat1(i,Pmaxpt1(i,:))],'euclidean');

    %   Calculating the LpW Ratio 
        LpWRatiot1(i,1) = DistPt1(i,1)/DistAt1(i,1);

    %   Team 2
    %   Width
        [Aminvt2(i,1) Aminpt2(i,:)] = min(ydatat2(i,:)); 
        [Amaxvt2(i,1) Amaxpt2(i,:)] = max(ydatat2(i,:));     

    %   Length 
        [Pminvt2(i,1) Pminpt2(i,:)] = min(xdatat2(i,:));
        [Pmaxvt2(i,1) Pmaxpt2(i,:)] = max(xdatat2(i,:));
        
    %   Calculating distances
    %   Width
        DistAt2(i,1) = pdist([xdatat2(i,Aminpt2(i,:)),ydatat2(i,Aminpt2(i,:));xdatat2(i,Amaxpt2(i,:)),ydatat2(i,Amaxpt2(i,:))],'euclidean');
    %   Length
        DistPt2(i,1) = pdist([xdatat2(i,Pminpt2(i,:)),ydatat2(i,Pminpt2(i,:));xdatat2(i,Pmaxpt2(i,:)),ydatat2(i,Pmaxpt2(i,:))],'euclidean');

    %   Calculating the LpW Ratio 
        LpWRatiot2(i,1) = DistPt2(i,1)/DistAt2(i,1);
    end

    %%  Select a variable
    listvar = {'Effective Area','Width','Length','LpWRatio'};
    [indx,~] = listdlg('PromptString','Select the variables:','ListString',listvar,'Name','Cluster Phase');
    h1 =  waitbar(0,'Calculating the Cluster Phase Analysis');
    set(h1,'name','Cluster Phase Analysis')
    for v = 1:size(indx,2)
        vt = listvar{indx(v)};
        waitbar(v/size(indx,2))
        switch vt
            case 'Effective Area'
                vt1 = SufAreat1; 
                vt2 = SufAreat2;
            
            case 'Width'
                vt1 = DistAt1; 
                vt2 = DistAt2;
                
            case 'Length'
                vt1 = DistPt1; 
                vt2 = DistPt2;
                
            case 'LpWRatio'
                vt1 = LpWRatiot1; 
                vt2 = LpWRatiot2;
        end

    %   Calculating the Cluster Phase Analysis
    %   [1]  Frank, T. D., & Richardson, M. J. (2010). On a test statistic for 
    %        the Kuramoto order parameter of synchronization: with an illustration 
    %        for group synchronization during rocking chairs.
    %
    %   [2]  Richardson,M.J., Garcia, R., Frank, T. D., Gregor, M., & 
    %        Marsh,K. L. (2010). Measuring Group Synchrony: A Cluster-Phase Method 
    %        for Analyzing Multivariate Movement Time-Series 
    %
    %   Code Contact & References:
    %        michael.richardson@uc.edu
    %        http://homepages.uc.edu/~richamo/
    ts_data = [vt1 vt2];
    TSnumber = size(ts_data,2); 
    TSlength = size(ts_data,1); 
    %% Compute phase for each TS using Hilbert transform
    %**************************************************************************
    TSphase = zeros(TSlength-1,TSnumber);
    for k=1:TSnumber
        hrp = hilbert(ts_data(:,k));
        for n=1:TSlength-1
            TSphase(n,k)=atan2(real(hrp(n)),imag(hrp(n)));
        end
        TSphase(:,k)=unwrap(TSphase(:,k));
    end

    %% Compute mean running (Cluster) phase
    %**************************************************************************
    clusterphase = zeros(1,TSlength-1);
    for n=1:TSlength-1
        ztot=complex(0,0);
        for k=1:TSnumber
            z=exp(1i*TSphase(n,k));
            ztot=ztot+z;
        end
        ztot=ztot/TSnumber;
        clusterphase(n)=angle(ztot);
    end
    clusterphase = unwrap(clusterphase);

    %% Compute relative phases between phase of TS and cluster phase
    %**************************************************************************
    TSrpIND=zeros(TSlength-1,TSnumber);
    INDrpM = zeros(TSnumber,1);
    INDrhoM = zeros(TSnumber,1);
    for k=1:TSnumber
        ztot=complex(0,0);
        for n=1:TSlength-1
            z=exp(1i*(TSphase(n,k)-clusterphase(n)));
            TSrpIND(n,k) = z;
            ztot=ztot+z;
        end
        TSrpIND(:,k) = angle(TSrpIND(:,k))*360/(2*pi); % convert radian to degrees
        ztot=ztot/(TSlength-1);
        INDrpM(k) = angle(ztot);
        INDrhoM(k) = abs(ztot);
    end
    TSRPM = INDrpM;
    INDrpM = (INDrpM(:,1)./(2*pi)*360); % convert radian to degrees

    %% Compute cluster amplitude rhotot in rotation frame
    %**************************************************************************
    TSrhoGRP=zeros(TSlength-1,1);
    for n=1:TSlength-1
        ztot=complex(0,0);
        for k=1:TSnumber
            z=exp(1i*(TSphase(n,k)-clusterphase(n)-TSRPM(k)));
            ztot=ztot+z;
        end
        ztot=ztot/TSnumber;
        TSrhoGRP(n)=abs(ztot);
    end

    GRPrhoM = mean(TSrhoGRP);
    res(:,v) = TSrhoGRP;
    res2(v,:) = GRPrhoM;

    end
    close(h1)
    %   Results
    tit1 = {'Cluster Phase Analysis'};
    tit2 = {'Time(s)',listvar{indx}};
    tit3 =  {'Cluster Phase Analysis (mean)',listvar{indx}}'; 
    vtime = [0:size(TSrhoGRP,1)-1/str2num(selections.FreqAc)]';
    res1 = [vtime res]; 

    %%  Saving results
        prompt = {'Enter file name:'};
        dlgtitle = 'Input title';
        definput = {['NonLinear_Collective_Res_',selections.ColNonLinTyp]};%'.csv'
        titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
        fname = [dirsave filesep 'Results' filesep titfil];
        xlswrite(fname,tit1,1,'A1')
        xlswrite(fname,tit2,1,'A2')
        xlswrite(fname,res1,1,'A3')
        xlswrite(fname,tit3,1,'F1')
        xlswrite(fname,res2,1,'G2')
        e = actxserver('Excel.Application');
        ewb = e.Workbooks.Open(fname);
        ewb.Worksheets.Item(1).Name = char(selections.ColNonLinTyp(1:20));
        ewb.Save 
        ewb.Close(false)
end


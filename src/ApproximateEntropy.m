function [res] = ApproximateEntropy(dataraw)
%   Calculates the Approximate Entropy
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
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

%%  Metrica to calculate ApEn 
%   Area 
for i = 1:size(xdata,1)
    K = convhull(xdata(i,:),ydata(i,:));
    
    SufArea(i,:) = polyarea(xdata(i,K),ydata(i,K));
end

%%  Width, Length and LpW Ratio 
for i = 1:size(xdata,1)
%   Width
    [Aminv(i,1) Aminp(i,:)] = min(ydata(i,:)); 
    [Amaxv(i,1) Amaxp(i,:)] = max(ydata(i,:));     

%   Length 
    [Pminv(i,1) Pminp(i,:)] = min(xdata(i,:)); 
    [Pmaxv(i,1) Pmaxp(i,:)] = max(xdata(i,:));
    
%   Calculating distances
%   Width
    DistA(i,1) = pdist([xdata(i,Aminp(i,:)),ydata(i,Aminp(i,:));xdata(i,Amaxp(i,:)),ydata(i,Amaxp(i,:))],'euclidean');
%   Length
    DistP(i,1) = pdist([xdata(i,Pminp(i,:)),ydata(i,Pminp(i,:));xdata(i,Pmaxp(i,:)),ydata(i,Pmaxp(i,:))],'euclidean');

%   Calculating the LpW Ratio 
    LpWRatio(i,1) = DistP(i,1)/DistA(i,1);
end

%%
%   Calculating the Approximate Entropy of these variables
%   Concept boorowed from http://www.physionet.org/physiotools/ApEn/
%   The perfectly regular signal containing many repetitive patterns has a relatively small 
%   value of approximate entropy while the less predictable random signal
%   has a higher value of approximate entropy.

ApEnWidth    = approximateEntropy(DistA);    % Width
ApEnLength   = approximateEntropy(DistP);    % Length
ApEnLpWRatio = approximateEntropy(LpWRatio); % LpW Ratio 
ApEnSufArea  = approximateEntropy(SufArea);  % Area

%   Results
res = [ApEnWidth ApEnLength ApEnLpWRatio ApEnSufArea]'; 
tit = {'Approximate Entropy (ApEn)','Width','Length','LpWRatio','Area'}';

%%  Saving results
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['NonLinear_Collective_Res_',selections.ColNonLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    xlswrite(fname,tit,1,'A1')
    xlswrite(fname,res,1,'B2')
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColNonLinTyp(1:end));
    ewb.Save 
    ewb.Close(false)
end


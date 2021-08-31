function [res] = SampleEntropy(dataraw)
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
%   Calculates the Sample Entropy
%   This function computes the Sample Entropy (SampEn) algorithm according to the Richman, J. S., & Moorman, J. R. (2000) recommendations. 
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
%   Calculating the Sample entropy (SampEn) of these variables
%   The negative natural logarithm of the conditional probability (A/B) 
%   that two sequences within a tolerance range r for a window length of m points, 
%   remain within r of each other at the next point
%   To use sample entropy with input parameters m = {4,5} and r = {0.25,
%   0.3,0.35}. https://pubmed.ncbi.nlm.nih.gov/10843903/

%   Defening sample entropy input parameters. 
prompt = {'Embedding dimension (m < N):             Suggested values: 4 and 5 ',...
          'Tolerance (percentage applied to the SD): Suggested values: 0.25, 0.3 and 0.35'};
dlgtitle = ['Sample Entropy Input'];
dims = [1 50];
definput = {'4','0.25'};      
SampEnInput = inputdlg(prompt,dlgtitle,dims,definput); 
m = str2num(SampEnInput{1});
r = str2num(SampEnInput{2});

SampEnWidth    = sampen(DistA,  m,r,'chebychev'); % Width
SampEnLength   = sampen(DistP,  m,r,'chebychev'); % Length
SampEnLpWRatio = sampen(LpWRatio,m,r,'chebychev');% LpW Ratio 
SampEnSufArea  = sampen(SufArea,m,r,'chebychev'); % Area

%   Results
res = [SampEnWidth SampEnLength SampEnLpWRatio SampEnSufArea]'; 
tit = {'Sample entropy (SampEn)','Width','Length','LpWRatio','Area'}';

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


function [res] = DynamicOverlap(dataraw)
%   Calculates the Dynamic Overlap
%   Dynamic overlap qd(t) was used to determine the region of the performer-environment state space explored by the players and the rate of exploration on different timescales. Dynamic overlap analysis allowed the slow dynamics on a long timescale (where players’
%   exploration became sufficiently saturated), and the quick dynamics on a shorter timescale
% 	related to the initial relaxation part of the overlap) to be determined.
%   The overlap was defined as a cosine similarity between two binary configuration vectors at
%   ever-increasing time distances (i.e., time lags), capturing the mean similarity of configuration
%   states. The mean dynamic overlap was then fitted by the following equation, which is derived
%   for systems with an intricate hierarchical structure 
%   Ric A, Torrents C, Gonçalves B, Torres-Ronda L, Sampaio J, Hristovski R. 
%   Dynamics of tactical behaviour in association football when manipulating players' space of 
%   interaction. PLoS One. 2017;12(7):e0180773. Published 2017 Jul 14. doi:10.1371/journal.pone.0180773

%   Author: Bruno Luiz Souza Bedo
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
%   Calculating the Dynamic Overlap (DynOverl)
%   The overlap was defined as a cosine similarity between two binary configuration vectors at
%   ever-increasing time distances (i.e., time lags), capturing the mean similarity of configuration
%   states. The mean dynamic overlap was then fitted by the following equation, which is derived
%   for systems with an intricate hierarchical structure 
% 
%   Ric A, Torrents C, Gonçalves B, Torres-Ronda L, Sampaio J, Hristovski R. 
%   Dynamics of tactical behaviour in association football when manipulating players' space of 
%   interaction. PLoS One. 2017;12(7):e0180773. Published 2017 Jul 14. doi:10.1371/journal.pone.0180773

%   Results
% res = [ ]'; 
% tit = {'DynOverl','Width','Length','LpWRatio','Area'}';

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


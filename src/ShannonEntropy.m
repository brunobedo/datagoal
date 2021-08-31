function [res] = ShannonEntropy(dataraw)
%   Calculates the Shannon Entropy
%   Function which computes the Shannon Entropy (SE) of a time series of length
%   'N' using an embedding dimension 'L' and 'Num_int' uniform intervals of
%   quantification. The algoritm presented by Porta et al. at "Measuring 
%   regularity by means of a corrected conditional entropy in sympathetic 
%   outflow". 
%   This code was based in the code wrote by Jesús Monge Álvarez
%   PROJECT: Research Master in signal theory and bioengineering - University of Valladolid
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
%   Calculating the Shannon Entropy(ShanEn)
%   A low Shannon entropy (ShannEn) value (near 0) indicates that the distribution is sharply
%   peaked and the player’s position can be easily predicted. A high ShannEn value (near 1)
%   indicates that the distribution is uniform thus the player’s position is highly variable and
%   unpredictable.
%   SILVA, Pedro, AGUIAR, Paulo, DUARTE, Ricardo, DAVIDS, Keith, ARAÚJO, Duarte and GARGANTA, Júlio (2014).
%   Effects of pitch size and skill level on tactical behaviours of Association Football players during 
%   small-sided and conditioned games. International Journal of Sports Science and Coaching, 9 (5), 993-1006.

%   Defening sample entropy input parameters. 
prompt = {'Embedding dimension: ',...
          'Number of uniform intervals used in the quantification: '};
dlgtitle = [' Shannon Entropy Input'];
dims = [1 50];
definput = {'2','2'};      
ShanEnInput = inputdlg(prompt,dlgtitle,dims,definput); 
L = str2num(ShanEnInput{1});
M = str2num(ShanEnInput{2});

ShanEnWidth    = ShannonEn(DistA,  	L,M); % Width
ShanEnLength   = ShannonEn(DistP,   L,M); % Length
ShanEnLpWRatio = ShannonEn(LpWRatio,L,M); % LpW Ratio 
ShanEnSufArea  = ShannonEn(SufArea, L,M); % Area

%   Results
res = [ShanEnWidth ShanEnLength ShanEnLpWRatio ShanEnSufArea]'; 
tit = {'Shannon Entropy (ShanEn)','Width','Length','LpWRatio','Area'}';

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


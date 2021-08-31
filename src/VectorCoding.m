function [res] = VectorCoding(dataraw)
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
    xdatat1 = dataraw.X; 
    ydatat1 = dataraw.Y;
    xdatat2 = dataraw.OpX; 
    ydatat2 = dataraw.OpY;    

%%  Metrica to calculate ApEn 
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
[indx,~] = listdlg('PromptString','Select the variables:','ListString',listvar,'Name','Vector Coding');

for v = 1:size(indx,2)
    vt = listvar{indx(v)};
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
%%  Calculating Vector Coding
%   Script created by Felipe Arruda Moura - 09/07/2013
    series1 = vt1;
    series2 = vt2; 
    datafrequency = str2num(selections.FreqAc); 

%% Original
hypotenuse=sqrt((diff(series1).^2)+(diff(series2).^2));

sine=diff(series2)./hypotenuse;
cosine=diff(series1)./hypotenuse;

VC=atan2(sine,cosine)*(180/pi);

[lin,value]=find(VC<0);

VC(lin,1)=360+VC(lin,1);
notanumber=isnan(VC);
% VC = VC(notanumber==0,1);  

%%   Results
res(:,v) = [VC];

end

tit1 = {'Vector Coding'};
tit2 = {'Time(s)',listvar{indx}};
vtime = [0:size(VC,1)-1/str2num(selections.FreqAc)]';
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
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColNonLinTyp(1:end));
    ewb.Save 
    ewb.Close(false)

end


function [res] = VilarsProposal(dataraw)
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
%%   
%   Calculating Vilars' proposal
for i = 1:size(xdata,1)
%   Width (Largura - Latera/Lateral)
    [Aminv(i,1) Aminp(i,:)] = min(ydata(i,:)); 
    [Amaxv(i,1) Amaxp(i,:)] = max(ydata(i,:));     

%   Length (Comprimento - Fundo/Fundo)
    [Pminv(i,1) Pminp(i,:)] = min(xdata(i,:)); 
    [Pmaxv(i,1) Pmaxp(i,:)] = max(xdata(i,:));
   
%   Calculating distances
%   Width
    DistW(i,1) = pdist([xdata(i,Aminp(i,:)),ydata(i,Aminp(i,:));xdata(i,Amaxp(i,:)),ydata(i,Amaxp(i,:))],'euclidean');
%   Length
    DistL(i,1) = pdist([xdata(i,Pminp(i,:)),ydata(i,Pminp(i,:));xdata(i,Pmaxp(i,:)),ydata(i,Pmaxp(i,:))],'euclidean');

    K = convhull(xdata(i,:),ydata(i,:));
    SufArea(i,:) = polyarea(xdata(i,K),ydata(i,K));

%   Finding porcetage
%  Largura (Width)
   L25(i,1) = DistW(i,1)*0.25;
   L50(i,1) = DistW(i,1)*0.50;
   L74(i,1) = DistW(i,1)*0.74;
   L100(i,1) = DistW(i,1)*1;

%  Comprimento (Length)
   C25(i,1) = DistL(i,1)*0.25;
   C50(i,1) = DistL(i,1)*0.50;
   C74(i,1) = DistL(i,1)*0.74;
   C100(i,1) = DistL(i,1)*0.1;

%%  Counting the number of players
 x = xdata(i,:)';
 y = ydata(i,:)';

%   Right 
rbN = find(xdata(i,Pminp(i,:))+C50(i,1) >= x & y <=  ydata(i,Aminp(i,:))+L25(i,1)); rb(i,1) = size(rbN,1);  % Back
ppos(i,rbN) = 1;
rfN = find(xdata(i,Pminp(i,:))+C50(i,1) <= x & y <=  ydata(i,Aminp(i,:))+L25(i,1)); rf(i,1) = size(rfN,1);  % Front
ppos(i,rfN) = 2;

%  Left
lbN = find(xdata(i,Pminp(i,:))+C50(i,1) >= x & y >=  ydata(i,Amaxp(i,:))-L25(i,1)); lb(i,1) = size(lbN,1);  % Back
ppos(i,lbN) = 3;
lfN = find(xdata(i,Pminp(i,:))+C50(i,1) <= x & y >=  ydata(i,Amaxp(i,:))-L25(i,1)); lf(i,1) = size(lfN,1);  % Front
ppos(i,lfN) = 4;

% Middle
mbN = find(xdata(i,Pminp(i,:)) <= x & x <= xdata(i,Pminp(i,:))+C25(i,1) & y >=  ydata(i,Aminp(i,:))+L25(i,1) & y <=  ydata(i,Amaxp(i,:))-L25(i,1));         mb(i,1) = size(mbN,1); % Back
ppos(i,mbN) = 5;

mmN = find(xdata(i,Pminp(i,:))+C25(i,1)<= x & x <= xdata(i,Pmaxp(i,:))-C25(i,1) & y >=  ydata(i,Aminp(i,:))+L25(i,1) & y <=  ydata(i,Amaxp(i,:))-L25(i,1)); mm(i,1) = size(mmN,1); % Midle
ppos(i,mmN) = 6;

mfN = find(xdata(i,Pmaxp(i,:))-C25(i,1)<= x & y >=  ydata(i,Aminp(i,:))+L25(i,1) & y <=  ydata(i,Aminp(i,:))+L74(i,1));                                     mf(i,1) = size(mfN,1); % Front
ppos(i,mfN) = 7;

%   Porcenage %
pRB(i,1) = (rb(i,1)/size(x,1))*100;
pRF(i,1) = (rf(i,1)/size(x,1))*100;
pLB(i,1) = (lb(i,1)/size(x,1))*100;
pLF(i,1) = (lf(i,1)/size(x,1))*100;
pMB(i,1) = (mb(i,1)/size(x,1))*100;
pMM(i,1) = (mm(i,1)/size(x,1))*100;
pMF(i,1) = (mf(i,1)/size(x,1))*100;

end
%   Finding the percentual of each players
for p = 1:size(xdata,2)
    m = ppos(:,p);
    numbN = hist(m,1:7);
    numbP(p,:) = [(numbN/size(xdata,1)).*100]';
end

%%   Results
%   Number of players
    % Mean
    res(1,1) = mean(rb);
    res(2,1) = mean(rf);
    res(3,1) = mean(lb);
    res(4,1) = mean(lf);
    res(5,1) = mean(mb);
    res(6,1) = mean(mm);
    res(7,1) = mean(mf);
%   Percentual
    % Mean 
    res(1,2) = mean(pRB);
    res(2,2) = mean(pRF);
    res(3,2) = mean(pLB);
    res(4,2) = mean(pLF);
    res(5,2) = mean(pMB);
    res(6,2) = mean(pMM);
    res(7,2) = mean(pMF);

% 	Creating and saving results
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];

    tit1 = {'VilarsProposal','Right Back','Right Frontal',...
           'Left Back','Left Frontal',...
           'Center Back','Center Middle','Center Frontal'}';
    tit2 = {'Nº Players','%','Name','Right Back (%)','Right Frontal (%)',...
           'Left Back (%)','Left Frontal (%)',...
           'Center Back (%)','Center Middle (%)','Center Frontal (%)'}; 
    tit3 = players;   
    
    xlswrite(fname,tit1,1,'A1')
    xlswrite(fname,tit2,1,'B1')
    xlswrite(fname,tit3,1,'D2')
    xlswrite(fname,res,1,'B2')
    xlswrite(fname,numbP,1,'E2')

    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp(1:end));
    ewb.Save 
    ewb.Close(false)

%%  Creating and saving figure
    f1 = figure(1); clf; set(f1,'name','Sectors distance','units','normalized','outerposition',[0 0 1 1])
    campo
    %axis off
    titsavef1 = ['Field_',selections.ColLinTyp];

    matx = [PlayersMeanX];
    maty = [PlayersMeanY];

%   Calculating variables to plot
%   Width (Largura - Latera/Lateral)
    [AminvM AminpM] = min(maty); 
    [AmaxvM AmaxpM] = max(maty);     

%   Length (Comprimento - Fundo/Fundo)
    [PminvM PminpM] = min(matx); 
    [PmaxvM PmaxpM] = max(matx);

%   Calculating distance
%   Width
    DistWM = pdist([matx(1,AminpM),maty(1,AminpM);matx(1,AmaxpM),maty(1,AmaxpM)],'euclidean');
%   Length
    DistLM = pdist([matx(1,PminpM),maty(1,PminpM);matx(1,PmaxpM),maty(1,PmaxpM)],'euclidean');

    K = convhull(matx,maty);
    SufArea(1,:) = polyarea(matx(1,K),maty(1,K));
    p1a = plot(matx(1,K),maty(1,K),'k');
   
%   Finding porcetage
%   Largura (Width)
    L25M = DistWM*0.25;
    L50M = DistWM*0.50;
    L74M = DistWM*0.74;
    L100M = DistWM*1;   

    p1b = plot([matx(1,PminpM) matx(1,PmaxpM)],[maty(1,AminpM)+L25M maty(1,AminpM)+L25M],'LineWidth',1,'Color','k','LineStyle','- -');
    p1c = plot([matx(1,PminpM) matx(1,PmaxpM)],[maty(1,AmaxpM)-L25M maty(1,AmaxpM)-L25M],'LineWidth',1,'Color','k','LineStyle','- -');

%   Comprimento (Length)
    C25M = DistLM*0.25;
    C50M = DistLM*0.50;
    C74M = DistLM*0.74;
    C100M = DistLM*0.1;
    
%   Lateral
    p1d = plot([matx(1,PminpM)+C50M matx(1,PminpM)+C50M],[maty(1,AminpM) maty(1,AminpM)+L25M],'LineWidth',1,'Color','k','LineStyle','- -');
    p1e = plot([matx(1,PminpM)+C50M matx(1,PminpM)+C50M],[maty(1,AmaxpM)-L25M maty(1,AmaxpM)],'LineWidth',1,'Color','k','LineStyle','- -');

%   Middle
    p1f = plot([matx(1,PminpM)+C25M matx(1,PminpM)+C25M],[maty(1,AminpM)+L25M maty(1,AmaxpM)-L25M],'LineWidth',1,'Color','k','LineStyle','- -');
    p1g = plot([matx(1,PmaxpM)-C25M matx(1,PmaxpM)-C25M],[maty(1,AminpM)+L25M maty(1,AmaxpM)-L25M],'LineWidth',1,'Color','k','LineStyle','- -');

%   Counting the number of players
 x = matx';
 y = maty';

%   Right 
rbNM = find(matx(1,PminpM(1,:))+C50M(1,1) >= x & y <=  maty(1,AminpM(1,:))+L25M); rbM = size(rbNM,1);  % Back
rfNM = find(matx(1,PminpM(1,:))+C50M(1,1) <= x & y <=  maty(1,AminpM(1,:))+L25M); rfM = size(rfNM,1);  % Front

%  Left
lbNM = find(matx(1,PminpM(1,:))+C50M(1,1) >= x & y >=  maty(1,AmaxpM(1,:))-L25M); lbM = size(lbNM,1);  % Back
lfNM = find(matx(1,PminpM(1,:))+C50M(1,1) <= x & y >=  maty(1,AmaxpM(1,:))-L25M); lfM = size(lfNM,1);  % Front

% Middle
% mb(1,:) = find(xdata(1,PminpM(1,:)) <= x & x <= xdata(1,PminpM(1,:))+C25);
mbNM = find(matx(1,PminpM(1,:))      <= x & x <= matx(1,PminpM(1,:))+C25M & y >=  maty(1,AminpM(1,:))+L25M & y <=  maty(1,AminpM(1,:))+L74M);  mbM = size(mbNM,1); % Back
mmNM = find(matx(1,PminpM(1,:))+C25M <= x & x <= matx(1,PmaxpM(1,:))-C25M & y >=  maty(1,AminpM(1,:))+L25M & y <=  maty(1,AmaxpM(1,:))-L25M);  mmM = size(mmNM,1); % Midle
mfNM = find(matx(1,PmaxpM(1,:))-C25M <= x & y >= maty(1,AminpM(1,:))+L25M & y <=  maty(1,AminpM(1,:))+L74M);                                   mfM = size(mfNM,1); % Front

p1h = plot(x(rbNM),y(rbNM),'ro','MarkerSize',5,'LineWidth',3); if isempty(p1h); p1h =  plot(nan,'ro','MarkerSize',5,'LineWidth',3); end
p1i = plot(x(rfNM),y(rfNM),'ko','MarkerSize',5,'LineWidth',3); if isempty(p1i); p1i =  plot(nan,'ko','MarkerSize',5,'LineWidth',3); end
p1j = plot(x(lbNM),y(lbNM),'r^','MarkerSize',5,'LineWidth',3); if isempty(p1j); p1j =  plot(nan,'r^','MarkerSize',5,'LineWidth',3); end
p1k = plot(x(lfNM),y(lfNM),'k^','MarkerSize',5,'LineWidth',3); if isempty(p1k); p1k =  plot(nan,'k^','MarkerSize',5,'LineWidth',3); end
p1l = plot(x(mbNM),y(mbNM),'rd','MarkerSize',5,'LineWidth',3); if isempty(p1l); p1l =  plot(nan,'rd','MarkerSize',5,'LineWidth',3); end
p1m = plot(x(mmNM),y(mmNM),'bd','MarkerSize',5,'LineWidth',3); if isempty(p1m); p1m =  plot(nan,'bd','MarkerSize',5,'LineWidth',3); end
p1n = plot(x(mfNM),y(mfNM),'kd','MarkerSize',5,'LineWidth',3); if isempty(p1n); p1n =  plot(nan,'kd','MarkerSize',5,'LineWidth',3); end

title('Vilars Proposal')
legend show
lgM = legend([p1h,p1i,p1j,p1k,p1l,p1m,p1n],{['Right Back (',num2str(rbM),')'],['Right Front (',num2str(rfM),')'],...
                                      ['Left Back (',num2str(lbM),')'],['Left Front (',num2str(lfM),')'],...
                                      ['Center Back (',num2str(mbM),')'],['Center Midfield (',num2str(mmM),')'],['Center Front (',num2str(mfM),')']});

title(lgM,['Players (',num2str(size(matx,2)),')'])

export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg')%,'-transparent')
close(f1)

if selections.RecordVideo ==1
    prompt = {'Enter file name:'};
    mkdir([dirsave filesep 'Results' filesep 'Videos'])
    dlgtitle = 'Input title';
    definput = {['Video_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep 'Videos' filesep titfil];
    vidObj = VideoWriter([fname,'.mp4'],'MPEG-4');
    vidObj.Quality = 95;
    vidObj.FrameRate = 10;
    open(vidObj)

f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
campo
hold on
axis off
pause
for i = 1:size(xdata,1)

    K = convhull(xdata(i,:),ydata(i,:));
    p2a(i) = plot(xdata(i,K),ydata(i,K),'K:');
   
%   Finding porcetage
%   Largura (Width)
    p2b(i) = plot([xdata(i,Pminp(i,:)) xdata(i,Pmaxp(i,:))],[ydata(i,Aminp(i,:))+L25(i,1) ydata(i,Aminp(i,:))+L25(i,1)],'LineWidth',1,'Color','k','LineStyle','- -');
    p2c(i) = plot([xdata(i,Pminp(i,:)) xdata(i,Pmaxp(i,:))],[ydata(i,Amaxp(i,:))-L25(i,1) ydata(i,Amaxp(i,:))-L25(i,1)],'LineWidth',1,'Color','k','LineStyle','- -');

%   Comprimento (Length)
%   Lateral
    p2d(i) = plot([xdata(i,Pminp(i,:))+C50(i,1) xdata(i,Pminp(i,:))+C50(i,1)],[ydata(i,Aminp(i,:)) ydata(i,Aminp(i,:))+L25(i,1)],'LineWidth',1,'Color','k','LineStyle','- -');
    p2e(i) = plot([xdata(i,Pminp(i,:))+C50(i,1) xdata(i,Pminp(i,:))+C50(i,1)],[ydata(i,Amaxp(i,:))-L25(i,1) ydata(i,Amaxp(i,:))],'LineWidth',1,'Color','k','LineStyle','- -');

%   Middle
    p2f(i) = plot([xdata(i,Pminp(i,:))+C25(i,1) xdata(i,Pminp(i,:))+C25(i,1)],[ydata(i,Aminp(i,:))+L25(i,1) ydata(i,Amaxp(i,:))-L25(i,1)],'LineWidth',1,'Color','k','LineStyle','- -');
    p2g(i) = plot([xdata(i,Pmaxp(i,:))-C25(i,1) xdata(i,Pmaxp(i,:))-C25(i,1)],[ydata(i,Aminp(i,:))+L25(i,1) ydata(i,Amaxp(i,:))-L25(i,1)],'LineWidth',1,'Color','k','LineStyle','- -');

%%  Counting the number of players
 x = xdata(i,:)';
 y = ydata(i,:)';

%   Right 
rbN = find(xdata(i,Pminp(i,:))+C50(i,1) >= x & y <=  ydata(i,Aminp(i,:))+L25(i,1)); rb(i,1) = size(rbN,1);  % Back
rfN = find(xdata(i,Pminp(i,:))+C50(i,1) <= x & y <=  ydata(i,Aminp(i,:))+L25(i,1)); rf(i,1) = size(rfN,1);  % Front

%  Left
lbN = find(xdata(i,Pminp(i,:))+C50(i,1) >= x & y >=  ydata(i,Amaxp(i,:))-L25(i,1)); lb(i,1) = size(lbN,1);  % Back
lfN = find(xdata(i,Pminp(i,:))+C50(i,1) <= x & y >=  ydata(i,Amaxp(i,:))-L25(i,1)); lf(i,1) = size(lfN,1);  % Front

% Middle
mbN = find(xdata(i,Pminp(i,:)) <= x & x <= xdata(i,Pminp(i,:))+C25(i,1) & y >=  ydata(i,Aminp(i,:))+L25(i,1) & y <=  ydata(i,Amaxp(i,:))-L25(i,1));         mb(i,1) = size(mbN,1); % Back
mmN = find(xdata(i,Pminp(i,:))+C25(i,1)<= x & x <= xdata(i,Pmaxp(i,:))-C25(i,1) & y >=  ydata(i,Aminp(i,:))+L25(i,1) & y <=  ydata(i,Amaxp(i,:))-L25(i,1)); mm(i,1) = size(mmN,1); % Midle
mfN = find(xdata(i,Pmaxp(i,:))-C25(i,1)<= x & y >=  ydata(i,Aminp(i,:))+L25(i,1) & y <=  ydata(i,Aminp(i,:))+L74(i,1));                                     mf(i,1) = size(mfN,1); % Front

p2h = plot(x(rbN),y(rbN),'ro','MarkerSize',5,'LineWidth',3); if isempty(p2h); p2h =  plot(nan,'ro','MarkerSize',5,'LineWidth',3); end
p2i = plot(x(rfN),y(rfN),'ko','MarkerSize',5,'LineWidth',3); if isempty(p2i); p2i =  plot(nan,'ko','MarkerSize',5,'LineWidth',3); end
p2j = plot(x(lbN),y(lbN),'r^','MarkerSize',5,'LineWidth',3); if isempty(p2j); p2j =  plot(nan,'r^','MarkerSize',5,'LineWidth',3); end
p2k = plot(x(lfN),y(lfN),'k^','MarkerSize',5,'LineWidth',3); if isempty(p2k); p2k =  plot(nan,'k^','MarkerSize',5,'LineWidth',3); end
p2l = plot(x(mbN),y(mbN),'rd','MarkerSize',5,'LineWidth',3); if isempty(p2l); p2l =  plot(nan,'rd','MarkerSize',5,'LineWidth',3); end
p2m = plot(x(mmN),y(mmN),'bd','MarkerSize',5,'LineWidth',3); if isempty(p2m); p2m =  plot(nan,'bd','MarkerSize',5,'LineWidth',3); end
p2n = plot(x(mfN),y(mfN),'kd','MarkerSize',5,'LineWidth',3); if isempty(p2n); p2n =  plot(nan,'kd','MarkerSize',5,'LineWidth',3); end

    title('Vilars Proposal')
    lg = legend([p2h,p2i,p2j,p2k,p2l,p2m,p2n],{['Right Back (',num2str(rb(i,1)),' - ',num2str(pRB(i)),'%)'],['Right Front (',num2str(rf(i,1)),' - ',num2str(pRF(i)),'%)'],...
                                          ['Left Back (',num2str(lb(i,1)),' - ',num2str(pLB(i)),'%)'],['Left Front (',num2str(lf(i,1)),' - ',num2str(pLF(i)),'%)'],...
                                          ['Center Back (',num2str(mb(i,1)),' - ',num2str(pMB(i)),'%)'],['Center Midfield (',num2str(mm(i,1)),' - ',num2str(pMM(i)),'%)'],...
                                          ['Center Front (',num2str(mf(i,1)),' - ',num2str(pMF(i)),'%)']});
                                      
    title(lg,['Players (',num2str(size(xdata(i,:),2)),')'])

disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
f(i) = getframe(f1);
writeVideo(vidObj,f(i));

pause(0.05)
    delete(p2a)
    delete(p2b)
    delete(p2c)
    delete(p2d)
    delete(p2e)
    delete(p2f)
    delete(p2g)
    delete(p2h)
    delete(p2i)
    delete(p2j)
    delete(p2k)
    delete(p2l)
    delete(p2m)
    delete(p2n)

end
close(f1)
end

end


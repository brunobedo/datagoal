function [res] = comphorvertteamslines(dataraw)
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
    
%   Separating data
    xdata = dataraw.X; 
    ydata = dataraw.Y;

%   Player's name
    playfull = [selections.PlayersList.Defender;selections.PlayersList.Midfielder;selections.PlayersList.Forwards];
    for p = 1:size(playfull)
        po= strfind(playfull{p},'.');
        players{p,1} = playfull{p}(1:po(end)-1);
        players{p,1} = strrep(players{p},'_','-');
    end

%   Player's name
    playfull = [selections.PlayersList.Defender;selections.PlayersList.Midfielder;selections.PlayersList.Forwards;selections.PlayersList.Opponent];
    for p = 1:size(playfull)
        po= strfind(playfull{p},'.');
        players{p,1} = playfull{p}(1:po(end)-1);
        players{p,1} = strrep(players{p},'_','-');
    end
    %   Team 1
    xdatat1 = dataraw.X;
    ydatat1 = dataraw.Y;
    playt1 = players(1:size(xdata,2));
    %   Team 2
    xdatat2 = dataraw.OpX;
    ydatat2 = dataraw.OpY;
    playt2 = players(size(xdata,2)+1:end);

    %   Mean team position  
    xMeant1 = mean(xdatat1,2);
    yMeant1 = mean(ydatat1,2);

    %   Mean of position of each pleayser 
    xMeanPlayerst1 = mean(xdatat1);
    yMeanPlayerst1 = mean(ydatat1);

    %   Mean team position  
    xMeant2 = mean(xdatat2,2);
    yMeant2 = mean(ydatat2,2);

    %   Mean of position of each pleayser 
    xMeanPlayerst2 = mean(xdatat2);
    yMeanPlayerst2 = mean(ydatat2);

    %   Combining mat
    xdataAll = [xdatat1 xdatat2];
    ydataAll = [ydatat1 ydatat2];

    %%  Calculating Width and length (both teams together)
    for i = 1:size(xdataAll,1)
    %   Width (Largura - Latera/Lateral)
        [Aminv(i,1) Aminp(i,:)] = min(ydataAll(i,:)); 
        [Amaxv(i,1) Amaxp(i,:)] = max(ydataAll(i,:));     

    %   Length (Comprimento - Fundo/Fundo)
        [Pminv(i,1) Pminp(i,:)] = min(xdataAll(i,:)); 
        [Pmaxv(i,1) Pmaxp(i,:)] = max(xdataAll(i,:));
        
    %   Calculating distances
    %   Width
        DistW(i,1) = pdist([xdataAll(i,Aminp(i,:)),ydataAll(i,Aminp(i,:)); xdataAll(i,Amaxp(i,:)),ydataAll(i,Amaxp(i,:))],'euclidean');
    %   Length
        DistL(i,1) = pdist([xdataAll(i,Pminp(i,:)),ydataAll(i,Pminp(i,:)); xdataAll(i,Pmaxp(i,:)),ydataAll(i,Pmaxp(i,:))],'euclidean');

    %   Distance to the goal
        DistGoal1(i,:) = [Pminv(i,1) Pminp(i,:)];
        DistGoal2(i,:) = [110-Pmaxv(i,1) Pmaxp(i,:)];

        K = convhull(xdataAll(i,:),ydataAll(i,:));
        SufArea(i,:) = polyarea(xdataAll(i,K),ydataAll(i,K));

    %%  Calculating Individual playing area 
    %   Rectangle
        IndAreaRec(i,1) = (DistW(i,1)*DistL(i,1))/size(xdataAll,2); 

    %   Polygon
        IndAreaPol(i,1) = SufArea(i,:)/size(xdataAll,2);
    end

    %%  Results 
    res(1,1) = mean(DistW); 
    res(2,1) = median(DistW);
    res(3,1) = std(DistW);

    res(1,2) = mean(DistL); 
    res(2,2) = median(DistL);
    res(3,2) = std(DistL);

    res(1,3) = mean(DistGoal1(:,1));
    res(2,3) = median(DistGoal1(:,1));
    res(3,3) = std(DistGoal1(:,1));

    res(1,4) = mean(DistGoal2(:,1));
    res(2,4) = median(DistGoal2(:,1));
    res(3,4) = std(DistGoal2(:,1));

    res(1,5) = mean(IndAreaRec); 
    res(2,5) = median(IndAreaRec); 
    res(3,5) = std(IndAreaRec); 

    res(1,6) = mean(IndAreaPol); 
    res(2,6) = median(IndAreaPol); 
    res(3,6) = std(IndAreaPol); 
%%  Saving results
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];

    titvar1 = {'Team 1','Team 2',' ','Width','Length','Distance Goal 1','Distance Goal 2','Individual playing area(Rectangle)','Individual playing area(Polygon)'};
    titvar2 = {'Mean';'Median';'STD'};

    xlswrite(fname,titvar1,1,'A1')
    xlswrite(fname,titvar2,1,'C2')
    xlswrite(fname,playt1,1,'A2')
    xlswrite(fname,playt2,1,'B2')
    xlswrite(fname,res,1,'D2')

    %   Sheet's name
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp(1:30));
    ewb.Save 
    ewb.Close(false)

    %%  Creating and saving figure
    f1 = figure(1); clf; set(f1,'name','Sectors distance','units','normalized','outerposition',[0 0 1 1])
    campo
    %     axis off
    titsavef1 = ['Field_',selections.ColLinTyp];   
    matx = [xMeanPlayerst1 xMeanPlayerst2];
    maty = [yMeanPlayerst1 yMeanPlayerst2];

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

    %   Distance to the goal
    DistGoal1M = [PminvM PminpM];
    DistGoal2M = [110-PmaxvM PmaxpM];

    K = convhull(matx,maty);
    SufAreaM = polyarea(matx(1,K),maty(1,K));

    %%  Calculating Individual playing area 
    %   Rectangle
    IndAreaRecM = (DistWM*DistLM)/size(matx,2); 

    %   Polygon
    IndAreaPolM = SufAreaM/size(matx,2);

    %   Player's name
    playfull = [selections.PlayersList.Defender;selections.PlayersList.Midfielder;selections.PlayersList.Forwards];
    for p = 1:size(playfull)
        po= strfind(playfull{p},'.');
        players{p,1} = playfull{p}(1:po(end)-1);
        players{p,1} = strrep(players{p},'_','-');
    end
        
    p1 = plot(xMeanPlayerst1,yMeanPlayerst1,'or','MarkerSize',5,'LineWidth',3);
    p2 = plot(xMeanPlayerst2,yMeanPlayerst2,'ob','MarkerSize',5,'LineWidth',3);

    l1 = plot([matx(1,PminpM) matx(1,PmaxpM)],[maty(1,AminpM) maty(1,AminpM)],'LineWidth',1,'Color','k','LineStyle','- -');
    l2 = plot([matx(1,PmaxpM) matx(1,PmaxpM)],[maty(1,AminpM) maty(1,AmaxpM)],'LineWidth',1,'Color','k','LineStyle','- -');
    l3 = plot([matx(1,PminpM) matx(1,PmaxpM)],[maty(1,AmaxpM) maty(1,AmaxpM)],'LineWidth',1,'Color','k','LineStyle','- -');
    l4 = plot([matx(1,PminpM) matx(1,PminpM)],[maty(1,AminpM) maty(1,AmaxpM)],'LineWidth',1,'Color','k','LineStyle','- -');

    l1g = plot([0 matx(1,PminpM)]  ,[maty(1,PminpM) maty(1,PminpM)],'LineWidth',1,'Color','k','LineStyle',':');
    l2g = plot([matx(1,PmaxpM) 110],[maty(1,PmaxpM) maty(1,PmaxpM)],'LineWidth',1,'Color','k','LineStyle',':');
    t1g = text(matx(1,PminpM),maty(1,PminpM)+2,num2str(round(DistGoal1M(1),1)));
    t2g = text(matx(1,PmaxpM),maty(1,PmaxpM)+2,num2str(round(DistGoal2M(1),1)));
        
    legend([p1,p2,l1,l1g,l2g],'Team 1','Team 2','IPA','Dist. goal 1','Dist goal 2')
    
    title({'Individual Playing Area (IPA) ';['Mean: ', num2str(round(mean(IndAreaRec),2)),' m^2'];...
        ['Median: ' , num2str(round(median(IndAreaRec),2)),' m^2']})
    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg','-transparent')
    close (f1)

    %%  Creating a video file
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
        % axis off
        % pause
        for i = 1:size(xdata,1)
            
        p2a(i) = plot(xdatat1(i,:),ydatat1(i,:),'or','MarkerSize',5,'LineWidth',3);
        p2b(i) = plot(xdatat2(i,:),ydatat2(i,:),'ob','MarkerSize',5,'LineWidth',3);
        
        p2c(i) = plot([xdataAll(i,Pminp(i,:)) xdataAll(i,Pmaxp(i,:))],[ydataAll(i,Aminp(i,:)) ydataAll(i,Aminp(i,:))],'LineWidth',1,'Color','k','LineStyle','- -');
        p2d(i) = plot([xdataAll(i,Pmaxp(i,:)) xdataAll(i,Pmaxp(i,:))],[ydataAll(i,Aminp(i,:)) ydataAll(i,Amaxp(i,:))],'LineWidth',1,'Color','k','LineStyle','- -');
        p2e(i) = plot([xdataAll(i,Pminp(i,:)) xdataAll(i,Pmaxp(i,:))],[ydataAll(i,Amaxp(i,:)) ydataAll(i,Amaxp(i,:))],'LineWidth',1,'Color','k','LineStyle','- -');
        p2f(i) = plot([xdataAll(i,Pminp(i,:)) xdataAll(i,Pminp(i,:))],[ydataAll(i,Aminp(i,:)) ydataAll(i,Amaxp(i,:))],'LineWidth',1,'Color','k','LineStyle','- -');
            
        lg1(i) = plot([0 xdataAll(i,Pminp(i,:))]  ,[ydataAll(i,Pminp(i,:)) ydataAll(i,Pminp(i,:))],'LineWidth',1,'Color','k','LineStyle',':');
        lg2(i) = plot([xdataAll(i,Pmaxp(i,:)) 110],[ydataAll(i,Pmaxp(i,:)) ydataAll(i,Pmaxp(i,:))],'LineWidth',1,'Color','k','LineStyle',':');
        tg1(i) = text(xdataAll(i,Pminp(i,:)),ydataAll(i,Pminp(i,:))+2,num2str(round(DistGoal1(i,1),1)));
        tg2(i) = text(xdataAll(i,Pmaxp(i,:)),ydataAll(i,Pmaxp(i,:))+2,num2str(round(DistGoal2(i,1),1)));
        
        legend([p2a(i),p2b(i),p2c(i),lg1(i),lg2(i)],'Team 1','Team 2','IPA','Dist. goal 1','Dist goal 2')
        title({'Individual Playing Area (IPA) ';['Rectangle: ', num2str(round(IndAreaRec(i,1),2)),' m^2'];...
                ['Polygon: ' , num2str(round(IndAreaPol(i,1),2)),' m^2']})

        disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
        f(i) = getframe(f1);
        writeVideo(vidObj,f(i));
        
        pause(0.2)
        delete(p2a(i))
        delete(p2b(i))
        delete(p2c(i))
        delete(p2d(i))
        delete(p2e(i))
        delete(p2f(i))
        delete(lg1(i))
        delete(lg2(i))
        delete(tg1(i))
        delete(tg2(i))
    
        end
    close(f1)
    end
end


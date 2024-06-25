function [res] = DistOpponentOfCentroid(dataraw)
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
    %   Separating teams
    [list1,tf1] = listdlg('PromptString','Please select the team 1:','SelectionMode','Muntiple','ListString',players,'Name','Team 1');
    [list2,tf2] = listdlg('PromptString','Please select the team 2:','SelectionMode','Muntiple','ListString',players,'Name','Team 1');
    %   Team 1
    xdatat1 = xdata(:,list1); 
    ydatat1 = ydata(:,list1);
    playt1 = players(list1);
    %   Team 2
    xdatat2 = xdata(:,list2); 
    ydatat2 = ydata(:,list2);
    playt2 = players(list2);

    %%
    %   Team 1 
    %   Mean of position of each pleayser 
    PlayersMeanXt1 = mean(xdatat1,1);
    PlayersMeanYt1 = mean(ydatat1,1);
    
    %   Team Mean 
    teamMeanXt1 = mean(PlayersMeanXt1);
    teamMeanYt1 = mean(PlayersMeanYt1);
    
    %   Median of position of each pleayser
    PlayersMedianXt1 = median(xdatat1,1);
    PlayersMedianYt1 = median(ydatat1,1);

    %   Team Mean 
    teamMedianXt1 = median(PlayersMedianXt1);
    teamMedianYt1 = median(PlayersMedianYt1);   

    %   Team mean vector
    TMeanXt1 = mean(xdatat1,2); 
    TMeanYt1 = mean(ydatat1,2);
    TMeant1 = [TMeanXt1 TMeanYt1];

    %   Team median vector
    TMedianXt1 = median(xdatat1,2); 
    TMedianYt1 = median(ydatat1,2);
    TMediant1 = [TMedianXt1 TMedianYt1];

    %   Team 2 
    %   Mean of position of each pleayser 
    PlayersMeanXt2 = mean(xdatat2,1);
    PlayersMeanYt2 = mean(ydatat2,1);
    
    %   Team Mean 
    teamMeanXt2 = mean(PlayersMeanXt2);
    teamMeanYt2 = mean(PlayersMeanYt2);
    
    %   Median of position of each pleayser
    PlayersMedianXt2 = median(xdatat2,1);
    PlayersMedianYt2 = median(ydatat2,1);
    %   Team Mean 
    teamMedianXt2 = median(PlayersMedianXt2);
    teamMedianyt2 = median(PlayersMedianYt2);   

    %   Team mean vector
    TMeanXt2 = mean(xdatat2,2); 
    TMeanYt2 = mean(ydatat2,2);
    TMeant2 = [TMeanXt2 TMeanYt2];

    %   Team median vector
    TMedianXt2 = median(xdatat2,2); 
    TMedianYt2 = median(ydatat2,2);
    TMediant2 = [TMedianXt2 TMedianYt2];

    %%
    %   Calculating the Distance
    for i = 1:size(xdatat1,1)
    %   t2 
        for w = 1:size(xdatat2,2)
            distTotal_T1toT2(i,w) = pdist([TMeanXt1(i) TMeanYt1(i);xdatat2(i,w) ydatat2(i,w)],'euclidean');
        end
        for w = 1:size(xdatat1,2)
            distTotal_T2toT1(i,w) = pdist([TMeanXt2(i) TMeanYt2(i);xdatat1(i,w) ydatat1(i,w)],'euclidean');
        end
        [TS_T1toT2(i,1),pos_TS_T1toT2(i,1)] = min(distTotal_T1toT2(i,:));
        [TS_T2toT1(i,1),pos_TS_T2toT1(i,1)] = min(distTotal_T2toT1(i,:));
    end

    TS_Mean_T1toT2 = mean(TS_T1toT2);
    TS_Median_T1toT2 = median(TS_T1toT2); 
    TS_STD_T1toT2 = std(TS_T1toT2); 

    TS_Mean_T2toT1 = mean(TS_T2toT1);
    TS_Median_T2toT1 = median(TS_T2toT1); 
    TS_STD_T2toT1 = std(TS_T2toT1); 

    res = [TS_Mean_T1toT2 TS_Median_T1toT2 TS_STD_T1toT2 TS_Mean_T2toT1 TS_Median_T2toT1 TS_STD_T2toT1];

    %%  
    %   Saving results 
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];

    tit1 = {'Team 1','Team 2','TS - T1 to T2',' ',' ','TS - T2 to T1'};
    tit2 = {'TS-Mean (m)', 'TS-Median (m)', 'TS-STD (m)','TS-Mean (m)', 'TS-Median (m)', 'TS-STD (m)'};   
    
    xlswrite(fname,playt1,1,'A2')
    xlswrite(fname,playt2,1,'B2')
    xlswrite(fname,tit1,1,'A1')
    xlswrite(fname,tit2,1,'C2')
    xlswrite(fname,res,1,'C3')
    %   Sheet's name
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp(1:end));
    ewb.Save 
    ewb.Close(false)

    %%  Creating and saving figure
    %   Figure 1 (field)
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    campo
    hold on
    axis off;
    
    %   Team 1
    p1a = plot(PlayersMeanXt1,PlayersMeanYt1,'ob','MarkerSize',5,'LineWidth',5);
    p1b = plot(teamMeanXt1,teamMeanYt1,'^b','MarkerSize',5,'LineWidth',5);
    conv1 = convhull(PlayersMeanXt1,PlayersMeanYt1);
    p1c = plot(PlayersMeanXt1(conv1),PlayersMeanYt1(conv1),'-b');

    %   Team 2
    p2a = plot(PlayersMeanXt2,PlayersMeanYt2,'or','MarkerSize',5,'LineWidth',5);
    p2b = plot(teamMeanXt2,teamMeanYt2,'^r','MarkerSize',5,'LineWidth',5);
    conv2 = convhull(PlayersMeanXt2,PlayersMeanYt2);
    p2c = plot(PlayersMeanXt2(conv2),PlayersMeanYt2(conv2),'-r');

    %   Calculating Distance to plot it
    matMeant1 = [PlayersMeanXt1' PlayersMeanYt1']; 
    matMeant2 = [PlayersMeanXt2' PlayersMeanYt2'];
    
    for h = 1:size(matMeant2,1)
        distMean_T1toT2(h,1) = pdist([teamMeanXt1 teamMeanYt1;matMeant2(h,1) matMeant2(h,2)],'euclidean');
    end
    for h = 1:size(matMeant1,1)
        distMean_T2toT1(h,1) = pdist([teamMeanXt2 teamMeanYt2;matMeant1(h,1) matMeant1(h,2)],'euclidean');
    end

    [minMean_T1toT2,pminT1T2] = min(distMean_T1toT2);
    [minMean_T2toT1,pminT2T1] = min(distMean_T2toT1);
    
    p3a = plot([teamMeanXt1 matMeant2(pminT1T2,1)],[teamMeanYt1 matMeant2(pminT1T2,2)],'--k');
    p3b = plot([teamMeanXt2 matMeant1(pminT2T1,1)],[teamMeanYt2 matMeant1(pminT2T1,2)],':k');

    legend([p1a, p1b, p2a, p2b, p3a, p3b],'Team 1','Team 1 Mean','Team 2','Team 2 Mean','TS - Team 1','TS - Team 2')
    title({'Distance';['Team 1: ',num2str(minMean_T1toT2),' m'];...
        ['Team 2: ',num2str(minMean_T2toT1),' m']})
    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg','-transparent')
    close(f1)

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
        axis off

        for i = 1:size(xdatat1,1)
            %   Team 1
            convt1 = convhull(xdatat1(i,:),ydatat1(i,:));
            polyint1(i,:) = polyshape({xdatat1(i,convt1)},{ydatat1(i,convt1)});
            [polxt1(i,:),polyt1(i,:)] = centroid(polyint1(i,:));
            [xt1,yt1] = centroid(polyint1(i,:));

            p1t1(i) = plot(xdatat1(i,:),ydatat1(i,:),'ob','MarkerSize',5,'LineWidth',3);
            p2t1(i) = plot(xdatat1(i,convt1),ydatat1(i,convt1),'b-');
            p3t1(i) = plot(xt1,yt1,'b^','MarkerSize',5,'LineWidth',3);

            %   Team 2
            convt2 = convhull(xdatat2(i,:),ydatat2(i,:));
            polyint2(i,:) = polyshape({xdatat2(i,convt2)},{ydatat2(i,convt2)});
            [polxt2(i,:),polyt2(i,:)] = centroid(polyint2(i,:));
            [xt2,yt2] = centroid(polyint2(i,:));

            p1t2(i) = plot(xdatat2(i,:),ydatat2(i,:),'or','MarkerSize',5,'LineWidth',3);
            p2t2(i) = plot(xdatat2(i,convt2),ydatat2(i,convt2),'r-');
            p3t2(i) = plot(xt2,yt2,'r^','MarkerSize',5,'LineWidth',3);
            
            pts1(i) = plot([xt1 xdatat2(i,pos_TS_T1toT2(i))],[yt1 ydatat2(i,pos_TS_T1toT2(i))],'--k');
            pts2(i) = plot([xt2 xdatat1(i,pos_TS_T2toT1(i))],[yt2 ydatat1(i,pos_TS_T2toT1(i))],':k');

            title({'Distance';['Team 1: ',num2str(TS_T1toT2(i)),' m'];...
                ['Team 2: ',num2str(TS_T2toT1(i)),' m']})
            
            legend([p1t1(i),p1t2(i),p3t1(i),p3t2(i),pts1(i),pts2(i)],'Team 1','Team 2','Team 1 centroid','Team 2 centroid','TS - Team 1','TS - Team 2');

            disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
            f(i) = getframe(f1);
            writeVideo(vidObj,f(i));

            pause(0.2)
            delete(p1t1(i))
            delete(p1t2(i))
            delete(p2t1(i))
            delete(p2t2(i))
            delete(p3t1(i))
            delete(p3t2(i))
            delete(pts1(i))
            delete(pts2(i))
        end
    close(f1)
    end
end



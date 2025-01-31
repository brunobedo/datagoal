function [res4] = spatial_exploration_index(dataraw)
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

%   Calculates the Spatial Exploration Index based in: 
%   Gon.alves B, Esteves P, Folgado H, Ric A, Torrents C, Sampaio J. 
%   Effects of pitch area-restrictions on tactical behavior, physical, and physiological 
%   performances in soccer large-sided games. J Strength Cond Res. 2017;31(9):2398ï¿½408.
%   Author: Bruno Luiz de Souza Bedo 

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

    %%  Time Vector 
    vtemp = [(0:size(xdata,1)-1)/str2double(selections.FreqAc)]'; 
    vtempm = vtemp./60;

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

    %%  Calculating Spatial Exploration Index
    matPMean = [PlayersMeanX' PlayersMeanY'];
    for p = 1:size(matPMean,1)
        for i = 1:size(xdata,1)
            SEI(i,p) = pdist([matPMean(p,1) ydata(i,p);xdata(i,p) matPMean(p,2)],'euclidean');
        end
    end
    SEI_P_mean = mean(SEI); 
    SEI_P_median = median(SEI);
    SEI_P_std = std(SEI);
    
    SEI_P_full = SEI;
    
    SEI_T_mean = mean(SEI_P_mean);
    SEI_T_median = median(SEI_P_median);
    SEI_T_std = std(SEI_P_std);
    
    %%  Saving results
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Individual_SEI_']};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    
    tit1 = {'Players','Mean','Median','STD','Team values'};
    tit2 = {'Mean';'Median';'STD'};
    tit3 = {'time'};
    tit4 = players';
    
    res1 = players;
    res2 = [SEI_P_mean' SEI_P_median' SEI_P_std'];
    res3 = [SEI_T_mean SEI_T_median SEI_T_std]';
    res4 = [vtempm, SEI_P_full];
    
    xlswrite(fname,tit1,1,'A1')
    xlswrite(fname,tit2,1,'E2')
    xlswrite(fname,tit3,1,'G1')
    xlswrite(fname,tit4,1,'H1')
    xlswrite(fname,res1,1,'A2')
    xlswrite(fname,res2,1,'B2')
    xlswrite(fname,res3,1,'F2')
    xlswrite(fname,res4,1,'G2')

    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = 'SEI';
    ewb.Save 
    ewb.Close(false)

    %%  Creating and saving figure
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1)
    campo
    hold on
    set(gca,'XTick',[], 'YTick', [],'XColor','none','YColor','none')
    for i = 1:size(PlayersMeanX,2)
        p1(1) = plot(PlayersMeanX(i),PlayersMeanY(i),'or','MarkerSize',5,'LineWidth',3);
        t1(1) = text(PlayersMeanX(i)+2,PlayersMeanY(i)+2,num2str(SEI_P_mean(i)));
    end
    legend(p1(1),'Players')
    title({'Spatial Exploration Index';['Mean: ', num2str(SEI_T_mean),' m'];...
            ['Median: ', num2str(SEI_T_median),' m']})
    subplot(1,2,2);
    y = categorical(players'); 
    x = [SEI_P_mean];
    barh(y,x,'k')
    xlabel('Meters')
    title('Spatial Exploration Index')
    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg') %'-transparent'
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
        pause
        p1 = plot(PlayersMeanX,PlayersMeanY,'or','MarkerSize',5,'LineWidth',3);

        for i = 1:size(xdata,1)
            for p = 1:size(PlayersMeanX,2)
                p2(i,p) = plot(xdata(i,p),ydata(i,p),'ob','MarkerSize',5,'LineWidth',3);
                p3(i,p) = plot([xdata(i,p) PlayersMeanX(1,p)],[ydata(i,p) PlayersMeanY(1,p)],'LineWidth',1.5,'Color','k','LineStyle',':');       
                t1(i,p) = text(xdata(i,p)+2,ydata(i,p)+2,num2str(round(SEI(i,p),1))); 
            end
            
            legend([p1,p2(i,p),p3(i,p)],'Mean position','Current position','Indivisual SEI')
            title({'Spatial Exploration Index (SEI)';['Mean: ', num2str(round(mean(SEI(i,:)),1)),' m'];...
                ['Median: ',num2str(round(median(SEI(i,:)),1)),' m']})

            disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
            f(i) = getframe(f1);
            writeVideo(vidObj,f(i))
            
            pause(0.25)
            delete(p2)
            delete(p3)
            delete(t1)
        end
    close(f1)
    end
end


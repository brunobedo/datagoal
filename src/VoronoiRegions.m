function [res1] = voronoiregions(dataraw)
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
%   Calculating the Voronoi Regions
    h1 =  waitbar(0,'Calculating the Voronoi Regions');
    set(h1,'name','Voronoi Regions')
for w = 1:size(xdata,1)
    waitbar(w/size(xdata,1))
    x = [xdata(w,:)];
    y = [ydata(w,:)]; 
    [v,c] = voronoilimit(x',y','bs_ext',[0 0 110 110; 0 75 75 0]','figure','off');
    for i = 1:size(c,1)
        v1 = v(c{i},1); 
        v2 = v(c{i},2);
        A(w,i) = polyarea(v1,v2) ;    
    end
end
close(h1)

%%  Saving results
%   Results
    VR_mean_P = mean(A);
    VR_median_P = median(A);
    VR_STD_P = std(A);

    VR_mean_T = mean(VR_mean_P);
    VR_median_T = median(VR_median_P);
    VR_STD_T = std(VR_STD_P);

res1 = [VR_mean_P' VR_median_P' VR_STD_P']; 
res2 = [VR_mean_T VR_median_T VR_STD_T]';
t1 = {'Players','Mean','Median','STD'}; 
t2 = {'Team','Mean','Median','STD'}';
t3 = players;

%   Saving 
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];

    xlswrite(fname,t1,1,'A1')
    xlswrite(fname,t2,1,'E1')
    xlswrite(fname,t3,1,'A2')
    xlswrite(fname,res1,1,'B2')
    xlswrite(fname,res2,1,'F2')

    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp);
    ewb.Save 
    ewb.Close(false)

%%  Creating and saving figure
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    p1 = voronoi(PlayersMeanX,PlayersMeanY,'k--'); 
    hold on
    campo
%     axis off
    p2 = plot(PlayersMeanX,PlayersMeanY,'or','MarkerSize',5,'LineWidth',3);
    for i = 1:size(VR_mean_P,2)
    t1 = text(PlayersMeanX(i)+1,PlayersMeanY(i)+1,num2str(VR_mean_P(i)));
    end
    title({'Voronoi Regions (VR)';['Mean: ', num2str(round(VR_mean_T)),' m^2'];...
          ['Median: ',num2str(round(median(VR_median_T))),' m^2']})
    legend([p1(end),p2(1)],'Voronoi Regions','Players')

    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg')%,'-transparent')
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
for i = 1:size(xdata,1) 
    x = xdata(i,:);
    y = ydata(i,:); 
    p1 = voronoi(xdata(i,:),ydata(i,:),'k--'); 
    p2 = plot(xdata(i,:),ydata(i,:),'or','MarkerSize',5,'LineWidth',3);
for w = 1:size(x,2)
    t1(w) = text(xdata(i,w)+1,ydata(i,w)+1,num2str(A(i,w)));
end
    title({'Voronoi Regions (VR)';['Median: ',num2str(round(median(A(i,:)),1)),' m^2']})

    legend([p1(end),p2(1)],'Voronoi Regions','Players')

disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
f(i) = getframe(f1);
writeVideo(vidObj,f(i));

pause(0.2)
delete(p1)
delete(p2)
delete(t1)
end
close(f1)
end
end


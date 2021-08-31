function [res2] = TeamStretchIndex(dataraw)
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
%   Calculates the Stretch index

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
%   Calculating the Stretch Index
for i = 1:size(TMean,1)
    
    linX = xdata(i,:); 
    linY = ydata(i,:); 
    lin = [linX' linY']; 
    
%   Stretch Index
    for w = 1:size(lin,1)
        TotalSI(i,w) = pdist([lin(w,:);TMean(i,:)]);
    end
end
%   Players' mean and median Stretch Index
    PMeanSI = mean(TotalSI,1);
    PMedianSI = median(TotalSI,1);

%   Team's mean and median Stretch Index
    TMeanSI = mean(TotalSI,2);
    TMedianSI = median(TotalSI,2);
    TMeanSI = mean(PMeanSI); 
    TMedianSI = median(PMedianSI); 

%%  Saving results
%   Results
    res1 = [PMeanSI' PMedianSI'];
    res2 = [TMeanSI TMedianSI];
    t1 = {'Players','Mean','Median','Team Mean','Team Median'};
    t2 = players; 

%   Saving 
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];

    xlswrite(fname,t1,1,'A1')
    xlswrite(fname,t2,1,'A2')
    xlswrite(fname,res1,1,'B2')
    xlswrite(fname,res2,1,'D2')

    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp);
    ewb.Save 
    ewb.Close(false)

%%  Creating and saving figure
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    campo
    hold on
%     axis off
    p1 = plot(PlayersMeanX,PlayersMeanY,'or','MarkerSize',5,'LineWidth',3);
    p2 = plot(teamMeanX,teamMeanY,'^b','MarkerSize',5,'LineWidth',3);
    conv = convhull(PlayersMeanX,PlayersMeanY);
    p3 = plot(PlayersMeanX(conv),PlayersMeanY(conv),'-k');

%   Calculating SI in the mean position values 
    mt = [PlayersMeanX' PlayersMeanY'];
   
    for z = 1:size(mt,1)
        Tmean2(z,:) = pdist([mt(z,:);[teamMeanX,teamMeanY]]);
        p4{z} = plot([mt(z,1) teamMeanX],[ mt(z,2) teamMeanY],'--k');
    end
    text(PlayersMeanX+0.7,PlayersMeanY,num2str(Tmean2))
    title({'Stretch Index';['Mean: ',num2str(TMeanSI),' m'];...
           ['Median: ',num2str(TMedianSI),' m']})

    legend([p1,p2],'Players','Team mean')
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
axis off
pause
% pause
for i = 1:size(xdata,1)
    p2a = plot(xdata(i,:),ydata(i,:),'ro','MarkerSize',5,'LineWidth',3);
    p2b = plot(TMean(i,1),TMean(i,2),'^b','MarkerSize',5,'LineWidth',3);
    conv1 = convhull(xdata(i,:),ydata(i,:));
    p2c = plot(xdata(i,conv1),ydata(i,conv1),'-k');
    
    lin = [xdata(i,:)',ydata(i,:)'];
    
    for w = 1:size(lin,1)
    p2d(w) = plot([lin(w,1),TMean(i,1)],[lin(w,2),TMean(i,2)],'--k');
    t(i,w) = text(xdata(i,w)+0.7,ydata(i,w),num2str(TotalSI(i,w)));
    end

    legend([p2a, p2b, p2d(w)],'PLayers','Team Mean','Players'' SI')
    title({'Stretch Index';['Mean: ',num2str(mean(TotalSI(i,:))),' m'];...
           ['Median: ',num2str(num2str(median(TotalSI(i,:)))),' m']})

disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
f(i) = getframe(f1);
writeVideo(vidObj,f(i));

pause(0.25)
delete(p2a)
delete(p2b)
delete(p2c)
delete(p2d)
delete(t)

end
close(f1)
end
end



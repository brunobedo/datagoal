function [res1] = team_effective_area(dataraw)
%   Calculates the area o the team 
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
global selections 
    dirsave = selections.Gamedir;
    mkdir([dirsave filesep 'Results'])
    
%%   Separating data
    xdata = dataraw.X; 
    ydata = dataraw.Y;

%   Mean of position of each pleayser 
    PlayersMeanX = mean(xdata,1);
    PlayersMeanY = mean(ydata,1);
%   Team Mean 
    teamMeanX = mean(PlayersMeanX);
    teamMeany = mean(PlayersMeanY);
    
%   Median of position of each pleayser
    PlayersMedianX = median(xdata,1);
    PlayersMedianY = median(ydata,1);
%   Team Mean 
    teamMedianX = median(PlayersMedianX);
    teamMediany = median(PlayersMedianY);

%%
%   Time Vector
    vtime = [(0:size(xdata,1)-1)/str2double(selections.FreqAc)]'; 
    vtime = vtime./60; 

%%  Calculating Area  
for i = 1:size(xdata,1)
    K = convhull(xdata(i,:),ydata(i,:));
    
    SufArea(i,:) = polyarea(xdata(i,K),ydata(i,K));
end
    Area_Mean = mean(SufArea); 
    Area_Median = median(SufArea); 
    Area_STD = std(SufArea); 

   
%%  Saving results 
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    
    res1 = [Area_Mean Area_Median Area_STD];
    res2 = [vtime, SufArea];
    
    tit = {'mean area (m^2)','median area(m^2)','standard deviation area(m^2)','time','area'};
    xlswrite(fname,tit,1,'A1')
    xlswrite(fname,res1,1,'A2')
    xlswrite(fname,res2,1,'D2')
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp);
    ewb.Save 
    ewb.Close(false)
    
%%  Creating and saving figure
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Sectors distance','units','normalized','outerposition',[0 0 1 1])
    campo

%   Player's name
    playfull = [selections.PlayersList.Defender;selections.PlayersList.Midfielder;selections.PlayersList.Forwards];
    for p = 1:size(playfull)
        po= strfind(playfull{p},'.');
        players{p,1} = playfull{p}(1:po(end)-1);
        players{p,1} = strrep(players{p},'_','-');
    end
    
    text(PlayersMeanX+0.7,PlayersMeanY,players,'FontWeight','bold','FontSize',12);
    p1 = plot(PlayersMeanX,PlayersMeanY,'or','MarkerSize',5,'LineWidth',3);
    p2 = plot(teamMeanX,teamMeany,'^r','MarkerSize',5,'LineWidth',3);
    conv = convhull(PlayersMeanX,PlayersMeanY);
    p3 = plot(PlayersMeanX(conv),PlayersMeanY(conv),'-k','LineWidth',1.5);
    legend ([p1,p2,p3],'Players','Centroid','Mean Area')
    title(['Area: ',num2str(Area_Mean),'m^2']); 
    set(gca,'XColor', 'none','YColor','none')
    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg')   %,'-transparent'
    
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
% pause
for i = 1:size(xdata)
   
    x_eq = xdata(i,:);
    y_eq = ydata(i,:);
    
    conv = convhull(x_eq,y_eq);
    polyin = polyshape({xdata(i,conv)},{ydata(i,conv)});
    
    % retorna a área de superfície (surface area)em m² a cada quadro de imagem
    surface_area(i,:) = polyarea(xdata(i,conv),ydata(i,conv));

    p1(i) = plot(xdata(i,:),ydata(i,:),'or','MarkerSize',5,'LineWidth',3);
    hold on
    p2(i) = plot(xdata(i,conv),ydata(i,conv),'b-');
    t = text(xdata(i,:)+0.7,ydata(i,:),players,'FontWeight','bold','FontSize',12);
    [x,y] = centroid(polyin);
    p3(i) = plot(x,y,'b*','MarkerSize',5,'LineWidth',3);
    title(['Area: ',num2str(surface_area(i,:)),'m^2'])
    legend([p1(i),p3(i)],'Players','Centroid')

    disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
    f(i) = getframe(f1);
    writeVideo(vidObj,f(i));

    pause(0.2)
    delete(p1(i))
    delete(p2(i))
    delete(p3(i))
    delete(t)
end    
close(f1)
end 
end


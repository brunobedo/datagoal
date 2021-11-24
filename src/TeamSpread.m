function [res] = TeamSpread(dataraw)
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> %   Calculates the Team Spread
%   Team spread was defined as the Frobenius norm of the distance between-player matrix

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
%   Calculating the Team Spread
for w = 1:size(xdata,2)
    matXYPlay = [xdata(:,w) ydata(:,w)]; 
   
    for z = 1:size(xdata,2)
        matcomp = [xdata(:,z) ydata(:,z)]; 
        
        s = matXYPlay - matcomp; 
        sq = s.^2;
        sqsum = sq(:,1)+sq(:,2);
    if      z < w
            dres(:,z) = sqrt(sqsum);
    elseif  z > w
            dres(:,z-1) = sqrt(sqsum);
    end
    end
    eval(['d.P',num2str(w),' = dres;']);     
end
    mats = numel(fieldnames(d));
    nc = size(dres,2);
for k = 1:mats
    linI = ((k*nc)-nc)+1; 
    linF = (k*mats)-k;
    eval(['L(:,',num2str(linI),':',num2str(linF),') = d.P',num2str(k),';'])  
end

%  Calculating norm of Frobenius frame by frame
for i = 1:size(L,1)
    spread(i,:) = norm(L(i,:),'fro');
end
spread_mean = mean(spread);
spread_median = median(spread);
std_spread = std(spread);

res(1,1) = spread_mean;
res(1,2) = spread_median;
res(1,3) = std_spread;

%%  Saving results
    tit = {'Team Spread (Mean)','Team Spread (Median)','Team Spread (STD)'};
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    xlswrite(fname,tit,1,'A1')
    xlswrite(fname,res,1,'A2')
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp(1:end));
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

%   Plotting lines
    mat = [PlayersMeanX' PlayersMeanY'];
    
    for i = 1:size(mat,1)
        for w = 1:size(mat,1)
            p3 = plot([mat(i,1) mat(w,1)],[mat(i,2) mat(w,2)],'LineWidth',0.5,'Color','k','LineStyle','- -');
        end
    end
    title({'Team Spread:';['Mean: ', num2str(spread_mean),' m^2'];...
          ['Median: ', num2str(spread_median),' m^2']})
    legend([p1,p2,p3],'Players','Team mean position','Team Spread')
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
    pA = plot(xdata(i,:),ydata(i,:),'ro','MarkerSize',5,'LineWidth',3);
    pB = plot(TMean(i,1),TMean(i,2),'^b','MarkerSize',5,'LineWidth',3);
    
    mat = [xdata(i,:)',ydata(i,:)'];
    
    for z = 1:size(mat,1)
        for w = 1:size(mat,1)
            pC(z,w) = plot([mat(z,1) mat(w,1)],[mat(z,2) mat(w,2)],'LineWidth',0.5,'Color','k','LineStyle',':');
        end
    end

    legend([pA(1,1),pB(1,1),pC(1,1)],'Players','Team Mean','Team Spread')
    title({'Team Spread';[num2str(spread(i)),' m']})

disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
f(i) = getframe(f1);
writeVideo(vidObj,f(i));

pause(0.25)
delete(pA)
delete(pB)
delete(pC)

end
close(f1)
end

end


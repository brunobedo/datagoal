function [res1] = VoronoiRegions(dataraw)
%   Calculates the Voronoi Regions
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
    [v,c] = VoronoiLimit(x',y','bs_ext',[0 0 110 110; 0 75 75 0]','figure','off');
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
axis off
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


function[]=campo(tam)
% campo
%
% Rotina criada por Preto (Paulo R. P. Santiago)
% 08/02/05 ultima atualizaçao  
%
% Cria um grafico com o campo de futebol
% Digite o nome da rotina "campo" na janela de comando

if nargin==0,tam=[110 75];end

%
%

% figure

% whitebg([0 .7 0]);
% set(gcf,'Color','white')
% colordef('white')

comp=tam(1);larg=tam(2);


% cor do campo

% line([comp/2 comp/2],[-5 larg+5],'LineWidth',1000,'Color',[0 .7 .0])
% hold on;
axis([0 comp 0 larg]);
% line([comp/2 comp/2],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0])
% 
% line([comp/10 comp/10],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0])
% line([comp-10 comp-10],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0])

% line([comp/4 comp/4],[-5 larg+5],'LineWidth',500,'Color',[0 .7 .0])
% hold on;
% axis([-5 comp+5 -5 larg+5]);
% line([comp/2 comp/2],[-5 larg+5],'LineWidth',200,'Color',[0 .5 .0]) %Verde escuro
% line([comp/10 comp/10],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0]) %verde escuro
% line([comp-10 comp-10],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0])%verde escuro
% 

%linha central
line([comp/2 comp/2],[0 larg],'Color','k','LineWidth',2.5)
hold on
%linhas fundo
line([0 0],[0 larg],'Color','k','LineWidth',2.5)
line([comp comp],[0 larg],'Color','k','LineWidth',2.5)


%linhas laterais
line([0 comp],[0 0],'Color','k','LineWidth',2.5)
line([0 comp],[larg larg],'Color','k','LineWidth',2.5)


%grandes areas
line([0 16.5],[(larg/2)-20.16 (larg/2)-20.16],'Color','k','LineWidth',2.5)
line([0 16.5],[(larg/2)+20.16 (larg/2)+20.16],'Color','k','LineWidth',2.5)
line([16.5 16.5],[(larg/2)-20.16 (larg/2)+20.16],'Color','k','LineWidth',2.5)
line([0 5.5],[(larg/2)-9.16 (larg/2)-9.16],'Color','k','LineWidth',2.5)
line([5.5 5.5],[(larg/2)-9.16 (larg/2)+9.16],'Color','k','LineWidth',2.5)
line([comp-16.5 comp],[(larg/2)-20.16 (larg/2)-20.16],'Color','k','LineWidth',2.5)
line([comp-16.5 comp],[(larg/2)+20.16 (larg/2)+20.16],'Color','k','LineWidth',2.5)
line([comp-16.5 comp-16.5],[(larg/2)-20.16 (larg/2)+20.16],'Color','k','LineWidth',2.5)


%pequenas areas
line([0 5.5],[(larg/2)-9.16 (larg/2)-9.16],'Color','k','LineWidth',2.5)
line([5.5 5.5],[(larg/2)-9.16 (larg/2)+9.16],'Color','k','LineWidth',2.5)
line([0 5.5],[(larg/2)+9.16 (larg/2)+9.16],'Color','k','LineWidth',2.5)
line([comp-5.5 comp],[(larg/2)-9.16 (larg/2)-9.16],'Color','k','LineWidth',2.5)
line([comp-5.5 comp],[(larg/2)+9.16 (larg/2)+9.16],'Color','k','LineWidth',2.5)
line([comp-5.5 comp-5.5],[(larg/2)-9.16 (larg/2)+9.16],'Color','k','LineWidth',2.5)
line([comp-5.5 comp],[(larg/2)-9.16 (larg/2)-9.16],'Color','k','LineWidth',2.5)
line([comp-5.5 comp],[(larg/2)+9.16 (larg/2)+9.16],'Color','k','LineWidth',2.5)
line([comp-5.5 comp-5.5],[(larg/2)-9.16 (larg/2)+9.16],'Color','k','LineWidth',2.5)

%circulos

centro = plot(.14+comp/2,larg/2,'k');
set(centro,'Marker','.')   
set(centro,'MarkerSize',20)

penalti = plot(11,larg/2,'k',comp-11,larg/2,'k');
set(penalti,'Marker','.')   
set(penalti,'MarkerSize',20)

ang1=linspace(-pi,pi,100);
x1=(9.15*cos(ang1))+comp/2;
y1=(9.15*sin(ang1))+larg/2;
line(x1,y1,'Color','k','LineWidth',2.5)

ang2=linspace(-pi/3.5,pi/3.5,100);
x2=(9.15*cos(ang2))+11;
y2=(9.15*sin(ang2))+larg/2;
line(x2,y2,'Color','k','LineWidth',2.5)

ang3=linspace((-pi/3.5)+pi,(pi/3.5)+pi,100);
x3=(9.15*cos(ang3))+comp-11;
y3=(9.15*sin(ang3))+larg/2;
line(x3,y3,'Color','k','LineWidth',2.5)

daspect([1 1 1])

% text(comp/4.4,-3,'ATAQUE','FontSize',12)
% text(comp/1.375,-3,'DEFESA','FontSize',12)

end

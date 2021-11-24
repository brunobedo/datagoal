function [res] = TeamCompLargAreaDist(dataraw)
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

%%  Calculating Area  
    for i = 1:size(xdata,1)
        K = convhull(xdata(i,:),ydata(i,:));

        SufArea(i,:) = polyarea(xdata(i,K),ydata(i,K));
    end
    Area_Mean = mean(SufArea); 
    Area_Median = median(SufArea); 
    Area_STD = std(SufArea);

%%  Calculando Largura e Comprimento
    for i = 1:size(xdata,1)
    %   Comprimento
        [Comp_x_max_v(i,:) Comp_x_max_c(i,:)] = max(xdata(i,:));
        [Comp_x_min_v(i,:) Comp_x_min_c(i,:)] = min(xdata(i,:));

    %   Largura
        [Larg_y_max_v(i,:) Larg_y_max_c(i,:)] = max(ydata(i,:));
        [Larg_y_min_v(i,:) Larg_y_min_c(i,:)] = min(ydata(i,:));

    %   Calculando distancias
        dist_comp_met2(i,1) = Comp_x_max_v(i,:) - Comp_x_min_v(i,:);
        dist_larg_met2(i,1) = Larg_y_max_v(i,:) - Larg_y_min_v(i,:);    
    end
%   Média/Mediana/SD das variáveis
    Comprimento_Mean = mean(dist_comp_met2);
    Comprimento_Median = median(dist_comp_met2); 
    Comprimento_STD = std(dist_comp_met2);

    Largura_Mean = mean(dist_larg_met2); 
    Largura_Median = median(dist_larg_met2); 
    Largura_STD = std(dist_larg_met2);

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
        players{p,1} = strcat('\leftarrow ',players{p});
    end
    
    text(PlayersMeanX+0.7,PlayersMeanY,players,'FontWeight','bold','FontSize',12);
    p1 = plot(PlayersMeanX,PlayersMeanY,'or','MarkerSize',5,'LineWidth',3);
    p2 = plot(teamMeanX,teamMeany,'^r','MarkerSize',5,'LineWidth',3);

%   Calculandao Area
    conv = convhull(PlayersMeanX,PlayersMeanY);
    p3 = plot(PlayersMeanX(conv),PlayersMeanY(conv),'-k','LineWidth',1.5);
    
%   Comprimento
    [MeanComp_x_max_v, MeanComp_x_max_c] = max(PlayersMeanX);
    [MeanComp_x_min_v, MeanComp_x_min_c] = min(PlayersMeanX);    
    p4 = plot(PlayersMeanX([MeanComp_x_min_c,MeanComp_x_max_c]),[0,0],'-R','LineWidth',3.5);
    text(mean(PlayersMeanX([MeanComp_x_min_c,MeanComp_x_max_c]))-2,-1.5,['C: ',num2str(round(Comprimento_Mean,2)),'m'],'FontWeight','bold','FontSize',12,'HorizontalAlignment','Center');
    
%   Largura
    [MeanLarg_y_max_v, MeanLarg_y_max_c] = max(PlayersMeanY);
    [MeanLarg_y_min_v, MeanLarg_y_min_c] = min(PlayersMeanY); 
    p5 = plot([0,0],PlayersMeanY([MeanLarg_y_min_c,MeanLarg_y_max_c]),'-R','LineWidth',3.5);
    text(-2,mean(PlayersMeanY([MeanLarg_y_min_c,MeanLarg_y_max_c])),['L: ',num2str(round(Largura_Mean,2)),'m'],'FontWeight','bold','FontSize',12,'HorizontalAlignment','Center','Rotation',90);

    legend ([p1,p2,p3,p4,p5],'Players','Centroid','Mean Area','(C)-Comprimento','(L)-Largura')
    title(['Area: ',num2str(Area_Mean),'m^2']); 
    set(gca,'XColor', 'none','YColor','none')
    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg')   %,'-transparent'
    
%%  Saving results 
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    
    res = [Area_Mean Area_Median Area_STD,...
           Largura_Mean,Largura_Median,Largura_STD,...
           Comprimento_Mean,Comprimento_Median,Comprimento_STD]; 

    tit = {'Mean Area (m^2)','Median Area(m^2)','Standard deviation Area(m^2)',...
           'Mean Comprimento(m)','Median Comprimento(m)','Standard deviation Comprimento(m)',...
           'Mean Largura(m)','Median Largura(m)','Standard deviation Largura(m)',...
           };
    xlswrite(fname,tit,1,'A1')
    xlswrite(fname,res,1,'A2')
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp(1:30));
    ewb.Save 
    ewb.Close(false)
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
pause
for i = 1:size(xdata)
   
    x_eq = xdata(i,:);
    y_eq = ydata(i,:);
    
    conv = convhull(x_eq,y_eq);
    polyin = polyshape({xdata(i,conv)},{ydata(i,conv)});
    
    % retorna a área de superfície (surface area)em m² a cada quadro de imagem
    surface_area(i,:) = polyarea(xdata(i,conv),ydata(i,conv));

    p1(i) = plot(xdata(i,:),ydata(i,:),'or','MarkerSize',5,'LineWidth',3);
    hold on
    p2(i) = plot(xdata(i,conv),ydata(i,conv),'k-');
    t1 = text(xdata(i,:)+0.7,ydata(i,:),players,'FontWeight','bold','FontSize',12);
    [x,y] = centroid(polyin);
    p3(i) = plot(x,y,'b*','MarkerSize',5,'LineWidth',3);
    
    p4(i) = plot(xdata(i,[Comp_x_min_c(i),Comp_x_max_c(i)]),[0,0],'-R','LineWidth',2.5);
    p5(i) = plot([0,0],ydata(i,[Larg_y_min_c(i),Larg_y_max_c(i)]),'-R','LineWidth',2.5);
    
        
    t2 = text(mean(xdata(i,[Comp_x_min_c(i),Comp_x_max_c(i)]))-2,-1.5,['C: ',num2str(round(dist_comp_met2(i),2)),'m'],'FontWeight','bold','FontSize',12,'HorizontalAlignment','Center');
    t3 = text(-2,mean(ydata(i,[Larg_y_min_c(i),Larg_y_max_c(i)])),['L: ',num2str(round(dist_larg_met2(i),2)),'m'],'FontWeight','bold','FontSize',12,'HorizontalAlignment','Center','Rotation',90);

    title(['Area: ',num2str(surface_area(i,:)),'m^2'])
    legend([p1(i),p3(i),p4(i),p5(i)],'Players','Centroid','(C)-Comprimento','L-Largura')
    

    disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
    f(i) = getframe(f1);
    writeVideo(vidObj,f(i));

    pause(0.2)
    delete(p1(i))
    delete(p2(i))
    delete(p3(i))
    delete(p4(i))
    delete(p5(i))
    delete(t1)
    delete(t2)
    delete(t3)
    
end  

disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
f(i) = getframe(f1);
writeVideo(vidObj,f(i));

end
close(f1)











































    



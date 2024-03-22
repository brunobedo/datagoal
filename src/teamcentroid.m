function res = teamcentroid(dataraw)
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
    %   Calculate de team centroid
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

    % 	Calculating centroid based in all players
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

    % 	Calculating centroid based in all polygon
    for i = 1:size(xdata)
        conv = convhull(xdata(i,:),ydata(i,:));
        polyin(i,:) = polyshape({xdata(i,conv)},{ydata(i,conv)});
        [polx(i,:),poly(i,:)] = centroid(polyin(i,:));
    end

    %   Mean of the centroide based on the polygon
    MeanPolX = mean(polx);
    MeanPolY = mean(poly);
    
    %   Median of the centroide based on the polygon
    MedianPolX = median(polx);
    MedianPolY = median(polx);

    %%   Creating figure
    %   Figure 1 (field)
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    campo
    hold on
    %     axis off
    sizeDef = size(selections.PlayersList.Defender,1);
    sizeMid = size(selections.PlayersList.Midfielder,1);
    sizeFow = size(selections.PlayersList.Forwards,1);
    sizeTotal = sum([sizeDef sizeMid sizeFow]);
    
    for z = 1:sizeTotal
        txt = players{z};
        text(PlayersMeanX(:,z)+0.7,PlayersMeanY(:,z),txt)
        if      z <= sizeDef
                p1 = plot(PlayersMeanX(:,z),PlayersMeanY(:,z),'ob','MarkerSize',5,'LineWidth',5); %   Playrs' mean
        elseif  z > sizeDef && z <= sizeMid+sizeDef
                p2 = plot(PlayersMeanX(:,z),PlayersMeanY(:,z),'or','MarkerSize',5,'LineWidth',5); %   Playrs' mean
        elseif  z > sizeMid+sizeFow
                p3 = plot(PlayersMeanX(:,z),PlayersMeanY(:,z),'og','MarkerSize',5,'LineWidth',5); %   Playrs' mean
        end
    end   
    %     p1 = plot(PlayersMeanX,PlayersMeanY,'ob','MarkerSize',5,'LineWidth',5); %   Players' mean
    p4 = plot(teamMeanX,teamMeany,'^r','MarkerSize',5,'LineWidth',5);       %   Team's mean position
    p5 = plot(teamMedianX,teamMediany,'^c','MarkerSize',5,'LineWidth',5);   %   Team's median position
    p6 = plot(MeanPolX,MeanPolY,'sr','MarkerSize',5,'LineWidth',5);         %   Team's mean polygon
    p7 = plot(MedianPolX,MedianPolY,'sc','MarkerSize',5,'LineWidth',5);     %   Team's median polygon


    if  exist('p1')==1 && exist('p2')==0 && exist('p3')==0 
        lgd = legend([p1,p4,p5,p6,p7],{ 'Defenders mean position','Team mean position',...
                                        'Team median position','Team mean (polygon)','Team median polygon'});
    end

    if  exist('p1')==1 && exist('p2')==1 && exist('p3')==0
        lgd = legend([p1,p2,p4,p5,p6,p7],{  'Defenders mean position','Midfielder mean position','Team mean position',...
                                            'Team median position','Team mean (polygon)','Team median polygon'});
    end
    
    if  exist('p1')==1 && exist('p2')==1 && exist('p3')==1
    lgd = legend([p1,p2,p3,p4,p5,p6,p7],{   'Defenders mean position','Midfielder mean position',...
                                            'Forwards mean position','Team mean position',...
                                            'Team median position','Team mean (polygon)','Team median polygon'});
    end  
    
    if  exist('p1')==0 && exist('p2')==1 && exist('p3')==0 
    lgd = legend([p2,p4,p5,p6,p7],{         'Midfielder mean position','Team mean position',...
                                            'Team median position','Team mean (polygon)','Team median polygon'});
    end
    
    if  exist('p1')==0 && exist('p2')==1 && exist('p3')==1
      lgd = legend([p2,p3,p4,p5,p6,p7],{    'Midfielder mean position',...
                                            'Forwards mean position','Team mean position',...
                                            'Team median position','Team mean (polygon)','Team median polygon'});
    end
    
    title(lgd,'Players')

    %   Saving figure
    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg')%,'-transparent')

    %   Saving results (.csv)
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];

    tit = { 'Team mean position X','Team mean position Y','Team median position X','Team median position Y'...
            'Team mean position (polygon) X','Team mean position (polygon) Y',...
            'Team median position (polygon) X','Team median position (polygon) Y'};
    res = [teamMeanX teamMeany teamMedianX teamMediany MeanPolX MeanPolY MedianPolX MedianPolY];
    
    xlswrite(fname,tit,1,'A1')
    xlswrite(fname,res,1,'A2')
    close(f1)

    %   Sheet's name
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp(1:end));
    ewb.Save 
    ewb.Close(false)

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
        axis off
        pause
        hold on
        for i = 1:size(xdata)
        
            x_eq = xdata(i,:);
            y_eq = ydata(i,:);
            
            conv = convhull(x_eq,y_eq);
            polyin = polyshape({xdata(i,conv)},{ydata(i,conv)});
            
            % retorna a �rea de superf�cie (surface area)em m� a cada quadro de imagem
            surface_area(i,:) = polyarea(xdata(i,conv),ydata(i,conv));

            p1(i) = plot(xdata(i,:),ydata(i,:),'or','MarkerSize',5,'LineWidth',3);
            hold on
            p2(i) = plot(xdata(i,conv),ydata(i,conv),'b-');
        %     p2(i) = plot(polyin);
            [x,y] = centroid(polyin);
            p3(i) = plot(x,y,'b*','MarkerSize',5,'LineWidth',3);
            title(['Area: ',num2str(surface_area(i,:)),'m^2'])
        %     legend([p1,p3],'Players','Centroid')

        disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
        f(i) = getframe(f1);
        writeVideo(vidObj,f(i));

            pause(0.2)
            delete(p1(i))
            delete(p2(i))
            delete(p3(i))
        end
    close(f1)
    end
end



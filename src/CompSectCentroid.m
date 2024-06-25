function [res] = CompSectCentroid(dataraw)
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
        
    %%	Separating data
    xdata = dataraw.X; 
    ydata = dataraw.Y;

    %%  Player's name
    playfull = [selections.PlayersList.Defender;selections.PlayersList.Midfielder;selections.PlayersList.Forwards];
    for p = 1:size(playfull)
        po= strfind(playfull{p},'.');
        players{p,1} = playfull{p}(1:po(end)-1);
        players{p,1} = strrep(players{p},'_','-');
    end

    %%  Separating sectors  
    %   Defender
    sD = size(selections.PlayersList.Defender,1); 
    pD = players(1:sD);
    xdataD = xdata(:,1:sD); 
    ydataD = ydata(:,1:sD); 

    %   Midfielder
    sM = size(selections.PlayersList.Midfielder,1); 
    pM = players(1:sM);
    xdataM = xdata(:,1+sD:sM+sD); 
    ydataM = ydata(:,1+sD:sM+sD); 

    %   Forwards
    sF = size(selections.PlayersList.Forwards,1); 
    pF = players(1:sF);
    xdataF = xdata(:,1+sD+sM:sM+sD+sF); 
    ydataF = ydata(:,1+sD+sM:sM+sD+sF);

    %%  Calculating the averages positions of each sector
    %   Averages of each player     
    %   Defender
    DPlayMeanX = mean(xdataD,1);
    DPlayMeanY = mean(ydataD,1);
    %   Midfielder
    MPlayMeanX = mean(xdataM,1);
    MPlayMeanY = mean(ydataM,1);
    %   Forwards
    FPlayMeanX = mean(xdataF,1);
    FPlayMeanY = mean(ydataF,1);

    %   Sector average
    %   Defender
    DSecMeanX = mean(DPlayMeanX);
    DSecMeanY = mean(DPlayMeanY);
    %   Midfielder
    MSecMeanX = mean(MPlayMeanX);
    MSecMeanY = mean(MPlayMeanY);
    %   Forwards
    FSecMeanX = mean(FPlayMeanX);
    FSecMeanY = mean(FPlayMeanY);

    %   Calculating distance between the avaregares betweem sectors (Euclidian distance)
    %   Defender - Midfielder
    distmeanDM = pdist([DSecMeanX DSecMeanY;MSecMeanX MSecMeanY],'euclidean');

    %   Midfielder - Forwards
    distmeanMF = pdist([MSecMeanX MSecMeanY;FSecMeanX FSecMeanY],'euclidean');

    %   Defender - Forwards
    distmeanDF = pdist([DSecMeanX DSecMeanY;FSecMeanX FSecMeanY],'euclidean');

    %%  Calculating the medians positions of each sector
    %   Medians of each player     
    %   Defender
    DPlaymedianX = median(xdataD,1);
    DPlaymedianY = median(ydataD,1);
    %   Midfielder
    MPlaymedianX = median(xdataM,1);
    MPlaymedianY = median(ydataM,1);
    %   Forwards
    FPlaymedianX = median(xdataF,1);
    FPlaymedianY = median(ydataF,1);

    %   Sector median
    %   Defender
    DSecmedianX = median(DPlaymedianX);
    DSecmedianY = median(DPlaymedianY);
    %   Midfielder
    MSecmedianX = median(MPlaymedianX);
    MSecmedianY = median(MPlaymedianY);
    %   Forwards
    FSecmedianX = median(FPlaymedianX);
    FSecmedianY = median(FPlaymedianY);

    %   Calculating distance between the avaregares betweem sectors (Euclidian distance)
    %   Defender - Midfielder
    distmedianDM = pdist([DSecmedianX DSecmedianY;MSecmedianX MSecmedianY],'euclidean');

    %   Midfielder - Forwards
    distmedianMF = pdist([MSecmedianX MSecmedianY;FSecmedianX FSecmedianY],'euclidean');

    %   Defender - Forwards
    distmedianDF = pdist([DSecmedianX DSecmedianY;FSecmedianX FSecmedianY],'euclidean');

    %%  Creating figure anf saving
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Sectors distance','units','normalized','outerposition',[0 0 1 1])
    campo
        hold on
    %   Players' position
    %   Defenders
    p1a = plot(DPlayMeanX,DPlayMeanY,'ob','MarkerSize',5,'LineWidth',5);
    p1b = plot(DSecMeanX,DSecMeanY,'^b','MarkerSize',5,'LineWidth',5);
    if  size(DPlayMeanX)<=2
        p1c = plot(DPlayMeanX,DPlayMeanY,'-b');
    elseif  size(DPlayMeanX,2)==3
        t = delaunay(DPlayMeanX,DPlayMeanY); 
        p1c = triplot(t,DPlayMeanX,DPlayMeanY,'-b');
    else    
        conv1 = convhull(DPlayMeanX,DPlayMeanY);
        p1c = plot(DPlayMeanX(conv1),DPlayMeanY(conv1),'-b');
    end

    %   Midfielder
    p2a = plot(MPlayMeanX,MPlayMeanY,'or','MarkerSize',5,'LineWidth',5);
    p2b = plot(MSecMeanX,MSecMeanY,'^r','MarkerSize',5,'LineWidth',5);
    if  size(MPlayMeanX,2)<=2
        p2c = plot(MPlayMeanX,MPlayMeanY,'-r');
    elseif  size(MPlayMeanX,2)==3
        t = delaunay(MPlayMeanX,MPlayMeanY); 
        p2c = triplot(t,MPlayMeanX,MPlayMeanY,'-r');
    else    
        conv2 = convhull(MPlayMeanX,MPlayMeanY);
        p2c = plot(MPlayMeanX(conv2),MPlayMeanY(conv2),'-r');
    end

    %   Forwards
        p3a = plot(FPlayMeanX,FPlayMeanY,'og','MarkerSize',5,'LineWidth',5);
        p3b = plot(FSecMeanX,FSecMeanY,'^g','MarkerSize',5,'LineWidth',5);
    if  size(FPlayMeanX,2)<=2
        p3c = plot(FPlayMeanX,FPlayMeanY,'-g');
    elseif  size(FSecMeanX,2)==3
        t = delaunay(FPlayMeanX,FPlayMeanY); 
        p3c = triplot(t,FPlayMeanX,FPlayMeanY,'-g');
    else    
        conv3 = convhull(FPlayMeanX,FPlayMeanY);
        p3c = plot(FPlayMeanX(conv3),FPlayMeanY(conv3),'-g');
    end

    %   Plotting distance
    %   Defender - Midfielder
    pdm = plot([DSecMeanX MSecMeanX],[DSecMeanY MSecMeanY],'LineWidth',1.5,'Color','k','LineStyle','- -');
    %   Midfielder - Forwards
    pmf = plot([MSecMeanX FSecMeanX],[MSecMeanY FSecMeanY],'LineWidth',1.5,'Color','k','LineStyle',':');
    %   Defender - Forwards
    pdf = plot([DSecMeanX FSecMeanX],[DSecMeanY FSecMeanY],'LineWidth',1.5,'Color','k','LineStyle','-.');
    set(gca,'XColor', 'none','YColor','none')
    %     legend([p1a,p1b,p2a,p2b,p3a,p3b,pdm,pmf,pdf],...
    %     'Defenders','Defenders'' centroid','Midfielder','Midfielders'' centroid',...
    %     'Forwards','Forwards'' centroid','Distance between defenders and midfielder',...
    %     'Distance between midfielder and forwards','Distance between defenders and forwards')
    legend([p1a,p1b,p2a,p2b,p3a,p3b,pdm,pmf,pdf],...
    'Defensores','Centrï¿½ide Defensores','Meio Campo','Centrï¿½ide do Meio Campo',...
    'Atacantes','Centrï¿½ide dos Atacantes','Distï¿½ncia entre Defensores e Maio Campistas',...
    'Distï¿½ncia entre Maio Campistas e Atacantes','Distï¿½ncia entre Defensores e Atacantes')
        %   Saving
    title({'Distance between sectors:';['Defenders - Midfielder: ', num2str(distmedianDM),' m'];...
        ['Midfielders - Forwards: ', num2str(distmedianMF),' m'];...
        ['Defenders - Forwards: ' ,num2str(distmedianDF),' m']})
    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg') %,'-transparent'

    %%  Saving results
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    
    res = [distmeanDM distmeanMF distmeanDF distmedianDM distmedianMF distmedianDF]; 
    
    tit = {'Mean distance: Def-Mid','Mean distance: Mid-For','Mean distance: Def-For',...
            'Median distance: Def-Mid','Median distance: Mid-For','Median distance: Def-For'};

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
    % axis off
    pause
    for i = 1:size(xdataD)
    %   Defenders
        DX = mean(xdataD(i,:)); 
        DY = mean(ydataD(i,:));
        pa1(i) = plot(xdataD(i,:),ydataD(i,:),'ob','MarkerSize',5,'LineWidth',3);
        pb1(i) = plot(DX,DY,'^b','MarkerSize',5,'LineWidth',3);
        
        if  size(xdataD,2)<=2
            pc1(i) = plot(xdataD(i,:),ydataD(i,:),'-b');
        elseif  size(xdataD,2)==3
                t = delaunay(xdataD(i,:),ydataD(i,:)); 
                pc1(i) = triplot(t,xdataD(i,:),ydataD(i,:),'-b');
        else    
            conv1 = convhull(xdataD(i,:),ydataD(i,:));
            pc1(i) = plot(xdataD(i,conv1),ydataD(i,conv1),'-b');
        end
        
%       Midfielders
        MX = mean(xdataM(i,:)); 
        MY = mean(ydataM(i,:));
        pa2(i) = plot(xdataM(i,:),ydataM(i,:),'or','MarkerSize',5,'LineWidth',3);
        pb2(i) = plot(MX,MY,'^r','MarkerSize',5,'LineWidth',3);
        
        if  size(xdataM,2)<=2
            pc2(i) = plot(xdataM(i,:),ydataM(i,:),'-r');
        elseif  size(xdataM,2)==3
                t = delaunay(xdataM(i,:),ydataM(i,:)); 
                pc2(i) = triplot(t,xdataM(i,:),ydataM(i,:),'-r');
        else    
            conv2 = convhull(xdataM(i,:),ydataM(i,:));
            pc2(i) = plot(xdataM(i,conv2),ydataM(i,conv2),'-r');
        end

%       Forwards
        FX = mean(xdataF(i,:)); 
        FY = mean(ydataF(i,:));
        pa3(i) = plot(xdataF(i,:),ydataF(i,:),'og','MarkerSize',5,'LineWidth',3);
        pb3(i) = plot(FX,FY,'^g','MarkerSize',5,'LineWidth',3);
        
        if  size(xdataF,2)<=2
            pc3(i) = plot(xdataF(i,:),ydataF(i,:),'-g');
        elseif  size(xdataF,2)==3
                t = delaunay(xdataF(i,:),ydataF(i,:)); 
                pc3(i) = triplot(t,xdataF(i,:),ydataF(i,:),'-g');
        else    
            conv3 = convhull(xdataF(i,:),ydataF(i,:));
            pc3(i) = plot(xdataF(i,conv3),ydataF(i,conv3),'-g');
        end
        
%       Calcualting distance
        distDM = pdist([DX DY; MX MY],'euclidean');
        distMF = pdist([MX MY; FX DY],'euclidean');
        distDF = pdist([DX DY; FX DY],'euclidean');
        
        pa4(i) = plot([DX MX],[DY MY],'LineWidth',1.5,'Color','k','LineStyle','- -');
        pb4(i) = plot([MX FX],[MY FY],'LineWidth',1.5,'Color','k','LineStyle',':');
        pc4(i) = plot([DX FX],[DY FY],'LineWidth',1.5,'Color','k','LineStyle','-.');

        legend([pa1(i),pb1(i),pa2(i),pb2(i),pa3(i),pb3(i),pa4(i),pb4(i),pc4(i)],...
        'Defenders','Defenders'' centroid','Midfielder','Midfielders'' centroid',...
        'Forwards','Forwards'' centroid','Distance between defenders and midfielder',...
        'Distance between midfielder and forwards','Distance between defenders and forwards')

        title({'Distance between sectors:';['Defenders - Fidfielder: ', num2str(distDM),' m'];...
            ['Midfielders - Forwards: ', num2str(distMF),' m'];...
            ['Defenders - Forwards: ' ,num2str(distDF),' m']})

        disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
        f(i) = getframe(f1);
        writeVideo(vidObj,f(i));

        pause(0.02)
        delete(pa1(i))
        delete(pb1(i))
        delete(pc1(i))
        delete(pa2(i))
        delete(pb2(i))
        delete(pc2(i))
        delete(pa3(i))
        delete(pb3(i))
        delete(pc3(i))
        delete(pa4(i))
        delete(pb4(i))
        delete(pc4(i))

        end
    close(f1)
    end
end
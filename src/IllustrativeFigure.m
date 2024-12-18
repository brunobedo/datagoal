function  IllustrativeFigure(dataraw)
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

    %% General data
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

    %%  Calculating variables
    %%  1. Espaï¿½o de Jogo Efetivo ï¿½ Nï¿½vel da equipe
    for i = 1:size(xdata,1)
        K = convhull(xdata(i,:),ydata(i,:));
        
        SufArea(i,:) = polyarea(xdata(i,K),ydata(i,K));
    end

    %%  2. Stretch index
    for i = 1:size(TMean,1)   
        linX = xdata(i,:); 
        linY = ydata(i,:); 
        lin = [linX' linY']; 
        
        for w = 1:size(lin,1)
            TotalSI(i,w) = pdist([lin(w,:);TMean(i,:)]);
        end
    end

    %%  3. Team spread
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

    %%  4. Centroide por setores da equipe
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

    for i = 1:size(xdata,1)
    %   Sector average
    %   Defender
        DSecMeanX(i,1) = mean(xdataD(i,:));
        DSecMeanY(i,1) = mean(ydataD(i,:));
    %   Midfielder
        MSecMeanX(i,1) = mean(xdataM(i,:));
        MSecMeanY(i,1) = mean(ydataM(i,:));
    %   Forwards
        FSecMeanX(i,1) = mean(xdataF(i,:));
        FSecMeanY(i,1) = mean(ydataF(i,:));

    %   Calculating distance between the avaregares betweem sectors (Euclidian distance)
    %   Defender - Midfielder
        distmeanDM(i,:) = pdist([DSecMeanX(i,1) DSecMeanY(i,1);MSecMeanX(i,1) MSecMeanY(i,1)],'euclidean');

    %   Midfielder - Forwards
        distmeanMF(i,:) = pdist([MSecMeanX(i,1) MSecMeanY(i,1);FSecMeanX(i,1) FSecMeanY(i,1)],'euclidean');

    %   Defender - Forwards
        distmeanDF(i,:) = pdist([DSecMeanX(i,1) DSecMeanY(i,1);FSecMeanX(i,1) FSecMeanY(i,1)],'euclidean');
    end

    %%  Creating a video file
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

    %%  Creating figure
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    f1a = subplot(2,2,1); campo; %axis off;
    f1b = subplot(2,2,2); campo; %axis off;
    f1c = subplot(2,2,3); campo; %axis off;
    f1d = subplot(2,2,4); campo; %axis off;
    pause
    for i = 1:size(xdata,1)
    disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
    
        %%  Figures
        %%  Figure 1.  Espaï¿½o de Jogo Efetivo ï¿½ Nï¿½vel da equipe
        axes(f1a)

        x_eq = xdata(i,:);
        y_eq = ydata(i,:);
        
        conv = convhull(x_eq,y_eq);
        polyin = polyshape({xdata(i,conv)},{ydata(i,conv)});
        
        % retorna a ï¿½rea de superfï¿½cie (surface area)em mï¿½ a cada quadro de imagem
        surface_area(i,:) = polyarea(xdata(i,conv),ydata(i,conv));

        p1a(i) = plot(xdata(i,:),ydata(i,:),'or','MarkerSize',5,'LineWidth',3);
        hold on
        p1b(i) = plot(xdata(i,conv),ydata(i,conv),'k-','LineWidth',2);
        [x,y] = centroid(polyin);
        p1c(i) = plot(x,y,'^b','MarkerSize',5,'LineWidth',3);
        title({['Effective area'];[ num2str(surface_area(i,:)),'m^2']})
        legend([p1a(i),p1c(i)],'Players','Centroid')

        %%  Figure 2. 
        axes(f1b)

        p2a = plot(xdata(i,:),ydata(i,:),'ro','MarkerSize',5,'LineWidth',3);
        p2b = plot(TMean(i,1),TMean(i,2),'^b','MarkerSize',5,'LineWidth',3);
        conv1 = convhull(xdata(i,:),ydata(i,:));
        p2c = plot(xdata(i,conv1),ydata(i,conv1),'-k');
        lin = [xdata(i,:)',ydata(i,:)'];
        
        for w = 1:size(lin,1)
        p2d(w) = plot([lin(w,1),TMean(i,1)],[lin(w,2),TMean(i,2)],':k','LineWidth',1.5);
        tp(i,w) = text(xdata(i,w)+2,ydata(i,w),num2str(round(TotalSI(i,w),1)));
        end

        legend([p2a, p2b, p2d(w)],'PLayers','Centroid','Players'' SI')
        title({'Stretch Index (SI)';['Mean: ',num2str(mean(TotalSI(i,:))),' m']})

        %%  Figure 3. Team spread
        axes(f1c)

        p3a = plot(xdata(i,:),ydata(i,:),'ro','MarkerSize',5,'LineWidth',3);
        p3b = plot(TMean(i,1),TMean(i,2),'^b','MarkerSize',5,'LineWidth',3);
        
        mat = [xdata(i,:)',ydata(i,:)'];
        
        for z = 1:size(mat,1)
            for w = 1:size(mat,1)
                p3c(z,w) = plot([mat(z,1) mat(w,1)],[mat(z,2) mat(w,2)],'LineWidth',0.5,'Color','k','LineStyle',':');
            end
        end

        legend([p3a,p3b,p3c(1,1)],'Players','Centroid','Team Spread')
        title({'Team Spread';[num2str(spread(i)),' m']})

        %%  Figure 4. 
        axes(f1d)
        title('Distance between sectors')

        %       Defenders
        DX = mean(xdataD(i,:)); 
        DY = mean(ydataD(i,:));
        p4a(i) = plot(xdataD(i,:),ydataD(i,:),'o','MarkerSize',5,'LineWidth',3,'Color',[0.8500 0.3250 0.0980]);
        p4b(i) = plot(DX,DY,'^','MarkerSize',5,'LineWidth',2,'Color',[0.8500 0.3250 0.0980]);
        
        if  size(xdataD,2)<=2
            p4c(i) = plot(xdataD(i,:),ydataD(i,:),'-','Color',[0.8500 0.3250 0.0980]);
            elseif  size(xdataD,2)==3
                t = delaunay(xdataD(i,:),ydataD(i,:)); 
                p4c(i) = triplot(t,xdataD(i,:),ydataD(i,:),'-y','Color',[0.8500 0.3250 0.0980]);
            else    
                conv1 = convhull(xdataD(i,:),ydataD(i,:));
                p4c(i) = plot(xdataD(i,conv1),ydataD(i,conv1),'-','Color',[0.8500 0.3250 0.0980]);
        end
        
        %       Midfielders
        MX = mean(xdataM(i,:)); 
        MY = mean(ydataM(i,:));
        p4d(i) = plot(xdataM(i,:),ydataM(i,:),'om','MarkerSize',5,'LineWidth',3);
        p4e(i) = plot(MX,MY,'^m','MarkerSize',5,'LineWidth',2);
        
        if  size(xdataM,2)<=2
                p4f(i) = plot(xdataM(i,:),ydataM(i,:),'-m');
            elseif  size(xdataM,2)==3
                t = delaunay(xdataM(i,:),ydataM(i,:)); 
                p4f(i) = triplot(t,xdataM(i,:),ydataM(i,:),'-m');
            else    
                conv2 = convhull(xdataM(i,:),ydataM(i,:));
                p4f(i) = plot(xdataM(i,conv2),ydataM(i,conv2),'-m');
        end

        %       Forwards
        FX = mean(xdataF(i,:)); 
        FY = mean(ydataF(i,:));
        p4g(i) = plot(xdataF(i,:),ydataF(i,:),'og','MarkerSize',5,'LineWidth',3);
        p4h(i) = plot(FX,FY,'^g','MarkerSize',5,'LineWidth',2);
        
        if  size(xdataF,2)<=2
            p4i(i) = plot(xdataF(i,:),ydataF(i,:),'-g');
            elseif  size(xdataF,2)==3
                t = delaunay(xdataF(i,:),ydataF(i,:)); 
                p4i(i) = triplot(t,xdataF(i,:),ydataF(i,:),'-g');
            else    
                conv3 = convhull(xdataF(i,:),ydataF(i,:));
                p4i(i) = plot(xdataF(i,conv3),ydataF(i,conv3),'-g');
        end

%       Calcualting distance
        p4n(i) = plot([DX MX],[DY MY],'LineWidth',1,'Color','k','LineStyle','- -');
        p4o(i) = plot([MX FX],[MY FY],'LineWidth',1,'Color','k','LineStyle',':');
        p4p(i) = plot([DX FX],[DY FY],'LineWidth',1,'Color','k','LineStyle','-');
%         tx(i) = text(xdata(i,:)'+2,ydata(i,:),players);
        
        title({'Distance between sectors';['DEF - MID: ', num2str(round(distmeanDM(i,1),2)),' m'];...
            ['MID - FOR: ', num2str(round(distmeanMF(i,1),2)),' m'];...
            ['DEF - FOR: ' ,num2str(round(distmeanDF(i,1),2)),' m']})

        legend([p4a(i),p4d(i),p4g(i)],...
        'Defenders (DEF)','Midfielders (MID)','Forwards (FOR)')

        %%  Saving to record a video
        f(i) = getframe(f1);
        writeVideo(vidObj,f(i));

        %%  Deleting plots and pause
        %     pause(0.00001)
        delete(p1a(i))
        delete(p1b(i))
        delete(p1c(i))
        delete(p2a)
        delete(p2b)
        delete(p2c)
        delete(p2d)
        delete(tp)
        delete(p3a)
        delete(p3b)
        delete(p3c)
        delete(p4a(i))
        delete(p4b(i))
        delete(p4c(i))
        delete(p4d(i))
        delete(p4e(i))
        delete(p4f(i))
        delete(p4g(i))
        delete(p4h(i))
        delete(p4i(i))
        delete(p4n(i))
        delete(p4o(i))
        delete(p4p(i))
        %     delete(tx(i))
    end
    disp('Done: the video was saved!')
    close(f1)
end


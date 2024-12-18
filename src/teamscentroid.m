function res = teamscentroid(dataraw)
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
        
    %   Separating data
    xdata = dataraw.X; 
    ydata = dataraw.Y;

    %   Player's name
    playfull = [selections.PlayersList.Defender;selections.PlayersList.Midfielder;selections.PlayersList.Forwards;selections.PlayersList.Opponent];
    for p = 1:size(playfull)
        po= strfind(playfull{p},'.');
        players{p,1} = playfull{p}(1:po(end)-1);
        players{p,1} = strrep(players{p},'_','-');
    end
    %   Team 1
    xdatat1 = dataraw.X;
    ydatat1 = dataraw.Y;
    playt1 = players(1:size(xdata,2));
    %   Team 2
    xdatat2 = dataraw.OpX;
    ydatat2 = dataraw.OpY;
    playt2 = players(size(xdata,2)+1:end);

    %%  Calculating the averages positions of both teams 
    %   Averages of each player     
    %   Team 1
    Plat1meanX = mean(xdatat1,1);
    Plat1meanY = mean(ydatat1,1);
    %   Team 2
    Plat2meanX = mean(xdatat2,1);
    Plat2meanY = mean(ydatat2,1);

    %   Team averages 
    %   Team 1
    t1meanX = mean(Plat1meanX);
    t1meanY = mean(Plat1meanY);
    %   Team 2
    t2meanX = mean(Plat2meanX);
    t2meanY = mean(Plat2meanY);

    %   Calculating distance between the avaregares betweem both teams
    %   (Euclidian distance)
    distMean = pdist([t1meanX t1meanY;t2meanX t2meanY],'euclidean');

    %%  Calculating the averages positions of both teams 
    %   median of each player     
    %   Team 1
    Plat1medianX = median(xdatat1,1);
    Plat1medianY = median(ydatat1,1);
    %   Team 2
    Plat2medianX = median(xdatat2,1);
    Plat2medianY = median(ydatat2,1);

    %   Team median 
    %   Team 1
    t1medianX = median(Plat1medianX);
    t1medianY = median(Plat1medianY);
    %   Team 2
    t2medianX = median(Plat2medianX);
    t2medianY = median(Plat2medianY);

    %   Calculating distance between the avaregares betweem both teams
    distmedian= pdist([t1medianX t1medianY;t2medianX t2medianY],'euclidean');

    %%  Creating figure and saving 
    %   Figure 1 (field)
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    campo
    hold on
    
    %   Team 1
    p1a = plot(Plat1meanX,Plat1meanY,'ob','MarkerSize',5,'LineWidth',5);
    p1b = plot(t1meanX,t1meanY,'^b','MarkerSize',5,'LineWidth',5);
    conv1 = convhull(Plat1meanX,Plat1meanY);
    p1c = plot(Plat1meanX(conv1),Plat1meanY(conv1),'-b');

    %   Team 2
    p2a = plot(Plat2meanX,Plat2meanY,'or','MarkerSize',5,'LineWidth',5);
    p2b = plot(t2meanX,t2meanY,'^r','MarkerSize',5,'LineWidth',5);
    conv2 = convhull(Plat2meanX,Plat2meanY);
    p2c = plot(Plat2meanX(conv2),Plat2meanY(conv2),'-r');

    %   Plotting distance
    pd = plot([t1meanX t2meanX],[t1meanY t2meanY],'LineWidth',1.5,'Color','k','LineStyle','- -');
    
    %   Legend
    legend([p1a,p2a,p1b,p2b,pd],'Team 1','Team 2','Team 1 centroid','Team 2 centroid','Distance between centroids');
        
    %   Saving
    title(['Distance between centroid: ', num2str(distMean),' meters'])
    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg')%,'-transparent'

    %% 	Calculating centroid based in all polygon
    for i = 1:size(xdatat1)
        %   Team 1
        convt1 = convhull(xdatat1(i,:),ydatat1(i,:));
        polyint1(i,:) = polyshape({xdatat1(i,convt1)},{ydatat1(i,convt1)});
        [polxt1(i,:),polyt1(i,:)] = centroid(polyint1(i,:));
        
        %   Team 2
        convt2 = convhull(xdatat2(i,:),ydatat2(i,:));
        polyint2(i,:) = polyshape({xdatat2(i,convt2)},{ydatat2(i,convt2)});
        [polxt2(i,:),polyt2(i,:)] = centroid(polyint2(i,:));
    end

    %   Mean of the centroide based on the polygon
    %   Team 1
        MeanPolt1X = mean(polxt1);
        MeanPolt1Y = mean(polyt1);
    %   Team 2
        MeanPolt2X = mean(polxt2);
        MeanPolt2Y = mean(polyt2);
    %   Distance
        distmeanPol= pdist([MeanPolt1X MeanPolt1Y;MeanPolt2X MeanPolt2Y],'euclidean');
    
    %   Median of the centroide based on the polygon
    %   Team 1
        medianPolt1X = median(polxt1);
        medianPolt1Y = median(polyt1);
    %   Team 2
        medianPolt2X = median(polxt2);
        medianPolt2Y = median(polyt2);
    %   Distance
        distmedianPol= pdist([medianPolt1X medianPolt1Y;medianPolt2X medianPolt2Y],'euclidean');

    %%  Saving results
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    res = [ t1meanX t1meanY t2meanX t2meanY distMean...
                t1medianX t1medianY t2medianX t2medianY distmedian...
                MeanPolt1X MeanPolt1Y MeanPolt2X MeanPolt2Y distmeanPol...
                medianPolt1X medianPolt1Y medianPolt2X medianPolt2Y distmedianPol]; 
    
    tit = {'Team 1 mean X','Team 1 mean Y','Team 2 mean X','Team 2 mean Y','Distance (mean)'...
            'Team 1 mediam X','Team 1 mediam Y','Team 2 mediam X','Team 2 mediam Y','Distance (median)'...
            'Team 1 mean X (Polig)','Team 1 mean Y (Polig)','Team 2 mean X (Polig)','Team 2 mean Y (Polig)','Distance mean (Polig)'...
            'Team 1 mediam X (Polig)','Team 1 mediam Y (Polig)','Team 2 mediam X (Polig)','Team 2 mediam Y (Polig)','Distance median(Polig)'};
    
    xlswrite(fname,tit,1,'A1')
    xlswrite(fname,res,1,'A2')
    %   Sheet's name
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp(1:30));
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
        hold on
        % axis off
        pause
        for i = 1:size(xdatat1)
            %   Team 1
            convt1 = convhull(xdatat1(i,:),ydatat1(i,:));
            polyint1(i,:) = polyshape({xdatat1(i,convt1)},{ydatat1(i,convt1)});
            [polxt1(i,:),polyt1(i,:)] = centroid(polyint1(i,:));
            [xt1,yt1] = centroid(polyint1(i,:));

            p1t1(i) = plot(xdatat1(i,:),ydatat1(i,:),'ob','MarkerSize',5,'LineWidth',3);
            p2t1(i) = plot(xdatat1(i,convt1),ydatat1(i,convt1),'b-');
            p3t1(i) = plot(xt1,yt1,'b^','MarkerSize',5,'LineWidth',3);
        
            %   Team 2
            convt2 = convhull(xdatat2(i,:),ydatat2(i,:));
            polyint2(i,:) = polyshape({xdatat2(i,convt2)},{ydatat2(i,convt2)});
            [polxt2(i,:),polyt2(i,:)] = centroid(polyint2(i,:));
            [xt2,yt2] = centroid(polyint2(i,:));

            p1t2(i) = plot(xdatat2(i,:),ydatat2(i,:),'or','MarkerSize',5,'LineWidth',3);
            p2t2(i) = plot(xdatat2(i,convt2),ydatat2(i,convt2),'r-');
            p3t2(i) = plot(xt2,yt2,'r^','MarkerSize',5,'LineWidth',3);
    
    %       Calcualting distance
            distpoly= pdist([xt1 yt1; xt2 yt2],'euclidean');
            pld(i) = plot([xt1 xt2],[yt1 yt2],'LineWidth',1.5,'Color','k','LineStyle','- -');
            
            title(['Distance between centroids: ', num2str(distpoly),' meters'])
            
            legend([p1t1(i),p1t2(i),p3t1(i),p3t2(i),pld(i)],'Team 1','Team 2','Team 1 centroid','Team 2 centroid','Distance of centroids');
            
            disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
            f(i) = getframe(f1);
            writeVideo(vidObj,f(i));

            pause(0.2)
            delete(p1t1(i))
            delete(p2t1(i))
            delete(p3t1(i))
            delete(p1t2(i))
            delete(p2t2(i))
            delete(p3t2(i))
            delete(pld)
        end
    close(f1)
    end
end






















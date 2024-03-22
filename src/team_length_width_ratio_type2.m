function [res] = team_length_width_ratio_type2(dataraw)
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
%   Calculating the team Width and Length

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
    teamMeanY = mean(PlayersMeanY);
    
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

    %%  Calculating Width and Length
    for i = 1:size(xdata,1)
    %   Width
        [Aminv(i,1) Aminp(i,:)] = min(ydata(i,:)); 
        [Amaxv(i,1) Amaxp(i,:)] = max(ydata(i,:));     

    %   Length 
        [Pminv(i,1) Pminp(i,:)] = min(xdata(i,:)); 
        [Pmaxv(i,1) Pmaxp(i,:)] = max(xdata(i,:));
        
    %   Calculating distances
    %   Width
        DistA(i,1) = pdist([xdata(i,Aminp(i,:)),ydata(i,Aminp(i,:));xdata(i,Amaxp(i,:)),ydata(i,Amaxp(i,:))],'euclidean');
    %   Length
        DistP(i,1) = pdist([xdata(i,Pminp(i,:)),ydata(i,Pminp(i,:));xdata(i,Pmaxp(i,:)),ydata(i,Pmaxp(i,:))],'euclidean');

    %   Calculating the LpW Ratio 
        LpWRatio(i,1) = DistP(i,1)/DistA(i,1);
    end

    %%  Results
    %   Width
    Amp_Mean = mean(DistA); 
    Amp_Median = median(DistA); 
    Amp_STD = std(DistA); 
    
    %   Length 
    Dep_Mean = mean(DistP);
    Dep_Median = median(DistP);
    Dep_STD = std(DistP);

    %   LPw Ratio
    LPwRatio_Mean = mean(LpWRatio); 
    LPwRatio_Median = median(LpWRatio);
    LPwRatio_STD = std(LpWRatio);

    %%  Creating and saving figure
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    campo
    hold on

    %   Calculating means to plot it
    %   Width
    [AminvMean,AminpMean] = min(PlayersMeanY); 
    [AmaxvMean,AmaxpMean] = max(PlayersMeanY);     
    %   Length 
    [PminvMean,PminpMean] = min(PlayersMeanX); 
    [PmaxvMean,PmaxpMean] = max(PlayersMeanX);

    %   Calculating distances
    %   Width
    DistAMean = pdist([PlayersMeanX(1,AminpMean),PlayersMeanY(1,AminpMean);PlayersMeanX(1,AmaxpMean),PlayersMeanY(1,AmaxpMean)],'euclidean');

    %   Length
    DistDMean = pdist([PlayersMeanX(1,PminpMean),PlayersMeanY(1,PminpMean);PlayersMeanX(1,PmaxpMean),PlayersMeanY(1,PmaxpMean)],'euclidean');   
    %   Ratio 
    RatioMean = DistDMean/DistAMean;

    %   Players
    p1 = plot(PlayersMeanX,PlayersMeanY,'ob','MarkerSize',5,'LineWidth',3);
    p2 = plot(teamMeanX,teamMeanY,'^b','MarkerSize',5,'LineWidth',3);
    %   Width
    p3 = plot([PlayersMeanX(:,AminpMean),PlayersMeanX(:,AmaxpMean)],[PlayersMeanY(:,AminpMean),PlayersMeanY(:,AmaxpMean)],'--r','LineWidth',2);
    %   Length
    p4 = plot([PlayersMeanX(:,PminpMean),PlayersMeanX(:,PmaxpMean)],[PlayersMeanY(:,PminpMean),PlayersMeanY(:,PmaxpMean)],'-r','LineWidth',2);

%     legend([p1,p2,p3,p4],{'Players','Team centroid','Width','Length'})
    legend([p1,p2,p3,p4],{'Jogadores','Centr�ide da Equipe','Largura','Comprimento'})
    title({ ['Width: ',num2str(DistAMean),' m'];...
            ['Length: ',num2str(DistDMean),' m'];...
            ['Ratio: ',num2str(RatioMean),' m']})
    set(gca,'XColor', 'none','YColor','none')
    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg')%,'-transparent'

    close (f1)

    %%  Saving results
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];
    
    res = [Amp_Mean Amp_Median Amp_STD Dep_Mean Dep_Median Dep_STD DistAMean DistDMean LPwRatio_Mean LPwRatio_Median LPwRatio_STD];
    
    tit = {'Mean Aplitude (m)','Median Width (m)','Width STD (m)',...
            'Mean Length (m)','Median Length (m)','Length STD (m)',...
            'Mean position Width (m)','Mean position Length (m)',...
            'MEan LpwRatio','Median LpwRatio','LpwRatio STD'};

    xlswrite(fname,tit,1,'A1')
    xlswrite(fname,res,1,'A2')
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
        for i = 1:size(xdata)
            p1(i) = plot(xdata(i,:),ydata(i,:),'ob','MarkerSize',5,'LineWidth',3);
            hold on
        %   Width
            p2(i) = plot([xdata(i,Aminp(i)),xdata(i,Amaxp(i))],[ydata(i,Aminp(i)),ydata(i,Amaxp(i))],'--r','LineWidth',2);
        %   Length
            p3(i) = plot([xdata(i,Pminp(i)),xdata(i,Pmaxp(i))],[ydata(i,Pminp(i)),ydata(i,Pmaxp(i))],':r','LineWidth',2);
            
            legend([p1(i),p2(i),p3(i)],'Players','Width','Length')
            title({['Width: ',num2str(DistA(i)),' m'];...
                ['Length: ',num2str(DistP(i)),' m'];...
                ['Ratio: ',num2str(LpWRatio(i)),' m']});

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


function [res] = TeamSeparateness(dataraw)
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
    %   Separating teams
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

    %%
    %   Team 1 
    %   Mean of position of each pleayser 
    PlayersMeanXt1 = mean(xdatat1,1);
    PlayersMeanYt1 = mean(ydatat1,1);
    
    %   Team Mean 
    teamMeanXt1 = mean(PlayersMeanXt1);
    teamMeanYt1 = mean(PlayersMeanYt1);
    
    %   Median of position of each pleayser
    PlayersMedianXt1 = median(xdatat1,1);
    PlayersMedianYt1 = median(ydatat1,1);

    %   Team Mean 
    teamMedianXt1 = median(PlayersMedianXt1);
    teamMedianYt1 = median(PlayersMedianYt1);   

    %   Team mean vector
    TMeanXt1 = mean(xdatat1,2); 
    TMeanYt1 = mean(ydatat1,2);
    TMeant1 = [TMeanXt1 TMeanYt1];

    %   Team median vector
    TMedianXt1 = median(xdatat1,2); 
    TMedianYt1 = median(ydatat1,2);
    TMediant1 = [TMedianXt1 TMedianYt1];

    %   Team 2 
    %   Mean of position of each pleayser 
    PlayersMeanXt2 = mean(xdatat2,1);
    PlayersMeanYt2 = mean(ydatat2,1);
    
    %   Team Mean 
    teamMeanXt2 = mean(PlayersMeanXt2);
    teamMeanYt2 = mean(PlayersMeanYt2);
    
    %   Median of position of each pleayser
    PlayersMedianXt2 = median(xdatat2,1);
    PlayersMedianYt2 = median(ydatat2,1);
    %   Team Mean 
    teamMedianXt2 = median(PlayersMedianXt2);
    teamMedianyt2 = median(PlayersMedianYt2);   

    %   Team mean vector
    TMeanXt2 = mean(xdatat2,2); 
    TMeanYt2 = mean(ydatat2,2);
    TMeant2 = [TMeanXt2 TMeanYt2];

    %   Team median vector
    TMedianXt2 = median(xdatat2,2); 
    TMedianYt2 = median(ydatat2,2);
    TMediant2 = [TMedianXt2 TMedianYt2];

    %%
    %   Calculating the Teamsï¿½ Separateness
    %   Team 1 to Team 2
    h1 =  waitbar(0,'Calculating distance between Team 1 of Team 2');
    set(h1,'name','Teams'' Separateness')
    for n = 1:size(xdatat1,2)
        clear minvt1t2
        clear minpt1t2
        clear matt1t2
        for a = 1:size(xdatat2,2)
            for i = 1:size(xdatat1,1)
                eval(['dist_T1toT2.P',num2str(n),'(i,a)= pdist([xdatat1(',num2str(i),',',num2str(n),'),ydatat1(',num2str(i),',',num2str(n),');xdatat2(',num2str(i),',',num2str(a),'),ydatat2(',num2str(i),',',num2str(a),')]);'])                
            end
        end

        for m = 1:size(xdatat1,1)
                eval(['matt1t2 = dist_T1toT2.P',num2str(n),';'])
                [minvt1t2(m) minpt1t2(m)] = min(matt1t2(m,:));
        end
        eval(['Min_PosT1toT2.P',num2str(n),' = [minvt1t2'' minpt1t2''];'])
        waitbar(n/size(xdatat1,2))
    end
    close(h1)

    %   Team 2 to Team 1 
    h2 =  waitbar(0,'Calculating distance between Team 2 of Team 1');
    set(h2,'name','Teams'' Separateness')
    for n = 1:size(xdatat2,2)
        clear minvt2t1
        clear minpt2t1
        clear matt2t1
        for a = 1:size(xdatat1,2)
            for i = 1:size(xdatat2,1)
                eval(['dist_T2toT1.P',num2str(n),'(i,a)= pdist([xdatat2(',num2str(i),',',num2str(n),'),ydatat2(',num2str(i),',',num2str(n),');xdatat1(',num2str(i),',',num2str(a),'),ydatat1(',num2str(i),',',num2str(a),')]);'])                
            end
        end
    for m = 1:size(xdatat2,1)
            eval(['matt2t1   = dist_T2toT1.P',num2str(n),';'])
            [minvt2t1(m) minpt2t1(m)] = min(matt2t1(m,:));
    end
    eval(['Min_PosT2toT1.P',num2str(n),' = [minvt2t1'' minpt2t1''];'])
    waitbar(n/size(xdatat2,2))
    end
    close(h2)

    %   Separating results
    mat1t2 = numel(fieldnames(Min_PosT1toT2));
    mat2t1 = numel(fieldnames(Min_PosT2toT1));
    %   Team 1
    for t = 1:mat1t2
        eval(['matresMint1t2(:,',num2str(t),') = Min_PosT1toT2.P',num2str(t),'(:,1);'])
        eval(['matresPost1t2(:,',num2str(t),') = Min_PosT1toT2.P',num2str(t),'(:,2);'])      
    end

    TS_t1t2_AllMean = mean(matresMint1t2,2); 
    TS_t1t2_AllMedian = median(matresMint1t2,2); 
    TS_t1t2_AllSum = sum(matresMint1t2,2); 

    TS_t1t2_mean = mean(TS_t1t2_AllMean);
    TS_t1t2_median = median(TS_t1t2_AllMedian);
    TS_t1t2_SumMean = mean(TS_t1t2_AllSum);
    TS_t1t2_SumMedian = median(TS_t1t2_AllSum); 
    TS_t1t2_std = std(std(matresMint1t2));

    %   Team 2
    for t = 1:mat2t1
        eval(['matresMint2t1(:,',num2str(t),') = Min_PosT2toT1.P',num2str(t),'(:,1);'])
        eval(['matresPost2t1(:,',num2str(t),') = Min_PosT2toT1.P',num2str(t),'(:,2);'])      
    end
    TS_t2t1_AllMean = mean(matresMint2t1,2); 
    TS_t2t1_AllMedian = median(matresMint2t1,2);
    TS_t2t1_AllSum = sum(matresMint2t1,2); 

    TS_t2t1_mean = mean(TS_t2t1_AllMean);
    TS_t2t1_median = median(TS_t2t1_AllMedian);
    TS_t2t1_SumMean = mean(TS_t2t1_AllSum);
    TS_t2t1_SumMedian = median(TS_t2t1_AllSum); 
    TS_t2t1_std = std(std(matresMint2t1));

    %   Results
    res = [TS_t1t2_mean TS_t1t2_median TS_t1t2_std TS_t1t2_SumMean TS_t1t2_SumMedian TS_t2t1_mean TS_t2t1_median TS_t2t1_std TS_t2t1_SumMean TS_t2t1_SumMedian];
    
    %% 
    %   Saving results 
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];

    tit1 = {'Team 1','Team 2','TS - T1 to T2',' ',' ',' ',' ','TS - T2 to T1'};
    tit2 = {'TS-Mean (m)', 'TS-Median (m)', 'TS-STD (m)','Sum - Mean (m)','Sum - Median (m)', 'TS-Mean (m)', 'TS-Median (m)', 'TS-STD (m)','Sum - Mean (m)','Sum - Median (m)'};   
    
    xlswrite(fname,playt1,1,'A2')
    xlswrite(fname,playt2,1,'B2')
    xlswrite(fname,tit1,1,'A1')
    xlswrite(fname,tit2,1,'C2')
    xlswrite(fname,res,1,'C3')
    %   Sheet's name
    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp(1:end));
    ewb.Save 
    ewb.Close(false)

    %%  Creating and saving figure
    %   Figure 1 (field)
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    campo
    hold on
    %     axis off;
    
    %   Team 1
    p1 = plot(PlayersMeanXt1,PlayersMeanYt1,'ob','MarkerSize',5,'LineWidth',5);

    %   Team 2
    p2 = plot(PlayersMeanXt2,PlayersMeanYt2,'or','MarkerSize',5,'LineWidth',5);

    %   Calculating TS of the mean positions 
    matMeant1 = [PlayersMeanXt1' PlayersMeanYt1']; 
    matMeant2 = [PlayersMeanXt2' PlayersMeanYt2'];

    %   Team 1 to Team 2
    for i = 1:size(matMeant1)
        for a = 1:size(matMeant2,1)
                eval(['distMean_T1toT2.P',num2str(i),'(1,a) = pdist([matMeant1(i,1) matMeant1(i,2);matMeant2(a,1) matMeant2(a,2)]);'])
        end
    end
    for m = 1:size(matMeant1,1)
            eval(['Meanmatt1t2   = distMean_T1toT2.P',num2str(m),';'])
            [Meanminvt1t2(m,1) Meanminpt1t2(m,1)] = min(Meanmatt1t2);
    end

    %   Team 2 to Team 1
    for i = 1:size(matMeant2)
        for a = 1:size(matMeant1,1)
                eval(['distMean_T2toT1.P',num2str(i),'(1,a) = pdist([matMeant2(i,1) matMeant2(i,2);matMeant1(a,1) matMeant1(a,2)]);'])
        end
    end
    for m = 1:size(matMeant2,1)
            eval(['Meanmatt2t1   = distMean_T2toT1.P',num2str(m),';'])
            [Meanminvt2t1(m,1) Meanminpt2t1(m,1)] = min(Meanmatt2t1);
    end

    %   Plotting lines 
    %   Team 1
    for i = 1:size(matMeant1)
        p3 = plot([matMeant1(i,1) matMeant2(Meanminpt1t2(i),1)],[matMeant1(i,2) matMeant2(Meanminpt1t2(i),2)],'LineWidth',1.5,'Color','k','LineStyle',':');
    end
    %   Team 2
    for i = 1:size(matMeant2)
        p3 = plot([matMeant2(i,1) matMeant1(Meanminpt2t1(i),1)],[matMeant2(i,2) matMeant1(Meanminpt2t1(i),2)],'LineWidth',1.5,'Color','r','LineStyle',':');
    end

    legend([p1,p2,p3],'Team 1','Team 2','TS')
    title({'Distance';['Team 1: ',num2str(TS_t1t2_mean),' m'];...
            ['Team 2: ',num2str(TS_t2t1_mean),' m']})

    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg')%,'-transparent')
    close(f1)

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
    for i = 1:size(xdatat1,1)
        %   Team 1
        p1(i) = plot(xdatat1(i,:),ydatat1(i,:),'ob','MarkerSize',5,'LineWidth',3);
        mat1 = [xdatat1(i,:)',ydatat1(i,:)'];

        %   Team 2
        p2(i) = plot(xdatat2(i,:),ydatat2(i,:),'or','MarkerSize',5,'LineWidth',3);
        mat2 = [xdatat2(i,:)',ydatat2(i,:)'];
        
        %   Team 1 lines
        for z = 1:size(mat1,1)
            eval(['p3(z) = plot([mat1(z,1), mat2(Min_PosT1toT2.P',num2str(z),'(i,2),1)],[mat1(z,2) mat2(Min_PosT1toT2.P',num2str(z),'(i,2),2)],''k:'');'])
            set(p3(z),'LineWidth',1.5)
            eval(['v = num2str(Min_PosT1toT2.P',num2str(z),'(i,1));'])
            t1(z) = text(mat1(z,1)+0.7, mat1(z,2),v);
        end
        %   Team 2 lines
        for z = 1:size(mat2,1)
            eval(['p4(z) = plot([mat2(z,1), mat1(Min_PosT2toT1.P',num2str(z),'(i,2),1)],[mat2(z,2) mat1(Min_PosT2toT1.P',num2str(z),'(i,2),2)],''r:'');'])
            set(p4(z),'LineWidth',1.5)
            eval(['v = num2str(Min_PosT2toT1.P',num2str(z),'(i,1));'])
            t2(z) = text(mat2(z,1)+0.7, mat2(z,2),v);
        end
        
        legend([p1(i),p2(i)],'Team 1','Team 2')
        title({'Teams'' Separateness (TS)';['Team 1: ',num2str(TS_t2t1_AllSum(i)),' m'];...
            [    'Team 2: ',num2str(TS_t1t2_AllSum(i)),' m']})

        disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
        f(i) = getframe(f1);
        writeVideo(vidObj,f(i));

        pause(0.25)
        delete(p1(i))
        delete(p2(i))
        delete(p3)
        delete(p4)
        delete(t1)
        delete(t2)
        end
    close(f1)
    end
end


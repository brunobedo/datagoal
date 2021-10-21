function [LinearIndividualRes] = LinearIndividualAnalysis(rawdata)
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
%   Linear Individual Analysis

global selections

        dirsave = selections.Gamedir;
        mkdir([dirsave filesep 'Results'])
        sects = fieldnames(selections.PlayersList); 
        prompt = {'Enter file name:'};
        dlgtitle = 'Input title';
        definput = {['Linear_Individual_Res_',selections.GamePathName]};%'.csv'
        titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));

    for i = 1:size(sects)
        sct = sects{i};
        eval(['nplay = selections.PlayersList.',sct,';'])
        disp(' ')
        disp(['Performing linear analysis: ',sct])
        
        for d = 1:size(nplay)
            disp(['Processing: ',nplay{d}])
            clear data
            eval(['data = rawdata.',sct,'{',num2str(d),',1};']);
            
            datap = data(:,2:3);
            diffdat = diff(datap(:,1:end));
            normdat = NaN(size(diffdat,1),1);

        for a = 1:size(diffdat,1) 
            normdat(a,:) = norm(diffdat(a,:));
        end
        
%       Time Vector
        vtemp = [(0:size(normdat,1)-1)/str2double(selections.FreqAc)]'; 
        vtempm = vtemp./60; 
        
%       Distance (meters)
        dist_total = sum(normdat); 

%       Velocity (m/s)
        veldat = normdat / (1/str2double(selections.FreqAc));
        med_vel = mean(veldat)*3.6;                 %   Average velocity(k/h)
        max_vel = max(veldat)*3.6;                  %   Max Velocity (k/h)
        
%       Aceleration (m.s^2)
        diffveldat = diff(veldat);
        aceldat = diffveldat / (1/str2double(selections.FreqAc));
        aceldat = [NaN;aceldat];
        acelmax = max(aceldat); 
        desamax = min(aceldat); 

%       Distance in high acceleration
        ace_faixa1 = find((aceldat) >= 2); % Alta acceleration
        dist_HighAcceleration= sum(normdat(ace_faixa1)); %Distance (m) 
        n_ace_local = diff(ace_faixa1)~=1;
        n_aceleration = [sum(n_ace_local(:) == 1)+1];
        
        des_faixa2 = find((aceldat) <= -2); % Alta deceleration
        dist_HighDesAceleration = sum(normdat(des_faixa2)); %Distance (m)
        n_desa_local = diff(des_faixa2)~=1;
        n_desaaceleration = [sum(n_desa_local(:) == 1)+1];  

        
%       Distance in different speed ranges (meters)
        velrange1 = find(0       <= veldat & veldat <= (7.1/3.6));      % 0-7.1 km�h-1 (walking), 
        velrange2 = find((7.2/3.6) <  veldat & veldat <= (14.399/3.6)); % 7.2-14.3 km�h-1 (low-speed running - LSR)
        velrange3 = find((14.4/3.6)<  veldat & veldat <= (19.79/3.6));  % 14.4-19.7km�h-1 (moderate-speed running - MSR)
        velrange4 = find((19.9/3.6)<  veldat & veldat <= (25.2/3.6));   % 19.8-25.2 km�h-1 (high-speed running - HSR)
        velrange5 = find(veldat > (25.21/3.6) );                        % >25.2 km�h-1 (sprinting - SPR);
                                                                        % >14.4 km�h-1 (high-intensity activities - HIA)
                                                                        % - >19.8 km�h-1 (very-high-intensity activities - VHIA) 

%       Number of sprints 
        n_s_local = diff(velrange5)~=1;
        n_sprints_pre = sum(n_s_local(:) == 1);
        if n_sprints_pre ~= 0 
            n_sprints = n_sprints_pre +1;
        else
            n_sprints = 0;
        end 
        
%       Distance in differenc speed ranges (meters)
        d_range1 = sum(normdat(velrange1));
        d_range2 = sum(normdat(velrange2));
        d_range3 = sum(normdat(velrange3));
        d_range4 = sum(normdat(velrange4));
        d_range5 = sum(normdat(velrange5));
        d_range6 = sum([d_range4,d_range5]);
        
%       Calculating moving averages
        M = [1 3 5]; 
%         vtime = (0:size(veldat,1)-1)./(str2double(selections.FreqAc))';
        
        for r = 1:size(M,2)
            m1s = M(r);
            m1m = m1s*(60*str2double(selections.FreqAc));
            
            if m1m >= size(vtemp,1)
                    % TD  
                    eval(['dist_TD_',num2str(m1s),'m(1,1) = sum(normdat);']) 
                    
                    % VHIA               
                    vetVHIA = find(veldat >= (19.8/3.6));
                    eval(['dist_VHIA_',num2str(m1s),'m(1,1) = sum(normdat(vetVHIA));'])

    %               % ACC
                    vetACC = find(aceldat >= 2);
                    eval(['dist_ACC_',num2str(m1s),'m(1,1) = sum(normdat(vetACC));'])

    %               % DES
                    vetDES = find(aceldat <= -2);
                    eval(['dist_DES_',num2str(m1s),'m(1,1) = sum(normdat(vetDES));'])                    
            else
                for u = 1:size(vtemp,1)-m1m
    %         disp(' ')
    %         disp(['First frame: ',num2str(u)])
    %         disp(['last frame: ',num2str(u+m1m)])
    %         
                    % TD  
                    eval(['dist_TD_',num2str(m1s),'m(u,1) = sum(normdat(u:u+m1m));'])  

                    % VHIA               
                    vetVHIA = find(veldat(u:u+m1m) >= (19.8/3.6));
                    eval(['dist_VHIA_',num2str(m1s),'m(u,1) = sum(normdat(vetVHIA));'])

    %               % ACC
                    vetACC = find(aceldat(u:u+m1m) >= 2);
                    eval(['dist_ACC_',num2str(m1s),'m(u,1) = sum(normdat(vetACC));'])

    %               % DES
                    vetDES = find(aceldat(u:u+m1m) <= -2);
                    eval(['dist_DES_',num2str(m1s),'m(u,1) = sum(normdat(vetDES));'])

                end
            end
            eval(['res_dist_TD_VHIA(r,:) = [max(dist_TD_',num2str(m1s),'m), max(dist_VHIA_',num2str(m1s),'m)];'])
            eval(['res_dist_ACC(r,:) = [max(dist_ACC_',num2str(m1s),'m), max(dist_ACC_',num2str(m1s),'m)];'])
            eval(['res_dist_DES(r,:) = [max(dist_DES_',num2str(m1s),'m), max(dist_DES_',num2str(m1s),'m)];'])
        end
        
%       Player Major Range 
        [ave,sco,ava]=pca([datap(:,1),datap(:,2)]); % Calculating PCA
        sv2=sqrt(ava(2,1));
        sv1=sqrt(ava(1,1));
        
        ave1=ave(:,1); % To be used on figures
        ave2=ave(:,2); % To be used on figures
        
        dist_x=sv1; % Horizontal distance 
        dist_y=sv2; % Longitudinal distance
        
        area=pi*sv1*sv2; % Area 
        
        res_PMR = [dist_x,dist_y,area];     % Player Major Range Results (distances X, distance Y and Ellipse Area)
        
%       Results
        res_mov_ave = [ max(dist_TD_1m) max(dist_TD_3m) max(dist_TD_5m) max(dist_VHIA_1m) max(dist_VHIA_3m) max(dist_VHIA_5m),...
                        max(dist_ACC_1m) max(dist_ACC_3m) max(dist_ACC_5m) max(dist_DES_1m) max(dist_DES_3m) max(dist_DES_5m)];
                    
        tit = {'Name','Total distance','Mean velocity','Max Velocity','Max Acel','Max Desacel','Distance walking'...
               'Dist. low-speed running - LSR.','Dist. Mmoderate-speed running - MSR','Dist. high-speed running - HSR','Dst. sprinting - SPR',...
               'Dist. HSR + SPR','N� Sprints',...
               'Distance high acceleration','Distance high deceleration',...
               'Moving Average Distance 1min TD','Moving Average Distance 3min TD','Moving Average Distance 5min TD',...
               'Moving Average Distance 1min VHIA','Moving Average Distance 3min VHIA','Moving Average Distance 5min VHIA',...
               'Moving Average Distance 1min ACC','Moving Average Distance 3min ACC','Moving Average Distance 5min ACC',...
               'Moving Average Distance 1min DES','Moving Average Distance 3min DES','Moving Average Distance 5min DES',...
               'Ellipse Distance X(m)','Ellipse Distance Y(m)','Ellipse Area','Number of Acceleration','Number of Deceleration'}; 
        res = [dist_total,med_vel,max_vel,acelmax,desamax,d_range1,d_range2,d_range3,d_range4,d_range5,d_range6...
               n_sprints,dist_HighAcceleration,dist_HighDesAceleration,res_mov_ave,res_PMR,n_aceleration,n_desaaceleration];
        
        eval([sct,'_LinearIndividual{',num2str(d),',1} = res;'])
        eval(['LinearIndividualRes.',sct,'=[',sct,'_LinearIndividual];'])
        
%       Saving results (.csv)
        fname = [dirsave filesep 'Results' filesep titfil];
        warning off
        p = strfind(nplay{d},'.');
        p1 = nplay{d}(1:p(end)-1);
        xlswrite(fname,tit,i,'A1')
        xlswrite(fname,{p1},i,['A',num2str(d+1)])
        xlswrite(fname,res,i,['B',num2str(d+1)])

%       Sheet's name
        e = actxserver('Excel.Application');
        ewb = e.Workbooks.Open(fname);
        ewb.Worksheets.Item(i).Name = char(sct);
        ewb.Save 
        ewb.Close(false)   

%       Creating and saving figures

        %   Figure 1 - Displacement in the field
        f1 = figure(1); clf; set(f1,'name','Displacement','units','normalized','outerposition',[0 0 1 1])
        campo;
        set(gca,'XColor', 'none','YColor','none')
        plot(datap(:,1),datap(:,2),'r','LineWidth',2);
        ppname = strrep(nplay{d}(1:p(end)-1),'_',' - ');
        title({[char(sct),' - ',ppname];[num2str(dist_total),' meters']});
        titsavef1 = ['Distance_',nplay{d}(1:p(end)-1)];
        export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg') %'-transparent'
        pause(1)
        
        
        %   Figure 2 - Velocity by ranges
        f2 = figure(2); clf; hold on; set(f2,'Name','Velocity','units','normalized','outerposition',[0 0 1 1])
        plot(vtempm,veldat,'LineWidth',0.5,'Color','k')

        xlabel ('Time (min)'); ylabel ('Faixas de velocidade (m/s)')
        line ([0 max(vtempm)],[7.1/3.6 7.1/3.6],'LineWidth',1.5,'Color','k','LineStyle','- -');
        line ([0 max(vtempm)],[14.3/3.6 14.3/3.6],'LineWidth',1.5,'Color','k','LineStyle','- -');
        line ([0 max(vtempm)],[19.7/3.6 19.7/3.6],'LineWidth',1.5,'Color','k','LineStyle','- -');
        line ([0 max(vtempm)],[25.2/3.6 25.2/3.6],'LineWidth',1.5,'Color','k','LineStyle','- -');
        
        p_vel_f1 = plot (vtempm(velrange1),veldat(velrange1),'.','Color','b','MarkerSize',7);
        p_vel_f2 = plot (vtempm(velrange2),veldat(velrange2),'.','Color','r','MarkerSize',7);
        p_vel_f3 = plot (vtempm(velrange3),veldat(velrange3),'.','Color','m','MarkerSize',7);
        p_vel_f4 = plot (vtempm(velrange4),veldat(velrange4),'.','Color','c','MarkerSize',7);
        p_vel_f5 = plot (vtempm(velrange5),veldat(velrange5),'.','Color','g','MarkerSize',7);
        
        title({'Velocity ranges' ; ppname})
        legend ([ p_vel_f1  p_vel_f2  p_vel_f3  p_vel_f4  p_vel_f5],...
        ['Walking 0 a 7.1 km.h^-^1'],...
        ['Low intensity Running 7.2 a 14.3 km.h^-^1'],...
        ['Moderate intensity Running  14.4 a 19.7 km.h^-^1'],...
        ['High intensity Running 19.8 a 25.2 km.h^-^1'],...
        ['Sprinting > 25.2 km.h^-^1']);
    
        titsavef2 = ['Velocity_',nplay{d}(1:p(end)-1)];
        export_fig([dirsave filesep 'Results' filesep titsavef2],'-jpg') %'-transparent'
        pause(1)

        %   Figure 3 - Heat Map
        f3 = figure(3); clf; hold on; set(f3,'Name','Heat Map','units','normalized','outerposition',[0 0 1 1])
        [res]=heatmap(datap);
        title({['Heat map'];[char(sct),' - ',ppname]});
        titsavef4 = ['HeatMap_',nplay{d}(1:p(end)-1)];
        export_fig([dirsave filesep 'Results' filesep titsavef4],'-jpg')
        pause(1)

        %   Figure 4 - Player Major Range
        f4 = figure(4); clf; hold on; set(f4,'Name','Player Major Range','units','normalized','outerposition',[0 0 1 1])
        title({['Player Major Range'];[char(sct),' - ',ppname];['Dist. Comprimento : ',num2str(round(dist_x,2)),' m | Dist. Largura : ',...
                num2str(round(dist_y,2)),' m | Area: ',num2str(round(area),3),' m^2']});
        campo
        hold on
        set(gca,'XTick',[], 'YTick', [],'XColor','none','YColor','none')

        p1_f4 =  plot(datap(:,1),datap(:,2),'r--','LineWidth',0.5);
        xCenter = mean(datap(:,1));
        yCenter = mean(datap(:,2));
        
        if ave(2,1)<=0
            ave(1,1)=ave(1,1)*-1;
            
            % Ellipse rotation
            giro=-acos(ave(1)); % Calculating angle (�) of ellipse rotation
            ex=sv1;             % X axis
            ey=sv2;             % T axis
            
            x=(-ex):0.0001:(ex);
            ysup = ey.*sqrt( 1-((x)/ex).^2 );
            yinf = -ey.*sqrt( 1-((x)/ex).^2 );
            
            
            % Ellipse rotation
            x1= x.*cos(giro) + ysup.*sin(giro);
            x2= x.*cos(-giro) + ysup.*sin(-giro);
            ysup1= -x.*sin(giro) + ysup.*cos(giro);
            yinf1= -x.*sin(giro) - ysup.*cos(giro);
            
            % Rotating ellipse
            p2_f4 = plot(x1+xCenter,ysup1+yCenter,'b','LineWidth',2);
            p3_f4 = plot(x2+xCenter,yinf1+yCenter,'b','LineWidth',2);
            
            p2_f4 = plot([xCenter;(-sv2*ave1(2))+xCenter],[yCenter;(sv2*ave1(1))+yCenter],'--k','LineWidth',2);
            p3_f4 = plot([xCenter;(sv1*ave2(2))+xCenter],[yCenter;(-sv1*ave2(1))+yCenter],'--k','LineWidth',2);
            p4_f4 = plot([xCenter;(-sv1*ave2(2))+xCenter],[yCenter;(sv1*ave2(1))+yCenter],'--k','LineWidth',2);
            p5_f4 = plot([xCenter;(sv2*ave1(2))+xCenter],[yCenter;(-sv2*ave1(1))+yCenter],'--k','LineWidth',2);
            
        else
            % Ellipse rotation
            giro=-acos(ave(1)); % Calculating angle (�) of ellipse rotation
            ex=sv1;             % X axis
            ey=sv2;             % T axis
            
            x=(-ex):0.0001:(ex);
            ysup = ey.*sqrt( 1-((x)/ex).^2 );
            yinf = -ey.*sqrt( 1-((x)/ex).^2 );
            
            % Ellipse rotation
            x1= x.*cos(giro) + ysup.*sin(giro);
            x2= x.*cos(-giro) + ysup.*sin(-giro);
            ysup1= -x.*sin(giro) + ysup.*cos(giro);
            yinf1= -x.*sin(giro) - ysup.*cos(giro);
            
            % Rotating ellipse
            plot(x1+xCenter,ysup1+yCenter,'b','LineWidth',2);
            plot(x2+xCenter,yinf1+yCenter,'b','LineWidth',2);
            
            p2_f4 = plot([xCenter;(-sv2*ave1(2))+xCenter],[yCenter;(sv2*ave1(1))+yCenter],'--k','LineWidth',2);
            p3_f4 = plot([xCenter;(sv1*ave2(2))+xCenter],[yCenter;(-sv1*ave2(1))+yCenter],'--k','LineWidth',2);
            p4_f4 = plot([xCenter;(-sv1*ave2(2))+xCenter],[yCenter;(sv1*ave2(1))+yCenter],'--k','LineWidth',2);
            p5_f4 = plot([xCenter;(sv2*ave1(2))+xCenter],[yCenter;(-sv2*ave1(1))+yCenter],'--k','LineWidth',2);          
        end
        p6_f4 = plot(xCenter,yCenter,'ro','MarkerSize',5,'LineWidth',2);
        titsavef5 = ['PlayerMajorRange_',nplay{d}(1:p(end)-1)];
        export_fig([dirsave filesep 'Results' filesep titsavef5],'-jpg') %,'-transparent'
        pause(1)
        
        %   Figure 5 - Arrows during sprinting
        % Find gaps to draw arrows
        Ra = velrange5;
        f5 = figure(6); clf; hold on; set(f5,'Name','Arrows during sprinting','units','normalized','outerposition',[0 0 1 1])
        campo;
        set(gca,'XColor', 'none','YColor','none')
        hold on
        set(gca,'XTick',[], 'YTick', [],'XColor','none','YColor','none')
%         p1_f5 =  plot(datap(:,1),datap(:,2),'k.','MarkerSize',0.05);
        if size(Ra,1)>=1
            gaps = find(n_s_local(:) == 1);
            clear gapsspm
            for q = 1:n_sprints
                if size(gaps,1) == 0
                    gapsspm(q,:) = [Ra(1,1) Ra(end,1)];
                elseif size(gaps,1) >= 1
                    if q == 1
                        gapsspm(q,:) = [Ra(1,1) Ra(gaps(q),1)];
                    elseif q == n_sprints
                        gapsspm(q,:) = [Ra(gaps(q-1)+1,1) Ra(end,1)];
                    else
                        gapsspm(q,:) = [Ra(gaps(q-1)+1,1) Ra(gaps(q),1)];
                    end
                end
                p1 = datap(gapsspm(q,1),:);
                p2 = datap(gapsspm(q,2),:);
                dp = p2-p1;
                p6_f5(q,1) = quiver(p1(1),p1(2),dp(1),dp(2),0,'r','LineWidth',2,'MaxHeadSize',1.5);
                dist_t = sum(normdat(gapsspm(q,1):gapsspm(q,2)));
                t61(q,1) = text(p2(1,1),p2(1,2)+2,[num2str(round(dist_t,2)),' m'],'Color','Blue','FontWeight','bold','FontSize',20);
                title({['Sprints direction'];[char(sct),' - ',ppname];['The athlete peformed ', num2str(round(d_range5,2)),' m sprinting']});
                legend ([p6_f5(1,1)],'Dire��o e Dist�ncia do Sprint')
            end
           
        else
            title({['Sprints'];[char(sct),' - ',ppname];['The athlete has not sprinted']});
        end
        
        titsavef6 = ['SprintArrows_',nplay{d}(1:p(end)-1)];
        export_fig([dirsave filesep 'Results' filesep titsavef6],'-jpg') %,'-transparent'
        pause(1)

        %   Figure 6 - etc...
%         f5 = figure(6); clf; hold on; set(f6,'Name','Player Major Range','units','normalized','outerposition',[0 0 1 1])
        close (f1)
        close (f2)  
        close (f3)
        close (f4)
        close (f5)

        end
    end
end


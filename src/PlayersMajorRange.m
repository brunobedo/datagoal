function [res] = PlayersMajorRange(dataraw)
%   Players' Major Range
%   Author: Bruno Luiz Souza Bedo
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
    
%   Median of position of each player
    PlayersMedianX = median(xdata,1);
    PlayersMedianY = median(ydata,1);

%   Team Mean 
    teamMedianX = median(PlayersMedianX);
    teamMediany = median(PlayersMedianY);   

%   Team mean vector
    TMeanX = mean(xdata,2); 
    TMeanY = mean(ydata,2);
    TMean = [TMeanX TMeanY];

%%  Saving results
%   File name
t1 = {'Name','Mean X','Mean Y','Median X','Median Y','STD X','STD Y','Dist X','Dist Y','Area'};
t2 = players; 

%%
%   Calculating the Players' Major Range
%   Standard deviation of ach player 
    PlayersSTDX = std(xdata,1);
    PlayersSTDY = std(ydata,1);

res1 = [PlayersMeanX' PlayersMeanY' PlayersMedianX' PlayersMedianY' PlayersSTDX' PlayersSTDY']; 


%%  Creating figure
    titsavef1 = ['Field_',selections.ColLinTyp];
    f1 = figure(1); clf; set(f1,'name','Players position','units','normalized','outerposition',[0 0 1 1])
    campo
    hold on
%     axis off
    p1 = plot(PlayersMeanX,PlayersMeanY,'or','MarkerSize',5,'LineWidth',3);

%   Calculating ellipse, area and distance. 
    for i = 1:size(PlayersMeanX,2)
        [ave,sco,ava]=pca([xdata(:,i),ydata(:,i)]); % Calculating PCA
        sv2=sqrt(ava(2,1));
        sv1=sqrt(ava(1,1));
        
        dist_x=sv1; % Horizontal distance 
        dist_y=sv2; % Longitudinal distance
        
        area=pi*sv1*sv2; % Area 
        
        ave1=ave(:,1);
        ave2=ave(:,2);
        
        xCenter = PlayersMeanX(i);
        yCenter = PlayersMeanY(i);        
        
        if ave(2,1)<=0
            ave(1,1)=ave(1,1)*-1;
            
            % Ellipse rotation
            giro=-acos(ave(1)); % Calculating angle (º) of ellipse rotation
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
            p2 = plot(x1+xCenter,ysup1+yCenter,'b','LineWidth',1);
            p3 = plot(x2+xCenter,yinf1+yCenter,'b','LineWidth',1);
            
            p4 = plot([xCenter;(-sv2*ave1(2))+xCenter],[yCenter;(sv2*ave1(1))+yCenter],':k','LineWidth',1.5);
            p5 = plot([xCenter;(sv1*ave2(2))+xCenter],[yCenter;(-sv1*ave2(1))+yCenter],':k','LineWidth',1.5);
            p6 = plot([xCenter;(-sv1*ave2(2))+xCenter],[yCenter;(sv1*ave2(1))+yCenter],':k','LineWidth',1.5);
            p7 = plot([xCenter;(sv2*ave1(2))+xCenter],[yCenter;(-sv2*ave1(1))+yCenter],':k','LineWidth',1.5);
            
        else
            % Ellipse rotation
            giro=-acos(ave(1)); % Calculating angle (º) of ellipse rotation
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
            plot(x1+xCenter,ysup1+yCenter,'b','LineWidth',1);
            plot(x2+xCenter,yinf1+yCenter,'b','LineWidth',1);
            
            p2 = plot([xCenter;(-sv2*ave1(2))+xCenter],[yCenter;(sv2*ave1(1))+yCenter],':k','LineWidth',1.5);
            p3 = plot([xCenter;(sv1*ave2(2))+xCenter],[yCenter;(-sv1*ave2(1))+yCenter],':k','LineWidth',1.5);
            p4 = plot([xCenter;(-sv1*ave2(2))+xCenter],[yCenter;(sv1*ave2(1))+yCenter],':k','LineWidth',1.5);
            p5 = plot([xCenter;(sv2*ave1(2))+xCenter],[yCenter;(-sv2*ave1(1))+yCenter],':k','LineWidth',1.5);          
        end
     
     % Matri of results      
     res2 = res1(i,:);
     res(i,:) = [res2,dist_x,dist_y,area]';
    end
    
    
    title({'Players'' Major Range (PMJ)';['X-axis: ',num2str(mean(PlayersSTDX)),' m'];...
           ['Y-axis: ',num2str(mean(PlayersSTDY)),' m']})
    legend([p1,p2],'Players','PMJ')

    export_fig([dirsave filesep 'Results' filesep titsavef1],'-jpg')%,'-transparent')
close (f1)

%%   Saving 
    prompt = {'Enter file name:'};
    dlgtitle = 'Input title';
    definput = {['Linear_Collective_Res_',selections.ColLinTyp]};%'.csv'
    titfil = char(inputdlg(prompt,dlgtitle,[1 60],definput));
    fname = [dirsave filesep 'Results' filesep titfil];

    xlswrite(fname,t1,1,'A1')
    xlswrite(fname,t2,1,'A2')
    xlswrite(fname,res,1,'B2')

    e = actxserver('Excel.Application');
    ewb = e.Workbooks.Open(fname);
    ewb.Worksheets.Item(1).Name = char(selections.ColLinTyp);
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
for i = 1:size(xdata,1)
    p1(i) = plot(xdata(i,:),ydata(i,:),'or','MarkerSize',5,'LineWidth',3);
    for p = 1:size(xdata,2)
        
        if i > 2
        [ave,sco,ava]=pca([xdata(1:i,p),ydata(1:i,p)]); % Calculating PCA
        sv2=sqrt(ava(2,1));
        sv1=sqrt(ava(1,1));
        
        dist_x=sv1; % Horizontal distance 
        dist_y=sv2; % Longitudinal distance
        
        area=pi*sv1*sv2; % Area 
        
        ave1=ave(:,1);
        ave2=ave(:,2);
        
        xCenter = xdata(i,p);
        yCenter = ydata(i,p);
        
        if ave(2,1)<=0
            ave(1,1)=ave(1,1)*-1;
            
            % Ellipse rotation
            giro=-acos(ave(1)); % Calculating angle (º) of ellipse rotation
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
            p2(p) = plot(x1+xCenter,ysup1+yCenter,'b','LineWidth',1);
            p3(p) = plot(x2+xCenter,yinf1+yCenter,'b','LineWidth',1);
            
            p4(p) = plot([xCenter;(-sv2*ave1(2))+xCenter],[yCenter;(sv2*ave1(1))+yCenter],':k','LineWidth',1.5);
            p5(p) = plot([xCenter;(sv1*ave2(2))+xCenter],[yCenter;(-sv1*ave2(1))+yCenter],':k','LineWidth',1.5);
            p6(p) = plot([xCenter;(-sv1*ave2(2))+xCenter],[yCenter;(sv1*ave2(1))+yCenter],':k','LineWidth',1.5);
            p7(p) = plot([xCenter;(sv2*ave1(2))+xCenter],[yCenter;(-sv2*ave1(1))+yCenter],':k','LineWidth',1.5);
            
        else
            % Ellipse rotation
            giro=-acos(ave(1)); % Calculating angle (º) of ellipse rotation
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
            p2(p) = plot(x1+xdata(i,p),ysup1+ydata(i,p),'b','LineWidth',1);
            p3(p) = plot(x2+xdata(i,p),yinf1+ydata(i,p),'b','LineWidth',1);
           
            p4(p) = plot([xdata(i,p);(-sv2*ave1(2))+xdata(i,p)],[ydata(i,p);(sv2*ave1(1))+ydata(i,p)],':k','LineWidth',1.5);
            p5(p) = plot([xdata(i,p);(sv1*ave2(2))+xdata(i,p)],[ydata(i,p);(-sv1*ave2(1))+ydata(i,p)],':k','LineWidth',1.5);
            p6(p) = plot([xdata(i,p);(-sv1*ave2(2))+xdata(i,p)],[ydata(i,p);(sv1*ave2(1))+ydata(i,p)],':k','LineWidth',1.5);
            p7(p) = plot([xdata(i,p);(sv2*ave1(2))+xdata(i,p)],[ydata(i,p);(-sv2*ave1(1))+ydata(i,p)],':k','LineWidth',1.5);          
        end

        
    title({'Players'' Major Range (PMJ)';['Team X-axis: ',num2str(mean(std(xdata(1:i,:)))),' m'];...
           ['Team Y-axis: ',num2str(mean(std(ydata(1:i,:)))),' m']})
    legend([p1(i),p2(p)],'Players','PMJ')
        end
    end
disp(['Processing: Frame ',num2str(i),' of ',num2str(size(xdata,1))])
f(i) = getframe(f1);
writeVideo(vidObj,f(i));

delete(p1)
delete(p2)
delete(p3)
delete(p4)
delete(p5)
delete(p6)
delete(p7)

end
close(f1)
end

end


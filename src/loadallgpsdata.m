function [allGPSdata] = loadallgpsdata(matcalib,timeS,timeF,freq,lowpass)
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
%   This functions load all GPS raw data
    global selections 

    if strcmp(selections.GPSType,'Dvideo')
        timeIs = (str2double(timeS)*60);
        timeFs = (str2double(timeF)*60);
    else
        timeS_String = timeS;
        timeF_String = timeF;
        timeS = datevec(timeS); 
        timeIs = (timeS(:,4)*3600) + (timeS(:,5)*60) +timeS(:,6); 
        timeF = datevec(timeF);
        timeFs = (timeF(:,4)*3600) + (timeF(:,5)*60) +timeF(:,6); 
    end
    
    selections.totalGametime = num2str((timeFs-timeIs)/60); % Tempo total de jogo em minutos
    
    sects = fieldnames(selections.PlayersList); 
    h1 =  waitbar(0,'Loading GPS data...');
    set(h1,'name','Loading')   
    
    for i = 1:size(sects)
        waitbar(i/size(sects,1))
        sct = sects{i};
        eval(['nplay = selections.PlayersList.',sct,';'])
        disp(' ')
        disp(['Loading:  ',sct])
        for d = 1:size(nplay)
            gamefolder = selections.Gamedir;
            playerdata = [selections.Gamedir filesep char(nplay(d))]; 

            %       Loading data
            switch selections.GPSType
                case 'QStarz'
                        [INDEX,TRACKID,VALID,UTCdatE,UTCTIME,LOCALdatE,LOCALTIME,MS,LATITUDE,NS,LONGITUDE,EW,ALTITUDE,SPEED,HEADING,GX,GY,GZ] = importgps(playerdata);
                        [x_coord, y_coord, lat_origin, long_origin] = GPS2Cart(LATITUDE,LONGITUDE,matcalib);  
                        dat = [[1:length(LATITUDE)]' , x_coord , y_coord , ALTITUDE , SPEED];
            
                case 'Stats Sports'
                    rawdata     = importStatsSports(playerdata);
                    LATITUDE    = str2double (rawdata(:,5));
                    LONGITUDE   = str2double (rawdata(:,6));
                    LOCALTIME   = char(rawdata(:,3));
                    SPEED       = str2double (rawdata (:,7)); 
                    [x_coord, y_coord, lat_origin, long_origin] = GPS2Cart_GPSports(LATITUDE,LONGITUDE,matcalib);  
                    dat = [[1:length(LATITUDE)]' , x_coord , y_coord, SPEED];
    
                case 'PlayerTek'
                    rawdata     = importPlayerTek(playerdata);
                    LATITUDE    = rawdata(:,3);
                    LONGITUDE   = rawdata(:,4);
                    ACC_X   = rawdata(:,5);
                    ACC_Y   = rawdata(:,6);
                    ACC_Z   = rawdata(:,7);
                    LOCALTIME = datestr(rawdata(:,1), 'HH:MM:SS');
                    [x_coord, y_coord, lat_origin, long_origin] = GPS2Cart_GPSports(LATITUDE,LONGITUDE,matcalib);  
                    dat = [[1:length(LATITUDE)]' ,x_coord , y_coord, ACC_X , ACC_Y, ACC_Z];

                case 'Dvideo'
                    rawdata = load(playerdata);
                    rawdata(:,all(rawdata <= -0.9999))=[];
                    if size(rawdata,2)>3
                        error ('Please enter a file of a single athlete')
                    end
                    x_coord = rawdata(:,2);
                    y_coord = rawdata(:,3);
                    dat = [[1:length(x_coord)]',x_coord , y_coord];
                case 'WIMU'

                    %             # Vers�o enviada pelo Prof. Jo�o (Mar�o/2021)
                    %             rawdata = importwimu(playerdata);
                    %             mTime = rawdata(:,1:3);
                    %             LATITUDE = rawdata(:,5);
                    %             LONGITUDE = rawdata(:,6);
                    %             [x_coord, y_coord, lat_origin, long_origin] = GPS2Cart_GPSports(LATITUDE,LONGITUDE,matcalib);  
                    %             dat = [[1:length(x_coord)]',x_coord , y_coord];
                    
                    % Vers�o enviada pelo Alberto (Out/2021)
                    rawdata     = importdata(playerdata);
                    LATITUDE    = rawdata.data(:,1); 
                    LONGITUDE   = rawdata.data(:,2);
                    text        = rawdata.textdata;
                    mTime       = cell2mat(text(2:end,1));
                    mTime       = mTime(:,1:end-4);
                    
                    [x_coord, y_coord, lat_origin, long_origin] = GPS2Cart_GPSports(LATITUDE,LONGITUDE,matcalib);  
                    dat = [[1:length(x_coord)]',x_coord , y_coord];            

                case 'Vector S7'
                    rawdata     = importVectorS7(playerdata);
                    LATITUDE    = str2double (strrep(rawdata(:,2), ',', '.'));
                    LONGITUDE   = str2double (strrep(rawdata(:,3), ',', '.')); 
                    LOCALTIME   = datestr(rawdata(:,1), 'HH:MM:SS');
                    [x_coord, y_coord, lat_origin, long_origin] = GPS2Cart_GPSports(LATITUDE,LONGITUDE,matcalib);
                    dat = [[1:length(x_coord)]',x_coord , y_coord];
        
        
                case 'Polar Team'
                    % Lat and Long
                    gpxfiles = dir(fullfile(playerdata, '*.gpx'));
                    gpxfile = [playerdata,filesep,gpxfiles.name];
                    rawdata     = gpxread(gpxfile);
                    LATITUDE    = rawdata.Latitude';
                    LONGITUDE   = rawdata.Longitude';
                    
                    % Time
                    csvfiles = dir(fullfile(playerdata, '*.csv'));
                    csvfile = [playerdata,filesep,csvfiles.name];
                    opts = detectImportOptions(csvfile);  % Automatically detect data types
                    data = readtable(csvfile, opts);  % Read data using the detected options
                    LOCALTIME   = datestr(data.Hora, 'HH:MM:SS');
                    if size(LOCALTIME,1)>size(LATITUDE,1)
                        dat_lat_long = [LATITUDE, LONGITUDE];
                        dat_lat_long = interpoladat(dat_lat_long,size(LOCALTIME,1));
                        LATITUDE = dat_lat_long(:,1);
                        LONGITUDE = dat_lat_long(:,2);
                    end
                    [x_coord, y_coord, lat_origin, long_origin] = GPS2Cart_GPSports(LATITUDE,LONGITUDE,matcalib);
                    dat = [[1:length(LOCALTIME)]',x_coord , y_coord];
    
                case 'Kinexon'
                    rawdata     = readtable(playerdata); 
                    LATITUDE    = rawdata.latitudeInDeg;
                    LONGITUDE   = rawdata.longitudeInDeg;
                    LOCALTIME   = datestr(rawdata.formattedLocalTime, 'HH:MM:SS');
                    if size(LOCALTIME,1)>size(LATITUDE,1)
                        dat_lat_long = [LATITUDE, LONGITUDE];
                        dat_lat_long = interpoladat(dat_lat_long,size(LOCALTIME,1));
                        LATITUDE = dat_lat_long(:,1);
                        LONGITUDE = dat_lat_long(:,2);
                    end
                    [x_coord, y_coord, lat_origin, long_origin] = GPS2Cart_GPSports(LATITUDE,LONGITUDE,matcalib);
                    dat = [[1:length(LOCALTIME)]',x_coord , y_coord];
        
                otherwise 
                    disp(' ')
                    disp('This GPS brand is not available yet.')
                    disp('We are working to release it as soon as possible.')
                    error ('----- Select the GPS type ---- ')
        
            end

            %       Cropping based on the game time
            switch selections.GPSType
                case 'Dvideo'
                    mTimes = [(0:size(dat,1)-1)/str2double(freq)]';
                
                case 'WIMU'
                    mTime =  datevec(mTime); %vetor do tempo de jogo ('xx:yy:zz')
                    mTimes = (mTime(:,4)*3600) + (mTime(:,5)*60) +mTime(:,6); %vetor em segundos
                
                case 'Polar Team'
                    mTime = datevec(LOCALTIME); %vetor do tempo de jogo ('xx:yy:zz')
                    mTimes = (mTime(:,4)*3600) + (mTime(:,5)*60) +mTime(:,6); %vetor em segundos
                
                otherwise
                    mTime = datevec(LOCALTIME); %vetor do tempo de jogo ('xx:yy:zz')
                    mTimes = (mTime(:,4)*3600) + (mTime(:,5)*60) +mTime(:,6); %vetor em segundos
            end
        
            % Ajudando o tempo 
            ITime = find(mTimes==timeIs,1);
            FTime = find(mTimes==timeFs,1);
            dat = dat(ITime:FTime,:);
            
                
            %       Selecionado conjunto de dados
            dat = dat(:,1:3);
            
            %       Conferindo o valor de linhas de acordo com a frequencia 
            line_ecxpeted = (timeFs - timeIs) * str2double(freq);
            vtime = [(0:line_ecxpeted-1)/str2double(freq)]';

            %       Caso seja menor, � necess�rio interpolar os dados
            if size(dat,1) < line_ecxpeted
                data = dat(:,2:3);
                dat = interpoladat(data,line_ecxpeted);
                dat = [vtime,dat];
            elseif size(dat,1) > line_ecxpeted
                data = dat(:,2:3);
                dat = interpoladat(data,line_ecxpeted);
                dat = [vtime,dat];
            end
            
    
            %       Eliminando ru�dos/picos
            %             datSmothX_S = smooth(dat(:,2), 0.00160617, 'rloess'); % Smooth
            %             datSmothY_S = smooth(dat(:,3), 0.00160617, 'rloess'); % Smooth
            datSmothX_M = medfilt1 (dat(:,2));                    % Medfilt    
            datSmothY_M = medfilt1 (dat(:,3));                    % Medfilt             
            %             figure
            %             campo
            %             hold on
            %             plot(datSmothX_S,datSmothY_S,'r.')
            %             plot(datSmothX_M,datSmothY_M,'k.')
            %             plot(dat(:,2),dat(:,3),'r-')

            dat = [vtime,datSmothX_M(:,1),datSmothY_M(:,1)];

            %       Filtro
            clear a, clear b
            n=4; %  order
            Wn=str2double(lowpass)/(str2double(freq)/2); 
            [b,a]=butter(n,Wn);
            clear datf
            datf = filtfilt(b,a,dat);
    
            %       Creating structure with raw results
            eval([sct,'_RawDataArraw{',num2str(d),',1} = datf;'])
            eval(['allGPSdata.',sct,'=[',sct,'_RawDataArraw];'])
        end
    end
    close(h1)
end


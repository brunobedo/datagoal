function res = organizedatacollective(dataraw)
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
%   Organize all the collective data
    
global selections

    sizeDef = size(selections.PlayersList.Defender,1);
    sizeMid = size(selections.PlayersList.Midfielder,1);
    sizeFow = size(selections.PlayersList.Forwards,1);
    sizeOpo = size(selections.PlayersList.Opponent,1);
    sizeTotal = sum([sizeDef sizeMid sizeFow sizeOpo]);
    tmin = str2num(selections.totalGametime);
    tseg = tmin*60;
    sects = fieldnames(selections.PlayersList);
    
    for i = 1:size(sects)
        sct = sects{i};
        eval(['nplay = selections.PlayersList.',sct,';'])
        for d = 1:size(nplay)
            eval(['data = dataraw.',sct,'{',num2str(d),',1};']);
            eval(['datx_',sct,'(:,d) = timenormalize(data(:,2),1,size(data(:,2),1),tseg);'])
            eval(['daty_',sct,'(:,d) = timenormalize(data(:,3),1,size(data(:,3),1),tseg);'])           
        end
        if size(nplay) == 0 
            eval(['datx_',sct,' = [];'])
            eval(['daty_',sct,' = [];'])
        end      
    end
    res.X = [datx_Defender datx_Midfielder datx_Forwards];
    res.Y = [daty_Defender daty_Midfielder daty_Forwards];
    res.OpX = [datx_Opponent]; 
    res.OpY = [daty_Opponent];
end


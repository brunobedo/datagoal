function d = distanceGPS(latitude1, longitude1, latitude2, longitude2)   
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

    R = 6371000; % radius of earth in m        
    delta_lat = latitude2-latitude1;
    delta_long = longitude2-longitude1;
    aa = (sind(delta_lat/2))^2 + cosd(latitude1)*cosd(latitude2)*(sind(delta_long/2))^2;
    cc = 2*atan2d(sqrt(aa), sqrt(1-aa));
    d = R*cc*pi/180;
end

function [x_coord_nova, y_coord_nova, lat_origin, long_origin] = GPS2Cart_GPSports(lat,long,mcampo)   
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


% Identify most west (i.e. min longitude) and most south (i.e. min latitude)
% GPS points (not necesarily the same coordiante) to use as origin for 
% Cartesian system in the first quadrant
% NOTE: can choose different origin but will need to change change
% calculation of x_coord/y_coord accordingly
% lat_origin = min(lat);
% long_origin = min(long);
    lat_origin = mcampo(1,1);
    long_origin = mcampo(1,2);
    % lat = -lat; 
    % long = -long;

    % Compute Cartesian coords of GPS data relative to the origin calculated
    % above
    x_coord = zeros(1,length(lat));
    y_coord = zeros(1,length(lat));
    for ii =1:length(lat)    
        hypot = distanceGPS(lat_origin, long_origin, lat(ii), long(ii));
        [~,az] = distance(lat_origin, long_origin, lat(ii), long(ii));
        x_coord(ii) = hypot*sind(az);
        y_coord(ii) = hypot*cosd(az);
    end

    %  Passando as coordenadas do campo para X e Y
    x_coordc = zeros(1,size(mcampo,2));
    y_coordc = zeros(1,size(mcampo,2));

    for ii = 1:size(mcampo,2)
        hypotc = distanceGPS(lat_origin, long_origin, mcampo(ii+1,1), mcampo(ii+1,2));
        [~,azc] = distance(lat_origin, long_origin, mcampo(ii+1,1), mcampo(ii+1,2));
        x_coordc(ii) = hypotc.*sind(azc);
        y_coordc(ii) = hypotc.*cosd(azc);
    end

    v1_base = ([x_coordc(1) y_coordc(1)])/norm(([x_coordc(1) y_coordc(1)]));
    v2_base = ([x_coordc(2) y_coordc(2)])/norm(([x_coordc(2) y_coordc(2)]));

    Bcamp = [v1_base' v2_base'];
    met_coord = Bcamp'*[x_coord ; y_coord];

    x_coord_nova = met_coord(1,:)';
    y_coord_nova = met_coord(2,:)';

end

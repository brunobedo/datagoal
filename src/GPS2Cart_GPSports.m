function [x_coord_nova, y_coord_nova, lat_origin, long_origin] = GPS2Cart_GPSports(lat,long,mcampo)   
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 

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

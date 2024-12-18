function [dens2]=heatmap(dados)
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

    % f1 = figure(1); clf; set(f1,'name','Displacement','units','normalized','outerposition',[0 0 1 1])
    campo3d
    % gridx1 = 0:1:110;
    % gridx2 = 0:1:75;
    % [x1,x2] = meshgrid(gridx1, gridx2);
    % x1 = x1(:);
    % x2 = x2(:);
    % xi = [x1 x2];
    gridx1 = 0:1:110;
    gridx2 = 0:1:75;
    [x1,x2] = meshgrid(gridx1, gridx2);
    x1 = x1(:);
    x2 = x2(:);
    xi = [x1 x2];
    dens = ksdensity(dados,xi);
    dens2=reshape(dens,size(gridx2,2),size(gridx1,2));
    surf(gridx1,gridx2,dens2)
    view(0,90)
    shading interp
    grid off
    daspect([1 1 .1])
end


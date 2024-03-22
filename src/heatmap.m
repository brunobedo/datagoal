function [dens2]=heatmap(dados)
%   Calculates the heat map
%   This file is part of DataGoal Toolbox:
%   Adapta��o do c�digo criado pelo Prof. Felipe Moura (UEL). 
%   A partir de dados x e y do jogador, retorna o mapa de calor do jogador

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


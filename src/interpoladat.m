function [datinterp]=interpoladat(coord2d,npontos);
% Interpola os dados para um tamanho conhecido
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 

x=1:size(coord2d,1);
xx=linspace(1,size(coord2d,1),npontos);
datinterp(:,1)=interp1(x,coord2d(:,1),xx);
datinterp(:,2)=interp1(x,coord2d(:,2),xx);

end

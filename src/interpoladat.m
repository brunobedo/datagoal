function [datinterp]=interpoladat(data2d,nppoints)
% Interpola os dados para um tamanho conhecido
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 

x=1:size(coord2d,1);
X=linspace(1,size(coord2d,1),nppoints);
datinterp(:,1)=interp1(x,coord2d(:,1),X);
datinterp(:,2)=interp1(x,coord2d(:,2),X);

end

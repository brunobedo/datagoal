function[]=campo()
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
%

global selections
comp = str2double(selections.fieldwidth);
larg = str2double(selections.fieldheight);
tam = [comp larg];
if comp >=70
    campo_grande(tam)
else
    campo_pequeno(tam)
end

end

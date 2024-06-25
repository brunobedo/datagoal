function[]=campo3d_pequeno(tam)
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
    if nargin==0,tam=[105 68];end
    %
    comp=tam(1);larg=tam(2);
    plot3(0,0,8000,'w','LineWidth',3);hold on;axis([0 comp 0 larg]);
    %linha central
    plot3([(comp/2)-.005 (comp/2)-0.005],[0 larg],[8000 8000],'w-','LineWidth',2)
    % % divisoes campo
    % plot([comp/6 comp/6],[0 larg],'b-');
    % plot([2*comp/6 2*comp/6],[0 larg],'b-');
    % plot([3*comp/6 3*comp/6],[0 larg],'b-');
    % plot([4*comp/6 4*comp/6],[0 larg],'b-');
    % plot([5*comp/6 5*comp/6],[0 larg],'b-');
    % 
    % plot([0 comp],[larg/3 larg/3],'b-');
    % plot([0 comp],[2*larg/3 2*larg/3],'b-');
    %linhas fundo
    plot3([0 0],[0 larg],[8000 8000],'w-','LineWidth',3);
    plot3([comp comp],[0 larg],[8000 8000],'w-','LineWidth',3);

    %linhas laterais
    plot3([0 comp],[0 0],[8000 8000],'w-','LineWidth',3);
    plot3([0 comp],[larg larg],[8000 8000],'w-','LineWidth',3)

    % Grandes areas
    % Esquerda 
    plot3([comp*0.16 comp*0.16],[(larg/2)-comp*0.16 (larg/2)+comp*0.16],[8000 8000],'w-','LineWidth',2);
    plot3([0 comp*0.16],[(larg/2)-comp*0.16 (larg/2)-comp*0.16],[8000 8000],'w-','LineWidth',2);
    plot3([0 comp*0.16],[(larg/2)+comp*0.16 (larg/2)+comp*0.16],[8000 8000],'w-','LineWidth',2);

    % Direita 
    plot3([comp*0.84 comp*0.84],[(larg/2)-comp*0.16 (larg/2)+comp*0.16],[8000 8000],'w-','LineWidth',2);
    plot3([comp-comp*0.16 comp],[(larg/2)-comp*0.16 (larg/2)-comp*0.16],[8000 8000],'w-','LineWidth',2);
    plot3([comp-comp*0.16 comp],[(larg/2)+comp*0.16 (larg/2)+comp*0.16],[8000 8000],'w-','LineWidth',2);

    plot3([comp*0.84 comp*0.84],[(larg/2)-comp*0.16 (larg/2)+comp*0.16],[8000 8000],'w-','LineWidth',2);
    plot3([comp*0.84 comp*0.84],[(larg/2)-comp*0.16 (larg/2)+comp*0.16],[8000 8000],'w-','LineWidth',2);
    plot3([comp*0.84 comp*0.84],[(larg/2)-comp*0.16 (larg/2)+comp*0.16],[8000 8000],'w-','LineWidth',2);

    %pequenas areas
    % Esquerda
    plot3([comp*0.07 comp*0.07],[(larg/2)-comp*0.07 (larg/2)+comp*0.07],[8000 8000],'w-','LineWidth',2);
    plot3([0 comp*0.07],[(larg/2)-comp*0.07 (larg/2)-comp*0.07],[8000 8000],'w-','LineWidth',2);
    plot3([0 comp*0.07],[(larg/2)+comp*0.07 (larg/2)+comp*0.07],[8000 8000],'w-','LineWidth',2);

    % Direita 
    plot3([comp*0.93 comp*0.93],[(larg/2)-comp*0.07 (larg/2)+comp*0.07],[8000 8000],'w-','LineWidth',2);
    plot3([comp-comp*0.07 comp],[(larg/2)-comp*0.07 (larg/2)-comp*0.07],[8000 8000],'w-','LineWidth',2);
    plot3([comp-comp*0.07 comp],[(larg/2)+comp*0.07 (larg/2)+comp*0.07],[8000 8000],'w-','LineWidth',2);

    %penalti
    plot3(comp*0.1,larg/2,[8000 8000],'w.','LineWidth',2);
    plot3(comp-comp*0.1,larg/2,[8000 8000],'w.','LineWidth',2);
    plot3(comp/2,larg/2,[8000 8000],'w.','LineWidth',2);

    % %circulos
    % ang1=linspace(-pi,pi,100);
    % x1=(9.15*cos(ang1))+comp/2;
    % y1=(9.15*sin(ang1))+larg/2;
    % plot3(x1,y1,ones(size(x1)).*8000,'w','LineWidth',2);plot3(11,larg/2,8000,'w.','MarkerSize',8);plot3((comp/2)-0.26,larg/2,8000,'w.','MarkerSize',8);plot3(comp-11,larg/2,8000,'w.','MarkerSize',8);
    % ang2=linspace(-pi/3.5,pi/3.5,100);
    % x2=(9.15*cos(ang2))+11;
    % y2=(9.15*sin(ang2))+larg/2;
    % plot3(x2,y2,ones(size(x2)).*8000,'w','LineWidth',2)
    % ang3=linspace((-pi/3.5)+pi,(pi/3.5)+pi,100);
    % x3=(9.15*cos(ang3))+comp-11;
    % y3=(9.15*sin(ang3))+larg/2;
    % plot3(x3,y3,ones(size(x3)).*8000,'w','LineWidth',2)
    xlabel('X (m)');
    ylabel('Y (m)');
    %text(comp/4.4,-8,'DEFESA')
    %text(106/5,-11,'DEFESA') % Sugestï¿½o para colocar o texto qdo usar o
    %subplot
    %text(comp/1.375,-8,'ATAQUE')
    axis off
    % text(106/1.5,-11,'ATAQUE') % Sugestï¿½o para colocar o texto qdo usar o
    %subplot
end
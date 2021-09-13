function[]=campo(tam)
% This file is part of DataGoal Toolbox: 
% 
% Author:   Bruno Luiz Souza Bedo <bruno.bedo@usp.br> 
%
% Rotina criada por Preto (Paulo R. P. Santiago)
% 08/02/05 ultima atualizaçao  
%
% Cria um grafico com o campo de futebol
% Digite o nome da rotina "campo" na janela de comando

if nargin==0,tam=[100 65];end

%
%

% figure

% whitebg([0 0.5 0]);
c = [0 0.7 0];
set(gca,'Color',c)
% colordef('white')
% set(gca,'xtick',[])
% set(gca,'xticklabel',[])

comp=tam(1);larg=tam(2);

% cor do campo

% line([comp/2 comp/2],[-5 larg+5],'LineWidth',1000,'Color',[0 .7 .0])
% hold on;
axis([-5 comp+5 -5 larg+5]);
% line([comp/2 comp/2],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0])
% 
% line([comp/10 comp/10],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0])
% line([comp-10 comp-10],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0])

% line([comp/4 comp/4],[-5 larg+5],'LineWidth',500,'Color',[0 .7 .0])
% hold on;
% axis([-5 comp+5 -5 larg+5]);
% line([comp/2 comp/2],[-5 larg+5],'LineWidth',200,'Color',[0 .5 .0]) %Verde escuro
% line([comp/10 comp/10],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0]) %verde escuro
% line([comp-10 comp-10],[-5 larg+5],'LineWidth',80,'Color',[0 .5 .0])%verde escuro
% 

%linha central
line([comp/2 comp/2],[0 larg],'Color','w','LineWidth',2.5)
hold on
%linhas fundo
line([0 0],[0 larg],'Color','w','LineWidth',2.5)
line([comp comp],[0 larg],'Color','w','LineWidth',2.5)


%linhas laterais
line([0 comp],[0 0],'Color','w','LineWidth',2.5)
line([0 comp],[larg larg],'Color','w','LineWidth',2.5)


%grandes areas
line([0 16.5],[(larg/2)-20.16 (larg/2)-20.16],'Color','w','LineWidth',2.5)
line([0 16.5],[(larg/2)+20.16 (larg/2)+20.16],'Color','w','LineWidth',2.5)
line([16.5 16.5],[(larg/2)-20.16 (larg/2)+20.16],'Color','w','LineWidth',2.5)
line([0 5.5],[(larg/2)-9.16 (larg/2)-9.16],'Color','w','LineWidth',2.5)
line([5.5 5.5],[(larg/2)-9.16 (larg/2)+9.16],'Color','w','LineWidth',2.5)
line([comp-16.5 comp],[(larg/2)-20.16 (larg/2)-20.16],'Color','w','LineWidth',2.5)
line([comp-16.5 comp],[(larg/2)+20.16 (larg/2)+20.16],'Color','w','LineWidth',2.5)
line([comp-16.5 comp-16.5],[(larg/2)-20.16 (larg/2)+20.16],'Color','w','LineWidth',2.5)


%pequenas areas
line([0 5.5],[(larg/2)-9.16 (larg/2)-9.16],'Color','w','LineWidth',2.5)
line([5.5 5.5],[(larg/2)-9.16 (larg/2)+9.16],'Color','w','LineWidth',2.5)
line([0 5.5],[(larg/2)+9.16 (larg/2)+9.16],'Color','w','LineWidth',2.5)
line([comp-5.5 comp],[(larg/2)-9.16 (larg/2)-9.16],'Color','w','LineWidth',2.5)
line([comp-5.5 comp],[(larg/2)+9.16 (larg/2)+9.16],'Color','w','LineWidth',2.5)
line([comp-5.5 comp-5.5],[(larg/2)-9.16 (larg/2)+9.16],'Color','w','LineWidth',2.5)
line([comp-5.5 comp],[(larg/2)-9.16 (larg/2)-9.16],'Color','w','LineWidth',2.5)
line([comp-5.5 comp],[(larg/2)+9.16 (larg/2)+9.16],'Color','w','LineWidth',2.5)
line([comp-5.5 comp-5.5],[(larg/2)-9.16 (larg/2)+9.16],'Color','w','LineWidth',2.5)

%circulos

centro = plot(.14+comp/2,larg/2,'w');
set(centro,'Marker','.')   
set(centro,'MarkerSize',20)

penalti = plot(11,larg/2,'w',comp-11,larg/2,'w');
set(penalti,'Marker','.')   
set(penalti,'MarkerSize',20)

ang1=linspace(-pi,pi,100);
x1=(9.15*cos(ang1))+comp/2;
y1=(9.15*sin(ang1))+larg/2;
line(x1,y1,'Color','w','LineWidth',2.5)

ang2=linspace(-pi/3.5,pi/3.5,100);
x2=(9.15*cos(ang2))+11;
y2=(9.15*sin(ang2))+larg/2;
line(x2,y2,'Color','w','LineWidth',2.5)

ang3=linspace((-pi/3.5)+pi,(pi/3.5)+pi,100);
x3=(9.15*cos(ang3))+comp-11;
y3=(9.15*sin(ang3))+larg/2;
line(x3,y3,'Color','w','LineWidth',2.5)

daspect([1 1 1])

% set(gca,'TickLength',[0 0])
set(gca,'XTick',[], 'YTick', [],'XColor',c,'YColor',c)
% text(comp/4.4,-3,'ATAQUE','FontSize',12)
% text(comp/1.375,-3,'DEFESA','FontSize',12)

end

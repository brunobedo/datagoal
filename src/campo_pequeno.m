function[]=campo_pequeno(tam)
if nargin==0,tam=[40 20];end
%
% Rotina criada por Sergio Cunha em 26/09/04
%
c = [0 0.7 0];
set(gca,'Color',c)

comp=tam(1);larg=tam(2);
hold on;axis([0-2 comp+2 0-2 larg+2]);
%linha central
plot([comp/2 comp/2],[0 larg],'w-','LineWidth',2.5)
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
plot([0 0],[0 larg],'w-',[comp comp],[0 larg],'w-','LineWidth',2.5)
%linhas laterais
plot([0 comp],[0 0],'w-',[0 comp],[larg larg],'w-','LineWidth',2.5)

%circulo central
ang1=linspace(-pi,pi,100);
x1=(3*cos(ang1))+comp/2;
y1=(3*sin(ang1))+larg/2;
% plot(x1,y1,'k',11,larg/2,'k.',comp/2,larg/2,'k.',comp-11,larg/2,'k.')
plot(x1,y1,'w','LineWidth',2.5)

%areas
% ang2=linspace(-pi/2,pi/2,100);
% x2=(6*cos(ang2));
% y2=(6*sin(ang2))+larg/2;
% plot(x2,y2,'k')
% 
% ang3=linspace((-pi/2)+pi,(pi/2)+pi,100);
% x2=(6*cos(ang3))+comp;
% y2=(6*sin(ang3))+larg/2;
% plot(x2,y2,'k')

% plot([6 6],[8.5 11.5],'w')

% line([0 15],[(larg/2)-14.00 (larg/2)-15.00],'Color','w','LineWidth',2.5)
% line([0 15],[(larg/2)+14.00 (larg/2)+15.00],'Color','w','LineWidth',2.5)

% Area esquerda
% Grande
line([comp*0.16 comp*0.16],[(larg/2)-comp*0.16 (larg/2)+comp*0.16],'Color','w','LineWidth',2.5)
line([0 comp*0.16],[(larg/2)-comp*0.16 (larg/2)-comp*0.16],'Color','w','LineWidth',2.5)
line([0 comp*0.16],[(larg/2)+comp*0.16 (larg/2)+comp*0.16],'Color','w','LineWidth',2.5)

% Pequena
line([comp*0.07 comp*0.07],[(larg/2)-comp*0.07 (larg/2)+comp*0.07],'Color','w','LineWidth',2.5)
line([0 comp*0.07],[(larg/2)-comp*0.07 (larg/2)-comp*0.07],'Color','w','LineWidth',2.5)
line([0 comp*0.07],[(larg/2)+comp*0.07 (larg/2)+comp*0.07],'Color','w','LineWidth',2.5)



% Area direita
% Grande
line([comp*0.84 comp*0.84],[(larg/2)-comp*0.16 (larg/2)+comp*0.16],'Color','w','LineWidth',2.5)
line([comp-comp*0.16 comp],[(larg/2)-comp*0.16 (larg/2)-comp*0.16],'Color','w','LineWidth',2.5)
line([comp-comp*0.16 comp],[(larg/2)+comp*0.16 (larg/2)+comp*0.16],'Color','w','LineWidth',2.5)

% Pequena
line([comp*0.93 comp*0.93],[(larg/2)-comp*0.07 (larg/2)+comp*0.07],'Color','w','LineWidth',2.5)
line([comp-comp*0.07 comp],[(larg/2)-comp*0.07 (larg/2)-comp*0.07],'Color','w','LineWidth',2.5)
line([comp-comp*0.07 comp],[(larg/2)+comp*0.07 (larg/2)+comp*0.07],'Color','w','LineWidth',2.5)


%penalti
plot(comp*0.1,larg/2,'w.','MarkerSize',15)
plot(comp-comp*0.1,larg/2,'w.','MarkerSize',15)
plot(comp/2,larg/2,'w.','MarkerSize',15)

% linha do 10 m
% plot([10 10],[9.5 10.5],'w','LineWidth',2.5)
% plot([comp 25],[9.5 10.5],'w','LineWidth',2.5)

% quadrantes1=[10 10; 0 20];
% quadrantes2=[30 30; 0 20];
% quadrantes3=[0 40;  6.6  6.6];
% quadrantes4=[0 40; 13.2 13.2];
% 
% plot(quadrantes1(1,:),quadrantes1(2,:),'k:')
% plot(quadrantes2(1,:),quadrantes2(2,:),'k:')
% 
% plot(quadrantes3(1,:),quadrantes3(2,:),'k:')
% plot(quadrantes4(1,:),quadrantes4(2,:),'k:')


%xlim([-1.5 comp+1.5])
%ylim([-1.5 larg+1.5])
% xlabel('X (m)');
% ylabel('Y (m)');
% text(comp/2-15,-5,'DEFESA','color','k')
%text(106/5,-11,'DEFESA') % Sugestão para colocar o texto qdo usar o
%subplot
% text(comp/1-12,-5,'ATAQUE','color','k')
% text(106/1.5,-11,'ATAQUE') % Sugestão para colocar o texto qdo usar o
%subplot
% daspttect([1 1 1]);
% set(gca,'XColor','k');
% set(gca,'YColor','k');
% axis off
daspect([1 1 1])

% set(gca,'TickLength',[0 0])
set(gca,'XTick',[], 'YTick', [],'XColor',c,'YColor',c)
% text(comp/4.4,-3,'ATAQUE','FontSize',12)
% text(comp/1.375,-3,'DEFESA','FontSize',12)
end
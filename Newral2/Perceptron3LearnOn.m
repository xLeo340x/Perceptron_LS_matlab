clear variables;
clc;
close all;

flag=1;  %%% Подолжить обучение 1;  Начать заново, удалив всё, что работало 0;

Kol_train=60000; %%% Есть тренировочных сетов.

po_skolko=900;
Otkuda=0;

%%% Входы по строкам
for i=Otkuda+1:1:Otkuda+po_skolko
    
    k=i-Otkuda;
    [Num,inpu(k,:)]=inputting(i);
    
    target(k,:)=zeros(1,10);
    target(k,Num)=1;
    
end

inpu=[inpu./256, ones(size(inpu,1),1)];
   
%%% Верные результаты по строкам



Kol_hid=[200,190]; %%% Размеры скрытых слоёв !!!!! ЭТОТ ВЕКТОР СОЗДАЁТ ВСЮ СЕТЬ

Kol_input=size(inpu,2); %%% Количество входов
Kol_target=size(target,2);  %%% Количество выходов
Kol_sloy=[Kol_input,Kol_hid,Kol_target]; %%% Количество нейронов в слоях

N=length(Kol_sloy'); %%% Количество слоёв

weight   =cell(1,N-1);
delW     =cell(1,N-1);
errorHid =cell(1,N-1);
delta    =cell(1,N-1);
sloy     =cell(1,N);


%%% Веса со входа до выхода
if flag
    for i=1:1:N-1
        s=strcat('weight',num2str(i),'.xls');
        weight{i}=readmatrix(s);
    end
else
    for i=2:1:N
        weight{i-1}=rand( Kol_sloy(i), Kol_sloy(i-1) )/10;
    end
end

a=0.3; %%% Коэффициент обучения

tic;

time=100;
loadin=fix(time/100);
os_t=[1:1:time];

for epoh=1:1:time
    
    %%%%
    prav_50(epoh)=0;
    %%%%
    
    if mod(epoh,loadin)==0
       epoh/loadin
    end
    
%     i=0;
%     while i<size(inpu,1)
%         i=i+1;
    for i=1:1:size(inpu,1)
        
        %%% Подсчёт выхода
        sloy{1}=inpu(i,:);
        sloy=circle(sloy,weight,N);
        
        %%% Обратное распространение
        for H=N:-1:2
            if H==N
                
                %%%%
%                 sloy{H}(sloy{H}>0.99)=1;
%                 sloy{H}(sloy{H}<0.01)=0;
                %%%%
                
                errorHid{H-1}=target(i,:)-sloy{H};
                
            else
                errorHid{H-1}=errorHid{H}*weight{H};
            end
            delta{H-1}=errorHid{H-1}.*(1-sloy{H}).*sloy{H};
            delW{H-1}=a*delta{H-1}'*sloy{H-1};
        end
        
        %%% Редактирование весов
        for H=1:1:N-1
            weight{H}=weight{H}+delW{H};
        end
        
        
        %%%% Расчет правильности на всех вариантах входов для этой эпохи
        prav_50(epoh)=prav_50(epoh)+(sum(sloy{N}.*target(i,:)));
        %%%%
        
    end
    
    %%%%
    plot(os_t(1:epoh),prav_50);
    %%%%
    
end

time = toc

%  in=imread('train/000002-num4.png');
% 
% 
% j=0;
% for y=1:2:size(in,1)
%     for x=1:2:size(in,2)
%         j=j+1;
%         Im(j)=double(in(y,x));
%     end
% end
% 
% Im=[Im./256, ones(size(Im,1),1)];
% % Im=inpu;
% sloy{1}=Im;
% sloy=circle(sloy,weight,N);
% (sloy{end})

%%%%%%

for i=1:1:N-1
    i
    s=strcat('weight',num2str(i),'.xls');
    k=weight{i};
    writematrix(k,s);
end
writematrix(N,'N.xls');

%%%%%%

function f=activ(aaa)

f=1./(1 + exp(-aaa));

end

function sloy=circle(sloy,weight,N)
for i=1:1:N-1
    sloy{i+1}=activ(sloy{i}*weight{i}');
end
end






